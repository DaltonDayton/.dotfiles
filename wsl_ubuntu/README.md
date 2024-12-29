# WSL Ubuntu

# Note: Likely outdated

## Windows and WSL

### Terminal (Windows)

1. Download [Alacritty](https://alacritty.org/)
1. Install CaskaydiaCove Nerd Font
   - [Nerd Fonts - Downloads](https://www.nerdfonts.com/font-downloads)
1. Copy alacritty.toml from `../other_configs/alacritty.toml` to `C:\Users\[user]\AppData\Roaming\alacritty\alacritty.toml`
   - Create the file/directory if needed

### WSL

1. Install WSL2
   - `wsl --install`
2. Restart
3. Set up user
4. Update and get github-cli
   - `sudo apt update`
   - `sudo apt upgrade`
   - `sudo apt install gh`
5. Authorize
   - `gh auth login`
6. Clone
   - `git clone git@github.com:DaltonDayton/.dotfiles.git`
