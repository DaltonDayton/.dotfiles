# Theme Switcher

A Python-based theme engine that manages colors across all desktop applications from a single palette definition.

## Architecture

```
modules/theme/
├── theme.sh                     # Module: install deps, run initial generation
├── switch.py                    # Engine: parse → render → reload
├── import_base16.py             # Import Base16/Base24 schemes → our palette format
├── palettes/
│   ├── catppuccin-mocha.toml    # Hand-crafted (full 26 colors)
│   ├── catppuccin-latte.toml    # Hand-crafted
│   ├── gruvbox-dark.toml        # Imported + hand-tuned
│   └── ...
├── templates/
│   ├── kitty.conf.j2
│   ├── swaync/
│   │   └── style.css.j2
│   ├── waybar/
│   │   ├── palette.css.j2
│   │   └── config.jsonc.j2
│   ├── hyprland/
│   │   └── colors.conf.j2
│   └── hyprlock.conf.j2
├── generated/                   # Gitignored — rendered output
│   ├── kitty/
│   ├── swaync/
│   ├── waybar/
│   ├── hyprland/
│   └── hyprlock/
├── current.toml                 # Tracks active theme
└── requirements.txt             # jinja2
```

## Design Decisions

### Why custom instead of Tinty/Flavours/HyDE?

Evaluated existing tools before building:

- **Tinty** (Base16/Base24 manager): Active, 250+ schemes, but locked to 16-24 colors.
  Our setup uses 26 (Catppuccin's full palette). Templates are community-maintained
  with gaps for Wayland-native apps (swaync, hyprlock, etc.).
- **HyDE** (Hyprland desktop environment): Full theme switching with wallbash
  (wallpaper-driven color extraction). But it's an entire DE — adopting it means
  replacing our dotfiles with theirs.
- **Flavours**: Predecessor to Tinty, no longer maintained.
- **pywal**: Wallpaper-based palette generation. Interesting for Phase 4 but not
  a theme management system.

**Decision**: Build our own with a 26-color palette format that can import Base16
schemes. This gives us full control over templates while accessing the community's
250+ theme library.

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

**Derived colors** (10 auto-generated from the 16):
| Our name | Derived from | Method |
|----------|-------------|--------|
| `mantle` | `base` | Darken 3% |
| `crust` | `base` | Darken 6% |
| `surface2` | `surface1` → `overlay0` | Midpoint |
| `overlay1` | `overlay0` → `subtext0` | 33% blend |
| `overlay2` | `overlay0` → `subtext0` | 66% blend |
| `sky` | `teal` → `blue` | 50% blend |
| `sapphire` | `teal` → `blue` | 25% blend |
| `lavender` | `blue` → `mauve` | 50% blend |
| `pink` | `mauve` → `red` | 30% blend toward red |
| `maroon` | `red` | Desaturate 15% |

The `import_base16.py` script reads Base16 YAML schemes and outputs our TOML
format with all 26 colors populated. Imported palettes can be hand-tuned afterward.

### Ideas borrowed from existing tools

- **From Tinty**: Hook-based reload system, `fzf` picker pattern (`switch.py --list | fzf`)
- **From HyDE/wallbash**: Wallpaper-driven color extraction (Phase 4 — `switch.py --from-wallpaper <image>`)
- **From swww**: Animated wallpaper transitions when switching themes (optional, independent)

## Flow

1. Templates (`.j2`) are the source of truth for themed configs
2. `switch.py` renders templates with palette colors → writes to `generated/`
3. Symlinks point from `~/.config/<app>/` to `generated/` output
4. Apps are hot-reloaded after generation
5. Apps with plugin theme systems (Neovim, Tmux, Starship, Yazi) get their flavor/colorscheme name swapped in their existing config files

## Palette Format

TOML files with a standard set of 26 color names.

```toml
[meta]
name = "Catppuccin Mocha"
type = "dark"  # dark | light
source = "hand-crafted"  # hand-crafted | base16-import | base24-import

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

# Plugin-based app integrations (optional — omit if not available)
[integrations]
neovim = "catppuccin"           # colorscheme name
neovim_variant = "mocha"        # flavor/variant
tmux = "mocha"                  # @catppuccin_flavor value
yazi = "catppuccin-mocha"       # yazi flavor name
starship = "catppuccin_mocha"   # palette name in starship.toml
```

When `[integrations]` entries are missing, the switcher falls back to template
generation for those apps (using the 26 colors directly).

## Templating

Jinja2 templates with custom filters for format conversion:

- `{{ base }}` → `#1e1e2e`
- `{{ base | strip_hash }}` → `1e1e2e`
- `{{ base | to_rgb }}` → `30, 30, 46`
- `{{ base | to_rgba(0.94) }}` → `rgba(30, 30, 46, 0.94)`
- `{{ base | upper_hex }}` → `#1E1E2E`

## CLI

```
python3 switch.py <palette-name>            # Apply theme
python3 switch.py --list                    # Show available palettes
python3 switch.py --current                 # Show active theme
python3 switch.py --preview <name>          # Render without applying

python3 import_base16.py <scheme.yaml>      # Import a Base16 scheme
python3 import_base16.py --all <dir>        # Batch import from a directory
```

## Reload Map

| App | Reload Command | Notes |
|-----|---------------|-------|
| Kitty | `kill -SIGUSR1 $(pgrep kitty)` | Partial — new windows pick up changes |
| Waybar | `killall -SIGUSR2 waybar` | Full reload |
| SwayNC | `swaync-client --reload-css && swaync-client --reload-config` | Full reload |
| Hyprland | — | Auto-reloads on file change |
| Hyprlock | — | Reads config on launch |
| Tmux | `tmux source-file ~/.config/tmux/tmux.conf` | Full reload |
| Starship | — | Auto-reloads per prompt |
| Neovim | TBD (nvim RPC or flag file) | Needs investigation |
| Yazi | — | Requires restart |
| SDDM | `sudo cp -r ... && sudo systemctl restart sddm` | Requires sudo, deferred |

## App Inventory

### Template-generated (colors hardcoded today, will become templates)

| App | Config File | Hardcoded Colors | Status |
|-----|------------|-----------------|--------|
| Kitty | `modules/kitty/config/kitty.conf` | ~30 hex values | TODO |
| SwayNC | `modules/hyprland/swaync/style.css` | ~80+ hex values | TODO |
| Waybar CSS | `modules/hyprland/waybar/style.css` + `mocha.css` | Partial abstraction via mocha.css | TODO |
| Waybar config | `modules/hyprland/waybar/config.jsonc` | ~10 Pango markup hex values | TODO |
| Hyprland | `modules/hyprland/hypr/hyprland.conf` | 3 border/shadow colors | TODO |
| Hyprlock | `modules/hyprland/hypr/hyprlock.conf` | ~8 decimal RGB values | TODO |
| SDDM | `modules/hyprland/sddm-theme/*.qml` + SVGs | ~40 across 9 QML + 3 SVG | Deferred |

### Plugin-based (switcher updates flavor/colorscheme name)

| App | Config File | Current Setting | Status |
|-----|------------|----------------|--------|
| Neovim | `modules/neovim/nvim/lua/plugins/colorscheme.lua` | `catppuccin_flavor = "mocha"` | TODO |
| Tmux | `modules/tmux/config/tmux.conf` | `@catppuccin_flavor "mocha"` | TODO |
| Starship | `modules/shell/config/starship.toml` | `palette = "catppuccin_mocha"` | TODO |
| Yazi | `modules/shell/config/yazi/theme.toml` | `dark = "catppuccin-mocha"` | TODO |

### Not yet themed

| App | Notes | Status |
|-----|-------|--------|
| Rofi | No config exists, using defaults | Deferred |
| btop | No config exists, using defaults | Deferred |
| GTK | Commented out in hyprland.sh | Deferred |

---

## Phases

### Phase 1 — Foundation
- [ ] Create `modules/theme/` directory structure
- [ ] Define palette format and create `catppuccin-mocha.toml`
- [ ] Build `switch.py` core engine
  - [ ] TOML palette parsing (use `tomllib` — stdlib since Python 3.11)
  - [ ] Jinja2 template rendering
  - [ ] Custom filters (`strip_hash`, `to_rgb`, `to_rgba`, `upper_hex`)
  - [ ] CLI (`--list`, `--current`, `--preview`, apply)
  - [ ] Reload orchestration
  - [ ] `current.toml` tracking
- [ ] Create `theme.sh` module (install deps, initial generation)
- [ ] Add `generated/` to `.gitignore`

### Phase 2 — Templates (hardcoded apps)
- [ ] Kitty — convert `kitty.conf` to template
- [ ] SwayNC — convert `style.css` to template
- [ ] Waybar — convert `mocha.css` + `style.css` to palette template
- [ ] Waybar — convert `config.jsonc` to template
- [ ] Hyprland — extract border/shadow colors into a sourced `colors.conf` template
- [ ] Hyprlock — convert `hyprlock.conf` to template
- [ ] Update symlinks: `~/.config/<app>/` → `generated/<app>/`
- [ ] Verify hot-reload works for each app

### Phase 3 — Plugin integrations
- [ ] Neovim — swap `catppuccin_flavor` in colorscheme.lua
- [ ] Tmux — swap `@catppuccin_flavor` in tmux.conf
- [ ] Starship — swap `palette` name in starship.toml
- [ ] Yazi — swap flavor name in theme.toml
- [ ] Handle missing integrations (fall back to template if plugin theme doesn't exist)

### Phase 4 — Community themes + polish
- [ ] Build `import_base16.py` with color derivation for missing slots
- [ ] Batch import popular Base16 schemes (Gruvbox, Tokyo Night, Nord, Dracula, etc.)
- [ ] Hand-tune imported palettes where needed
- [ ] Add Catppuccin Latte (hand-crafted, light theme)
- [ ] Rofi theme template
- [ ] btop theme template
- [ ] GTK theme integration
- [ ] SDDM templates (QML + SVG)
- [ ] Theme picker UI (`switch.py --list | fzf` or rofi)
- [ ] Light/dark mode toggle shortcut
- [ ] Wallpaper-driven palette generation (`switch.py --from-wallpaper <image>`)
- [ ] swww integration for animated wallpaper transitions
