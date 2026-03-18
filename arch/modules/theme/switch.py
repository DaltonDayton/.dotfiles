#!/usr/bin/env python3
"""Theme switcher — renders Jinja2 templates with palette colors and reloads apps."""

import argparse
import os
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

THEME_DIR = Path(__file__).resolve().parent
PALETTES_DIR = THEME_DIR / "palettes"
TEMPLATES_DIR = THEME_DIR / "templates"
GENERATED_DIR = THEME_DIR / "generated"
WALLPAPERS_DIR = THEME_DIR / "wallpapers"
CURRENT_FILE = THEME_DIR / "current.toml"

# ---------------------------------------------------------------------------
# Jinja2 filters
# ---------------------------------------------------------------------------


def strip_hash(value: str) -> str:
    """#1e1e2e → 1e1e2e"""
    return value.lstrip("#")


def upper_hex(value: str) -> str:
    """#1e1e2e → #1E1E2E"""
    return value.upper() if value.startswith("#") else f"#{value.upper()}"


def to_rgb(value: str) -> str:
    """#1e1e2e → 30, 30, 46"""
    h = strip_hash(value)
    return f"{int(h[0:2], 16)}, {int(h[2:4], 16)}, {int(h[4:6], 16)}"


def to_rgba(value: str, alpha: float = 1.0) -> str:
    """#1e1e2e → rgba(30, 30, 46, 1.0)"""
    return f"rgba({to_rgb(value)}, {alpha})"


def to_rgb_r(value: str) -> int:
    """#1e1e2e → 30"""
    return int(strip_hash(value)[0:2], 16)


def to_rgb_g(value: str) -> int:
    """#1e1e2e → 30"""
    return int(strip_hash(value)[2:4], 16)


def to_rgb_b(value: str) -> int:
    """#1e1e2e → 46"""
    return int(strip_hash(value)[4:6], 16)


# ---------------------------------------------------------------------------
# Palette loading
# ---------------------------------------------------------------------------


def list_palettes() -> list[str]:
    """Return sorted list of available palette names (without .toml extension)."""
    return sorted(p.stem for p in PALETTES_DIR.glob("*.toml"))


def load_palette(name: str) -> dict:
    """Load a palette TOML file and return the parsed dict."""
    path = PALETTES_DIR / f"{name}.toml"
    if not path.exists():
        print(f"Error: palette '{name}' not found at {path}", file=sys.stderr)
        print(f"Available palettes: {', '.join(list_palettes())}", file=sys.stderr)
        sys.exit(1)
    with open(path, "rb") as f:
        return tomllib.load(f)


def get_current_theme() -> str | None:
    """Read the currently active theme name from current.toml."""
    if not CURRENT_FILE.exists():
        return None
    with open(CURRENT_FILE, "rb") as f:
        data = tomllib.load(f)
    return data.get("theme")


def save_current_theme(name: str) -> None:
    """Write the active theme name to current.toml."""
    with open(CURRENT_FILE, "w") as f:
        f.write(f'theme = "{name}"\n')


# ---------------------------------------------------------------------------
# Template rendering
# ---------------------------------------------------------------------------


def build_template_context(palette: dict) -> dict:
    """Flatten palette into a template context dict.

    Colors are available as top-level names (e.g., {{ base }}, {{ mauve }}).
    Terminal colors are nested under 'terminal' (e.g., {{ terminal.color0 }}).
    UI accent colors are nested under 'ui' (e.g., {{ ui.accent }}).
    Meta and integrations are nested under 'meta' and 'integrations'.
    """
    ctx = {}
    ctx.update(palette.get("colors", {}))
    ctx["terminal"] = palette.get("terminal", {})
    ctx["ui"] = palette.get("ui", {})
    ctx["meta"] = palette.get("meta", {})
    ctx["integrations"] = palette.get("integrations", {})
    ctx["device"] = get_device_name()
    ctx["monitors"] = get_monitors()
    return ctx


def create_jinja_env() -> Environment:
    """Create a Jinja2 environment with custom filters."""
    env = Environment(
        loader=FileSystemLoader(str(TEMPLATES_DIR)),
        keep_trailing_newline=True,
        trim_blocks=False,
        lstrip_blocks=False,
    )
    env.filters["strip_hash"] = strip_hash
    env.filters["upper_hex"] = upper_hex
    env.filters["to_rgb"] = to_rgb
    env.filters["to_rgba"] = to_rgba
    env.filters["to_rgb_r"] = to_rgb_r
    env.filters["to_rgb_g"] = to_rgb_g
    env.filters["to_rgb_b"] = to_rgb_b
    return env


def render_templates(
    env: Environment, context: dict, dry_run: bool = False
) -> list[str]:
    """Render all .j2 templates and write output to generated/.

    Returns a list of relative paths that were rendered.
    """
    rendered = []

    for template_path in sorted(TEMPLATES_DIR.rglob("*.j2")):
        # Relative path from templates dir, e.g., "kitty.conf.j2"
        rel = template_path.relative_to(TEMPLATES_DIR)
        # Output path: strip .j2 extension
        out_rel = rel.with_suffix("")
        out_path = GENERATED_DIR / out_rel

        # Load and render
        template = env.get_template(str(rel))
        rendered_content = template.render(**context)

        if dry_run:
            print(f"  [preview] {rel} → generated/{out_rel}")
        else:
            out_path.parent.mkdir(parents=True, exist_ok=True)
            with open(out_path, "w") as f:
                f.write(rendered_content)
            print(f"  [render]  {rel} → generated/{out_rel}")

        rendered.append(str(out_rel))

    return rendered


# ---------------------------------------------------------------------------
# Symlink wiring
# ---------------------------------------------------------------------------

# Maps generated file paths to their config destinations.
# Destinations are relative to the dotfiles modules dir or use ~ for $HOME.
# Since ~/.config/<app> directories are already symlinked to the module dirs,
# we symlink generated files into the module dirs so they're served automatically.
MODULES_DIR = THEME_DIR.parent

SYMLINK_MAP: dict[str, str] = {
    "kitty/kitty-theme.conf": "~/.config/kitty/kitty-theme.conf",
    "swaync/style.css": str(MODULES_DIR / "hyprland/swaync/style.css"),
    "swaync/config.json": str(MODULES_DIR / "hyprland/swaync/config.json"),
    "waybar/palette.css": str(MODULES_DIR / "hyprland/waybar/palette.css"),
    "waybar/style.css": str(MODULES_DIR / "hyprland/waybar/style.css"),
    "waybar/config.jsonc": str(MODULES_DIR / "hyprland/waybar/config.jsonc"),
    "hyprland/colors.conf": str(MODULES_DIR / "hyprland/hypr/colors.conf"),
    "hyprlock/hyprlock.conf": str(MODULES_DIR / "hyprland/hypr/hyprlock.conf"),
    "tmux/colors.conf": "~/.config/tmux/colors.conf",
    "rofi/theme.rasi": "~/.config/rofi/theme.rasi",
    "rofi/config.rasi": "~/.config/rofi/config.rasi",
}


def create_symlinks(rendered: list[str], dry_run: bool = False) -> None:
    """Create symlinks from config destinations to generated files."""
    if not rendered:
        return

    print("\nSymlinks:")
    for rel_path in rendered:
        if rel_path not in SYMLINK_MAP:
            continue

        source = GENERATED_DIR / rel_path
        dest = Path(SYMLINK_MAP[rel_path]).expanduser()

        if dry_run:
            print(f"  [preview] {dest} → {source}")
            continue

        # Ensure parent directory exists
        dest.parent.mkdir(parents=True, exist_ok=True)

        # Remove existing file/symlink
        if dest.exists() or dest.is_symlink():
            dest.unlink()

        dest.symlink_to(source)
        print(f"  [link]    {dest} → {source}")


# ---------------------------------------------------------------------------
# Wallpaper management
# ---------------------------------------------------------------------------

HYPRPAPER_CONF = Path("~/.config/hypr/hyprpaper.conf").expanduser()
DEVICE_ENV = THEME_DIR.parent.parent / "device.env"


def get_device_name() -> str:
    """Read DEVICE_NAME from device.env, defaulting to 'default'."""
    if not DEVICE_ENV.exists():
        return "default"
    for line in DEVICE_ENV.read_text().splitlines():
        line = line.strip()
        if line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        if key.strip() == "DEVICE_NAME":
            return value.strip()
    return "default"


def get_monitors() -> list[str]:
    """Detect active monitors via hyprctl, sorted by ID (primary first)."""
    try:
        result = subprocess.run(
            ["hyprctl", "monitors", "-j"],
            capture_output=True,
            text=True,
            timeout=5,
        )
        if result.returncode == 0:
            import json

            monitors = json.loads(result.stdout)
            monitors.sort(key=lambda m: m["id"])
            return [m["name"] for m in monitors]
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return []


def get_wallpapers(palette_name: str) -> list[Path]:
    """Get wallpapers for a theme, sorted by name."""
    theme_dir = WALLPAPERS_DIR / palette_name
    if not theme_dir.exists():
        return []
    exts = {".jpg", ".jpeg", ".png", ".webp"}
    return sorted(p for p in theme_dir.iterdir() if p.suffix.lower() in exts)


def apply_wallpapers(palette_name: str, dry_run: bool = False) -> None:
    """Set wallpapers from the theme's wallpaper directory via hyprpaper."""
    wallpapers = get_wallpapers(palette_name)
    if not wallpapers:
        print(f"\nWallpapers:\n  [skip]    no wallpapers found for '{palette_name}'")
        return

    monitors = get_monitors()
    if not monitors:
        print(f"\nWallpapers:\n  [skip]    no monitors detected (is Hyprland running?)")
        return

    # Assign wallpapers to monitors (cycle if fewer wallpapers than monitors)
    assignments = []
    for i, monitor in enumerate(monitors):
        wp = wallpapers[i % len(wallpapers)]
        assignments.append((monitor, wp))

    print("\nWallpapers:")
    if dry_run:
        for monitor, wp in assignments:
            print(f"  [preview] {monitor} → {wp.name}")
        return

    # Write hyprpaper.conf
    lines = [
        "splash = false",
        "",
    ]
    for monitor, wp in assignments:
        lines.extend(
            [
                "wallpaper {",
                f"    monitor = {monitor}",
                f"    path = {wp}",
                "    fit_mode = cover",
                "}",
                "",
            ]
        )

    HYPRPAPER_CONF.parent.mkdir(parents=True, exist_ok=True)
    HYPRPAPER_CONF.write_text("\n".join(lines))

    for monitor, wp in assignments:
        print(f"  [set]     {monitor} → {wp.name}")

    # Reload hyprpaper
    subprocess.run("killall hyprpaper 2>/dev/null", shell=True, capture_output=True)
    subprocess.Popen(
        ["hyprpaper"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
    print("  [reload]  hyprpaper restarted")


# ---------------------------------------------------------------------------
# Plugin-based app integrations
# ---------------------------------------------------------------------------

# Each integration defines:
#   - file: path to the config file
#   - pattern: regex to match the current theme value (must have one capture group)
#   - template: replacement string with {value} placeholder
#   - key: the key in [integrations] to read from the palette

INTEGRATION_MAP: list[dict] = [
    {
        "name": "tmux",
        "file": str(MODULES_DIR / "tmux/config/tmux.conf"),
        "pattern": r'(set -g @catppuccin_flavor )"[^"]*"',
        "template": r'\1"{value}"',
        "key": "tmux",
    },
    {
        "name": "starship",
        "file": str(MODULES_DIR / "shell/config/starship.toml"),
        "pattern": r'(palette = )"[^"]*"',
        "template": r'\1"{value}"',
        "key": "starship",
    },
    {
        "name": "yazi",
        "file": str(MODULES_DIR / "shell/config/yazi/theme.toml"),
        "pattern": r'(dark = )"[^"]*"',
        "template": r'\1"{value}"',
        "key": "yazi",
    },
    {
        "name": "yazi",
        "file": str(MODULES_DIR / "shell/config/yazi/theme.toml"),
        "pattern": r'(light = )"[^"]*"',
        "template": r'\1"{value}"',
        "key": "yazi",
    },
    {
        "name": "opencode",
        "file": str(Path("~/.config/opencode/tui.json").expanduser()),
        "pattern": r'("theme": )"[^"]*"',
        "template": r'\1"{value}"',
        "key": "opencode",
    },
]


def apply_integrations(palette: dict, dry_run: bool = False) -> None:
    """Update plugin-based app configs with theme names from [integrations]."""
    integrations = palette.get("integrations", {})
    if not integrations:
        return

    print("\nIntegrations:")
    import re

    processed = set()
    for entry in INTEGRATION_MAP:
        key = entry["key"]
        value = integrations.get(key, "")
        name = entry["name"]

        if not value:
            # Only warn once per app
            if name not in processed:
                print(f"  [skip]    {name} — no integration defined for this theme")
                processed.add(name)
            continue

        filepath = Path(entry["file"])
        if not filepath.exists():
            if name not in processed:
                print(f"  [skip]    {name} — config not found: {filepath}")
                processed.add(name)
            continue

        if dry_run:
            print(f"  [preview] {name} — set to '{value}'")
            continue

        content = filepath.read_text()
        replacement = entry["template"].replace("{value}", value)
        new_content = re.sub(entry["pattern"], replacement, content)

        if new_content != content:
            filepath.write_text(new_content)
            print(f"  [update]  {name} — set to '{value}'")
        else:
            print(f"  [ok]      {name} — already set to '{value}'")

        processed.add(name)


# ---------------------------------------------------------------------------
# App reload
# ---------------------------------------------------------------------------

RELOAD_COMMANDS: dict[str, str | None] = {
    "kitty": "for sock in /tmp/kitty-socket-*; do kitty @ --to unix:$sock set-colors --all ~/.config/kitty/kitty-theme.conf 2>/dev/null; done",
    "waybar": "killall -SIGUSR2 waybar 2>/dev/null",
    "swaync": "pgrep -x swaync >/dev/null && { swaync-client --reload-config 2>/dev/null; swaync-client --reload-css 2>/dev/null; }",
    # Hyprland auto-reloads on config file change
    # Hyprlock reads config on launch
    "tmux": "tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null",
    # Starship auto-reloads per prompt
    # Yazi requires restart
}


def reload_apps() -> None:
    """Execute reload commands for all apps that support hot-reload."""
    print("\nReloading apps:")
    for app, cmd in RELOAD_COMMANDS.items():
        if cmd is None:
            continue
        try:
            result = subprocess.run(cmd, shell=True, capture_output=True, timeout=5)
            status = "ok" if result.returncode == 0 else "skipped"
        except subprocess.TimeoutExpired:
            status = "timeout"
        print(f"  [{status}]  {app}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def cmd_apply(args: argparse.Namespace) -> None:
    """Apply a theme."""
    name = args.theme
    palette = load_palette(name)

    print(f"Applying theme: {palette['meta']['name']} ({name})")

    env = create_jinja_env()
    context = build_template_context(palette)
    rendered = render_templates(env, context)

    if not rendered:
        print("\nNo templates found. Add .j2 files to modules/theme/templates/")
        return

    create_symlinks(rendered)
    apply_integrations(palette)
    apply_wallpapers(name)
    save_current_theme(name)
    reload_apps()

    print(f"\nTheme '{name}' applied. {len(rendered)} file(s) rendered.")


def cmd_preview(args: argparse.Namespace) -> None:
    """Preview what would be rendered without writing files."""
    name = args.theme
    palette = load_palette(name)

    print(f"Preview: {palette['meta']['name']} ({name})")

    env = create_jinja_env()
    context = build_template_context(palette)
    rendered = render_templates(env, context, dry_run=True)

    if not rendered:
        print("\nNo templates found.")
        return

    create_symlinks(rendered, dry_run=True)
    apply_integrations(palette, dry_run=True)
    apply_wallpapers(name, dry_run=True)


def cmd_list(args: argparse.Namespace) -> None:
    """List available palettes."""
    palettes = list_palettes()
    current = get_current_theme()

    if not palettes:
        print("No palettes found. Add .toml files to modules/theme/palettes/")
        return

    for name in palettes:
        palette = load_palette(name)
        meta = palette.get("meta", {})
        theme_type = meta.get("type", "?")
        display_name = meta.get("name", name)

        if args.rofi:
            active = " (active)" if name == current else ""
            print(f"{display_name}{active}")
        else:
            marker = " *" if name == current else ""
            print(f"  {name:<30} {display_name} ({theme_type}){marker}")


def cmd_current(args: argparse.Namespace) -> None:
    """Show the currently active theme."""
    current = get_current_theme()
    if current:
        palette = load_palette(current)
        print(f"{current} — {palette['meta']['name']}")
    else:
        print("No theme currently applied.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Theme switcher — apply color palettes across all apps."
    )
    subparsers = parser.add_subparsers(dest="command")

    # apply
    p_apply = subparsers.add_parser("apply", help="Apply a theme")
    p_apply.add_argument("theme", help="Palette name (without .toml)")
    p_apply.set_defaults(func=cmd_apply)

    # preview
    p_preview = subparsers.add_parser("preview", help="Preview without applying")
    p_preview.add_argument("theme", help="Palette name (without .toml)")
    p_preview.set_defaults(func=cmd_preview)

    # list
    p_list = subparsers.add_parser("list", help="List available palettes")
    p_list.add_argument(
        "--rofi", action="store_true", help="Output for rofi (display names only)"
    )
    p_list.set_defaults(func=cmd_list)

    # current
    p_current = subparsers.add_parser("current", help="Show active theme")
    p_current.set_defaults(func=cmd_current)

    args = parser.parse_args()

    if not hasattr(args, "func"):
        parser.print_help()
        sys.exit(1)

    args.func(args)


if __name__ == "__main__":
    main()
