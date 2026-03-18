opencode -s ses_30bd72228ffeiakmixrPs3jM7n

# Theme Switcher

A Python-based theme engine that manages colors and wallpapers across all desktop applications from a single palette definition.

## Architecture

```
modules/theme/
├── theme.sh                     # Module: install deps, run initial generation
├── switch.py                    # Engine: parse → render → reload
├── select.sh                    # Rofi-based theme picker (SUPER+D)
├── import_base16.py             # Import Base16/Base24 schemes → our palette format (planned)
├── palettes/
│   ├── catppuccin-mocha.toml    # Hand-crafted (full 26 colors + terminal + ui)
│   └── nord.toml                # Hand-crafted (official Nord colors only)
├── templates/
│   ├── kitty/
│   │   └── kitty-theme.conf.j2
│   ├── swaync/
│   │   └── style.css.j2
│   ├── waybar/
│   │   ├── palette.css.j2
│   │   ├── style.css.j2
│   │   └── config.jsonc.j2
│   ├── hyprland/
│   │   └── colors.conf.j2
│   ├── hyprlock/
│   │   └── hyprlock.conf.j2
│   ├── tmux/
│   │   └── colors.conf.j2
│   └── rofi/
│       ├── theme.rasi.j2
│       └── config.rasi.j2
├── wallpapers/
│   ├── catppuccin-mocha/        # Theme-specific wallpapers
│   │   ├── escape_velocity.jpg
│   │   └── shaded_landscape.png
│   └── nord/
│       ├── arch-rainbow.png
│       └── car-with-full-moon-background.jpg
├── generated/                   # Gitignored — rendered output
│   ├── kitty/
│   ├── swaync/
│   ├── waybar/
│   ├── hyprland/
│   ├── hyprlock/
│   ├── tmux/
│   └── rofi/
└── current.toml                 # Tracks active theme
```

## Design Decisions

### Why custom instead of Tinty/Flavours/HyDE?

Evaluated existing tools before building:

- **Tinty** (Base16/Base24 manager): Active, 250+ schemes, but locked to 16-24 colors.
  Our setup uses 26 colors + terminal + UI sections. Templates are community-maintained
  with gaps for Wayland-native apps (swaync, hyprlock, etc.).
- **HyDE** (Hyprland desktop environment): Full theme switching with wallbash
  (wallpaper-driven color extraction). But it's an entire DE — adopting it means
  replacing our dotfiles with theirs. Uses rofi with custom `.rasi` themes.
- **Flavours**: Predecessor to Tinty, no longer maintained.
- **pywal**: Wallpaper-based palette generation. Interesting for a future phase but not
  a theme management system.

**Decision**: Build our own with a palette format that can import Base16 schemes.
This gives us full control over templates while accessing the community's 250+ theme library.

### Palette design principles

- **Use official theme colors only.** When creating a palette for an established theme
  (Nord, Gruvbox, etc.), every color should map to an official color from that theme.
  Do not interpolate or derive colors — duplicate official colors across multiple slots
  if needed. This ensures the theme looks authentic.
- **Terminal colors are separate from UI colors.** The 16 ANSI terminal colors (what
  `ls`, `eza`, etc. use) are defined in `[terminal]`, independent from the `[colors]`
  palette. This allows themes to control terminal output separately from UI accents.
- **UI accents are semantic.** The `[ui]` section maps semantic purposes (clock, network,
  battery, etc.) to specific colors. This lets each theme control how colorful or
  restrained the UI feels — e.g., Nord maps almost everything to Frost blues, while
  Catppuccin uses a rainbow of accents.

### Importing community themes (Base16/Base24)

Our palette uses 26 color names. Base16 defines 16. The import strategy:

**Direct mapping** (16 colors):
| Base16 | Our name | Role |
|--------|----------|------|
| `base00` | `base` | Background |
| `base01` | `surface0` | Lighter background |
| `base02` | `surface1` | Selection |
| `base03` | `overlay0` | Comments |
| `base04` | `subtext0` | Dark foreground |
| `base05` | `text` | Foreground |
| `base06` | `subtext1` | Light foreground |
| `base07` | `rosewater` | Lightest foreground |
| `base08` | `red` | Red / Variables |
| `base09` | `peach` | Orange / Integers |
| `base0A` | `yellow` | Yellow / Classes |
| `base0B` | `green` | Green / Strings |
| `base0C` | `teal` | Cyan / Support |
| `base0D` | `blue` | Blue / Functions |
| `base0E` | `mauve` | Purple / Keywords |
| `base0F` | `flamingo` | Brown / Deprecated |

**Remaining slots** (10 colors): Map to the nearest official color from the theme.
Do not interpolate. Duplicate existing colors if no distinct equivalent exists.
Imported palettes should be hand-tuned afterward to ensure authenticity.

### Ideas borrowed from existing tools

- **From Tinty**: Hook-based reload system, `fzf` picker pattern
- **From HyDE/wallbash**: Wallpaper-driven color extraction (future), rofi as the picker
- **From swww**: Animated wallpaper transitions when switching themes (optional, independent)

## Flow

1. Templates (`.j2`) are the source of truth for themed configs
2. `switch.py` renders templates with palette colors → writes to `generated/`
3. Symlinks wire generated files into module directories (which `~/.config/` already points to)
4. Plugin-based apps get their flavor/colorscheme name swapped in config files
5. Wallpapers are set from `wallpapers/<theme>/` and hyprpaper is restarted
6. Apps are hot-reloaded after generation

## Palette Format

TOML files with four sections: `[colors]` (26 base colors), `[terminal]` (16 ANSI colors),
`[ui]` (semantic accent mappings), and `[integrations]` (plugin-based app theme names).

```toml
[meta]
name = "Catppuccin Mocha"
type = "dark"  # dark | light
source = "hand-crafted"  # hand-crafted | base16-import

[colors]
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
surface0 = "#313244"
surface1 = "#45475a"
surface2 = "#585b70"
overlay0 = "#6c7086"
overlay1 = "#7f849c"
overlay2 = "#9399b2"
subtext0 = "#a6adc8"
subtext1 = "#bac2de"
text = "#cdd6f4"
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"

# 16 terminal ANSI colors (independent from UI palette)
[terminal]
color0  = "#45475a"
color1  = "#f38ba8"
color2  = "#a6e3a1"
color3  = "#f9e2af"
color4  = "#89b4fa"
color5  = "#f5c2e7"
color6  = "#94e2d5"
color7  = "#cdd6f4"
color8  = "#585b70"
color9  = "#f38ba8"
color10 = "#a6e3a1"
color11 = "#f9e2af"
color12 = "#89b4fa"
color13 = "#f5c2e7"
color14 = "#94e2d5"
color15 = "#a6adc8"

# Semantic UI accent colors (controls how colorful the UI feels)
[ui]
accent = "#cba6f7"
accent_secondary = "#74c7ec"
clock = "#eba0ac"
clock_date = "#cba6f7"
audio = "#89b4fa"
network = "#f9e2af"
battery = "#a6e3a1"
bluetooth = "#74c7ec"
cpu = "#cba6f7"
gpu = "#fab387"
idle = "#a6e3a1"
vpn = "#b4befe"

# Plugin-based app integrations (optional — omit if not available)
[integrations]
neovim = "catppuccin"
neovim_variant = "mocha"
tmux = "mocha"
yazi = "catppuccin-mocha"
starship = "catppuccin_mocha"
opencode = "catppuccin"
```

## Templating

Jinja2 templates with custom filters for format conversion:

- `{{ base }}` → `#1e1e2e`
- `{{ base | strip_hash }}` → `1e1e2e`
- `{{ base | to_rgb }}` → `30, 30, 46`
- `{{ base | to_rgba(0.94) }}` → `rgba(30, 30, 46, 0.94)`
- `{{ base | upper_hex }}` → `#1E1E2E`
- `{{ base | to_rgb_r }}` → `30`
- `{{ base | to_rgb_g }}` → `30`
- `{{ base | to_rgb_b }}` → `46`

Template context provides:

- Top-level color names: `{{ base }}`, `{{ mauve }}`, etc.
- Terminal colors: `{{ terminal.color0 }}`, `{{ terminal.color15 }}`, etc.
- UI accents: `{{ ui.accent }}`, `{{ ui.clock }}`, `{{ ui.gpu }}`, etc.
- Metadata: `{{ meta.name }}`, `{{ meta.type }}`
- Integrations: `{{ integrations.neovim }}`, `{{ integrations.tmux }}`, etc.

## CLI

```
python3 switch.py apply <palette-name>      # Apply theme + wallpapers + reload all
python3 switch.py list                      # Show available palettes (* = active)
python3 switch.py list --rofi               # Show display names for rofi picker
python3 switch.py current                   # Show active theme
python3 switch.py preview <palette-name>    # Render without applying
```

## Keybindings

| Key       | Action                   |
| --------- | ------------------------ |
| `SUPER+D` | Open theme picker (rofi) |
| `SUPER+R` | Open app launcher (rofi) |

## Symlink Map

Generated files are symlinked into module directories (which `~/.config/` already points to):

| Generated File           | Symlink Destination                    |
| ------------------------ | -------------------------------------- |
| `kitty/kitty-theme.conf` | `~/.config/kitty/kitty-theme.conf`     |
| `swaync/style.css`       | `modules/hyprland/swaync/style.css`    |
| `waybar/palette.css`     | `modules/hyprland/waybar/palette.css`  |
| `waybar/style.css`       | `modules/hyprland/waybar/style.css`    |
| `waybar/config.jsonc`    | `modules/hyprland/waybar/config.jsonc` |
| `hyprland/colors.conf`   | `modules/hyprland/hypr/colors.conf`    |
| `hyprlock/hyprlock.conf` | `modules/hyprland/hypr/hyprlock.conf`  |
| `tmux/colors.conf`       | `~/.config/tmux/colors.conf`           |
| `rofi/theme.rasi`        | `~/.config/rofi/theme.rasi`            |
| `rofi/config.rasi`       | `~/.config/rofi/config.rasi`           |

## Reload Map

| App       | Reload Command                                     | Notes                                |
| --------- | -------------------------------------------------- | ------------------------------------ |
| Kitty     | `kitty @ --to unix:/tmp/kitty-socket-* set-colors` | Live color update via remote control |
| Waybar    | `killall -SIGUSR2 waybar`                          | Full reload                          |
| SwayNC    | `swaync-client --reload-css && --reload-config`    | Full reload                          |
| Hyprland  | —                                                  | Auto-reloads on file change          |
| Hyprlock  | —                                                  | Reads config on launch               |
| Hyprpaper | `killall hyprpaper && hyprpaper`                   | Restart with new wallpapers          |
| Tmux      | `tmux source-file ~/.config/tmux/tmux.conf`        | Full reload                          |
| Starship  | —                                                  | Auto-reloads per prompt              |
| Yazi      | —                                                  | Requires restart                     |
| OpenCode  | —                                                  | Requires restart                     |
| SDDM      | `sudo cp ... && sudo systemctl restart sddm`       | Requires sudo, deferred              |

## App Inventory

### Template-generated ✅

| App           | Template                                 | Config Integration                          | Status  |
| ------------- | ---------------------------------------- | ------------------------------------------- | ------- |
| Kitty         | `kitty/kitty-theme.conf.j2`              | `include` directive in kitty.conf           | ✅ Done |
| SwayNC        | `swaync/style.css.j2`                    | Symlink replaces style.css                  | ✅ Done |
| Waybar CSS    | `waybar/style.css.j2` + `palette.css.j2` | Symlink replaces both files                 | ✅ Done |
| Waybar config | `waybar/config.jsonc.j2`                 | Symlink replaces config.jsonc               | ✅ Done |
| Hyprland      | `hyprland/colors.conf.j2`                | `source` directive in hyprland.conf         | ✅ Done |
| Hyprlock      | `hyprlock/hyprlock.conf.j2`              | Symlink replaces hyprlock.conf              | ✅ Done |
| Tmux          | `tmux/colors.conf.j2`                    | `source-file` after TPM, overrides `@thm_*` | ✅ Done |
| Rofi          | `rofi/theme.rasi.j2` + `config.rasi.j2`  | Symlink to `~/.config/rofi/`                | ✅ Done |

### Plugin-based (switcher updates flavor/colorscheme name) ✅

| App      | Config File                            | Integration Method               | Status  |
| -------- | -------------------------------------- | -------------------------------- | ------- |
| Tmux     | `modules/tmux/config/tmux.conf`        | Regex swap `@catppuccin_flavor`  | ✅ Done |
| Starship | `modules/shell/config/starship.toml`   | Regex swap `palette` name        | ✅ Done |
| Yazi     | `modules/shell/config/yazi/theme.toml` | Regex swap `dark`/`light` flavor | ✅ Done |
| OpenCode | `~/.config/opencode/tui.json`          | Regex swap `theme` name          | ✅ Done |

### Wallpapers ✅

| Feature                             | Status  |
| ----------------------------------- | ------- |
| Per-theme wallpaper directories     | ✅ Done |
| Auto-assign wallpapers to monitors  | ✅ Done |
| Generate hyprpaper.conf and restart | ✅ Done |

### Not yet themed

| App    | Notes                                                        | Status   |
| ------ | ------------------------------------------------------------ | -------- |
| Neovim | Config deeply tied to Catppuccin plugin, needs restructuring | Deferred |
| eza    | Uses `EZA_COLORS` env var or theme file, truecolor           | TODO     |
| btop   | No config exists, using defaults                             | Deferred |
| GTK    | Commented out in hyprland.sh                                 | Deferred |
| SDDM   | `modules/hyprland/sddm-theme/*.qml` + SVGs                   | Deferred |

---

## Phases

### Phase 1 — Foundation ✅

- [x] Create `modules/theme/` directory structure
- [x] Define palette format and create `catppuccin-mocha.toml`
- [x] Build `switch.py` core engine
  - [x] TOML palette parsing (uses `tomllib` — stdlib since Python 3.11)
  - [x] Jinja2 template rendering
  - [x] Custom filters (`strip_hash`, `to_rgb`, `to_rgba`, `upper_hex`, `to_rgb_r/g/b`)
  - [x] CLI (apply, list, current, preview)
  - [x] Reload orchestration
  - [x] `current.toml` tracking
- [x] Create `theme.sh` module (install deps, initial generation)
- [x] Add `generated/` to `.gitignore`

### Phase 2 — Templates (hardcoded apps) ✅

- [x] Kitty — `include` directive for generated theme file
- [x] SwayNC — full style.css template
- [x] Waybar — palette.css, style.css, and config.jsonc templates
- [x] Hyprland — `source` directive for generated colors.conf
- [x] Hyprlock — full config template
- [x] Symlink wiring from module dirs to generated files
- [x] Hot-reload verified for all apps

### Phase 2.5 — Palette refinement ✅

- [x] Add `[terminal]` section — 16 ANSI colors independent from UI palette
- [x] Add `[ui]` section — semantic accent mappings (clock, network, battery, etc.)
- [x] Templatize `waybar/style.css` — per-module colors use `ui.*` instead of raw palette
- [x] Update `config.jsonc` template — Pango markup uses `ui.*`
- [x] Update kitty template — ANSI colors use `terminal.*`
- [x] Create Nord palette — 100% official Nord colors, zero interpolation
- [x] Tested both themes end-to-end

### Phase 3 — Plugin integrations ✅

- [x] Tmux — template-generated `colors.conf` overrides `@thm_*` variables after TPM loads
- [x] Starship — added `[palettes.nord]` block, switcher swaps `palette` name
- [x] Yazi — installed `nord.yazi` flavor, switcher swaps `dark`/`light` values
- [x] OpenCode — swaps `theme` in `tui.json` (built-in themes)
- [x] Kitty — live reload via `kitty @ set-colors` over unix socket
- [x] Integration replacement logic in `switch.py` with `[update]`/`[ok]`/`[skip]` states
- [x] Empty integration values skip with warning (no crash)
- [ ] Neovim — deferred (config deeply tied to Catppuccin plugin, needs restructuring)

### Phase 3.5 — Rofi + Wallpapers ✅

- [x] Rofi theme template (`.rasi`) with palette colors, rounded corners, blur
- [x] Rofi config template with hover-select, icons, mouse support
- [x] Hyprland blur layer rules for rofi
- [x] Switch app launcher from hyprlauncher to rofi (`SUPER+R`)
- [x] Theme picker via rofi (`SUPER+D`) with `--rofi` list format
- [x] Per-theme wallpaper directories
- [x] Auto-assign wallpapers to monitors (cycle if fewer than monitors)
- [x] Generate `hyprpaper.conf` and restart hyprpaper on theme switch

### Phase 4 — More apps + community themes

- [ ] Wallpaper picker — `SUPER+W` to browse/select wallpapers within current theme
- [ ] eza theming (`EZA_COLORS` env var or theme file)
- [ ] Neovim — restructure colorscheme config to support multiple themes
- [ ] Build `import_base16.py` (map 16 colors, duplicate for remaining slots)
- [ ] Batch import popular Base16 schemes (Gruvbox, Tokyo Night, Dracula, etc.)
- [ ] Hand-tune imported palettes
- [ ] Add Catppuccin Latte (hand-crafted, light theme)
- [ ] btop theme template
- [ ] GTK theme integration
- [ ] SDDM templates (QML + SVG)
- [ ] Light/dark mode toggle shortcut
- [ ] Wallpaper-driven palette generation (`switch.py --from-wallpaper <image>`)
- [ ] swww integration for animated wallpaper transitions
