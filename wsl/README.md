## Install WSL2

1. Install WSL2
   `wsl --install`
2. Restart
3. Install ArchWSL
4. [Set up user](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/#set-up-the-default-user)
5. install openssh and ssh-keygen based on github's docs
   `sudo pacman -Syu openssh`
   `ssh-keygen -t ed25519 -C "50755420+DaltonDayton@users.noreply.github.com"`
6. Authorize `gh auth login`
7. `git clone git@github.com:DaltonDayton/.dotfiles.git`

## Terminal (Windows)

1. Install CaskaydiaCove Nerd Font
   [Nerd Fonts - Downloads](https://www.nerdfonts.com/font-downloads)
2. Copy alacritty.toml from `../other_configs/alacritty.toml` to `C:\Users\[user]\AppData\Roaming\alacritty\alacritty.toml`

## TODO:

- Determine a better way to handle environments. Eg Work, Personal, etc
