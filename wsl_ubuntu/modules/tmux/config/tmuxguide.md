# Tmux Tips & Tricks - Your Custom Setup

Based on your tmux configuration, here's everything you can do with your prefix key (`Ctrl+Space`) and other shortcuts.

## Quick Reference

### Your Custom Bindings

| Key               | Action           | Description                              |
| ----------------- | ---------------- | ---------------------------------------- |
| `prefix + R`      | Reload config    | Reloads `~/.tmux.conf` with confirmation |
| `prefix + r`      | Rename window    | Prompts to rename current window         |
| `prefix + Ctrl+s` | Toggle pane sync | Synchronizes input across all panes      |

### Navigation (No Prefix Required)

| Key            | Action          | Description                                        |
| -------------- | --------------- | -------------------------------------------------- |
| `Shift+Left`   | Previous window | Navigate to previous window                        |
| `Shift+Right`  | Next window     | Navigate to next window                            |
| `Ctrl+h/j/k/l` | Navigate panes  | Vim-style pane navigation (via vim-tmux-navigator) |

## Plugin-Powered Features

### 🔍 Tmux-FZF (`prefix + F`)

Your fuzzy finder for everything tmux:

- **Sessions**: Switch, create, rename, kill sessions
- **Windows**: Switch, move, swap, rename, kill windows
- **Panes**: Switch, break, join, swap, kill, resize panes
- **Commands**: Search and append commands to prompt
- **Key bindings**: Search and execute key bindings
- **Clipboard**: Search clipboard history and paste
- **Processes**: Manage processes (kill, interrupt, etc.)
- **Custom menu**: Run your custom commands (if configured)

**Pro tip**: Use `Tab` and `Shift+Tab` to multi-select items!

### 🎯 Tmux-Which-Key (`prefix + Space`)

Interactive menu system for discovering commands:

- **Windows menu** (`w`): Create, switch, rename, kill windows
- **Panes menu** (`p`): Split, switch, resize, kill panes
- **Sessions menu** (`s`): Switch, create, rename sessions
- **Client menu** (`C`): Reload config, detach, etc.

### 🚀 SessionX (`prefix + o`)

Advanced session manager with fuzzy search:

- **Create sessions** from any directory
- **Zoxide integration** for smart directory jumping
- **Preview sessions** before switching
- **Delete sessions** with `Alt+Backspace`
- **Rename sessions** with `Ctrl+r`
- **Window mode** with `Ctrl+w`
- **Directory expansion** with `Ctrl+e`

**Navigation within SessionX**:

- `Ctrl+u/d`: Scroll preview up/down
- `Ctrl+n/p`: Select preview up/down
- `?`: Toggle preview pane

## Copy Mode (Vi-style)

| Key          | Action                      |
| ------------ | --------------------------- |
| `prefix + [` | Enter copy mode             |
| `v`          | Start selection             |
| `y`          | Copy selection to clipboard |
| `q`          | Exit copy mode              |

## Built-in Tmux Commands

### Session Management

- `prefix + s` - List and switch sessions
- `prefix + $` - Rename current session
- `prefix + d` - Detach from session

### Window Management

- `prefix + c` - Create new window
- `prefix + &` - Kill current window
- `prefix + ,` - Rename current window
- `prefix + w` - List and switch windows
- `prefix + n/p` - Next/previous window
- `prefix + 0-9` - Switch to window by number

### Pane Management

- `prefix + %` - Split horizontally
- `prefix + "` - Split vertically
- `prefix + x` - Kill current pane
- `prefix + z` - Toggle pane zoom
- `prefix + {/}` - Swap panes
- `prefix + o` - Switch to next pane
- `prefix + ;` - Switch to last pane
- `prefix + Space` - Cycle through layouts

## Status Bar Info

Your custom status bar shows:

- **Left**: Session name, current command, current path, zoom indicator
- **Right**: Battery status, CPU usage, RAM usage, date/time

## Advanced Tips

### Window Reordering

- Use `prefix + F` → "window" → "swap" for interactive window swapping
- Or add custom keybindings for `Alt+Left/Right` to move windows

### Plugin Combinations

- Use SessionX (`prefix + o`) to quickly jump between project sessions
- Use tmux-fzf (`prefix + F`) for detailed management within sessions
- Use which-key (`prefix + Space`) when you forget a command

### Productivity Shortcuts

- `prefix + Ctrl+s` - Sync input across all panes (great for running same command on multiple servers)
- `prefix + R` - Reload config when you make changes
- `Ctrl+h/j/k/l` - Navigate panes without prefix (vim-tmux-navigator)

## Configuration Files

- Main config: `~/.config/tmux/tmux.conf`
- This guide: `~/.config/tmux/tmuxguide.md`

Press `prefix + R` to reload after making config changes!
