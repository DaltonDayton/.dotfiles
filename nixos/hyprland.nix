{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable Hyprland through Home Manager
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      monitor=DP-1,3440x1440@165,0x1440,1
      monitor=DP-2,3440x1440@144,0x0,1

      # ANIMATIONS
      animations {
          enabled = yes
          bezier = wind, 0.05, 0.9, 0.1, 1.05
          bezier = winIn, 0.1, 1.1, 0.1, 1.1
          bezier = winOut, 0.3, -0.3, 0, 1
          bezier = liner, 1, 1, 1, 1
          animation = windows, 1, 6, wind, slide
          animation = windowsIn, 1, 6, winIn, slide
          animation = windowsOut, 1, 5, winOut, slide
          animation = windowsMove, 1, 5, wind, slide
          animation = border, 1, 1, liner
          animation = borderangle, 1, 30, liner, loop
          animation = fade, 1, 10, default
          animation = workspaces, 1, 5, wind
      }

      # ENV
      env = PATH,$PATH:$scrPath
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_QPA_PLATFORMTHEME,qt6ct
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = MOZ_ENABLE_WAYLAND,1
      env = GDK_SCALE,1

      # INPUT
      input {
          kb_layout = us
          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0.5
          force_no_accel = 0
          # numlock_by_default = true
      }

      # See https://wiki.hyprland.org/Configuring/Keywords/#executing

      device {
          name = epic mouse V1
          sensitivity = -0.5
      }

      # See https://wiki.hyprland.org/Configuring/Variables/

      gestures {
          workspace_swipe = true
          workspace_swipe_fingers = 3
      }

      # LAYOUTS
      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/

      master {
          new_status = master
      }

      # MISC
      misc {
          vrr = 0
          disable_hyprland_logo = true
          disable_splash_rendering = true
          force_default_wallpaper = 0
      }

      xwayland {
          force_zero_scaling = true
      }

      # GENERAL
      general {
        no_focus_fallback = true
      }

      # NVIDIA
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = __GL_VRR_ALLOWED,1
      env = WLR_DRM_NO_ATOMIC,1

      cursor:no_hardware_cursors = true

      # KEYBINDS
      # Main modifier
      $mainMod = Super # super / meta / windows key

      # Assign apps
      $term = kitty
      $editor = code
      $file = dolphin
      $browser = firefox

      # Window/Session actions
      bindd = $mainMod+Shift, P,Color Picker , exec, hyprpicker -a # Pick color (Hex) >> clipboard# 
      bind = $mainMod, Q, exec, $scrPath/dontkillsteam.sh # close focused window
      bind = Alt, F4, exec, $scrPath/dontkillsteam.sh # close focused window
      bind = $mainMod, Delete, exit, # kill hyprland session
      bind = $mainMod, W, togglefloating, # toggle the window between focus and float
      bind = $mainMod, G, togglegroup, # toggle the window between focus and group
      bind = Alt, Return, fullscreen, # toggle the window between focus and fullscreen
      bind = $mainMod, L, exec, swaylock # launch lock screen
      bind = $mainMod+Shift, F, exec, $scrPath/windowpin.sh # toggle pin on focused window
      bind = $mainMod, Backspace, exec, $scrPath/logoutlaunch.sh # launch logout menu
      bind = Ctrl+Alt, W, exec, killall waybar || waybar # toggle waybar

      # Application shortcuts
      bind = $mainMod, T, exec, $term # launch terminal emulator
      bind = $mainMod, E, exec, $file # launch file manager
      bind = $mainMod, C, exec, $editor # launch text editor
      bind = $mainMod, F, exec, $browser # launch web browser
      bind = Ctrl+Shift, Escape, exec, $scrPath/sysmonlaunch.sh # launch system monitor (htop/btop or fallback to top)

      # Rofi menus
      bind = $mainMod, A, exec, pkill -x rofi || $scrPath/rofilaunch.sh d # launch application launcher
      bind = $mainMod, Tab, exec, pkill -x rofi || $scrPath/rofilaunch.sh w # launch window switcher
      bind = $mainMod+Shift, E, exec, pkill -x rofi || $scrPath/rofilaunch.sh f # launch file explorer

      # Audio control
      bindl  = , F10, exec, $scrPath/volumecontrol.sh -o m # toggle audio mute
      bindel = , F11, exec, $scrPath/volumecontrol.sh -o d # decrease volume
      bindel = , F12, exec, $scrPath/volumecontrol.sh -o i # increase volume
      bindl  = , XF86AudioMute, exec, $scrPath/volumecontrol.sh -o m # toggle audio mute
      bindl  = , XF86AudioMicMute, exec, $scrPath/volumecontrol.sh -i m # toggle microphone mute
      bindel = , XF86AudioLowerVolume, exec, $scrPath/volumecontrol.sh -o d # decrease volume
      bindel = , XF86AudioRaiseVolume, exec, $scrPath/volumecontrol.sh -o i # increase volume

      # Media control
      bindl  = , XF86AudioPlay, exec, playerctl play-pause # toggle between media play and pause
      bindl  = , XF86AudioPause, exec, playerctl play-pause # toggle between media play and pause
      bindl  = , XF86AudioNext, exec, playerctl next # media next
      bindl  = , XF86AudioPrev, exec, playerctl previous # media previous

      # Brightness control
      bindel = , XF86MonBrightnessUp, exec, $scrPath/brightnesscontrol.sh i # increase brightness
      bindel = , XF86MonBrightnessDown, exec, $scrPath/brightnesscontrol.sh d # decrease brightness

      # Move between grouped windows
      bind = $mainMod CTRL , H, changegroupactive, b
      bind = $mainMod CTRL , L, changegroupactive, f

      # Screenshot/Screencapture
      bind = $mainMod, P, exec, $scrPath/screenshot.sh s # partial screenshot capture
      bind = $mainMod+Ctrl, P, exec, $scrPath/screenshot.sh sf # partial screenshot capture (frozen screen)
      bind = $mainMod+Alt, P, exec, $scrPath/screenshot.sh m # monitor screenshot capture
      bind = , Print, exec, $scrPath/screenshot.sh p # all monitors screenshot capture

      # Custom scripts
      bind = $mainMod+Alt, G, exec, $scrPath/gamemode.sh # disable hypr effects for gamemode
      bind = $mainMod+Alt, Right, exec, $scrPath/swwwallpaper.sh -n # next wallpaper
      bind = $mainMod+Alt, Left, exec, $scrPath/swwwallpaper.sh -p # previous wallpaper
      bind = $mainMod+Alt, Up, exec, $scrPath/wbarconfgen.sh n # next waybar mode
      bind = $mainMod+Alt, Down, exec, $scrPath/wbarconfgen.sh p # previous waybar mode
      bind = $mainMod+Shift, R, exec, pkill -x rofi || $scrPath/wallbashtoggle.sh -m # launch wallbash mode select menu
      bind = $mainMod+Shift, T, exec, pkill -x rofi || $scrPath/themeselect.sh # launch theme select menu
      bind = $mainMod+Shift, A, exec, pkill -x rofi || $scrPath/rofiselect.sh # launch select menu
      bind = $mainMod+Shift, W, exec, pkill -x rofi || $scrPath/swwwallselect.sh # launch wallpaper select menu
      bind = $mainMod, V, exec, pkill -x rofi || $scrPath/cliphist.sh c # launch clipboard
      bind = $mainMod+Shift, V, exec, pkill -x rofi || $scrPath/cliphist.sh # launch clipboard Manager
      bind = $mainMod, K, exec, $scrPath/keyboardswitch.sh # switch keyboard layout
      bind = $mainMod, slash, exec, pkill -x rofi || $scrPath/keybinds_hint.sh c # launch keybinds hint

      # Move/Change window focus
      bind = $mainMod, Left, movefocus, l
      bind = $mainMod, Right, movefocus, r
      bind = $mainMod, Up, movefocus, u
      bind = $mainMod, Down, movefocus, d
      bind = Alt, Tab, movefocus, d

      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Switch workspaces to a relative workspace
      bind = $mainMod+Ctrl, Right, workspace, r+1
      bind = $mainMod+Ctrl, Left, workspace, r-1

      # Move to the first empty workspace
      bind = $mainMod+Ctrl, Down, workspace, empty 

      # Resize windows
      binde = $mainMod+Shift+Ctrl, Right, resizeactive, 30 0
      binde = $mainMod+Shift+Ctrl, Left, resizeactive, -30 0
      binde = $mainMod+Shift+Ctrl, Up, resizeactive, 0 -30
      binde = $mainMod+Shift+Ctrl, Down, resizeactive, 0 30

      # Move focused window to a workspace
      bind = $mainMod+Shift, 1, movetoworkspace, 1
      bind = $mainMod+Shift, 2, movetoworkspace, 2
      bind = $mainMod+Shift, 3, movetoworkspace, 3
      bind = $mainMod+Shift, 4, movetoworkspace, 4
      bind = $mainMod+Shift, 5, movetoworkspace, 5
      bind = $mainMod+Shift, 6, movetoworkspace, 6
      bind = $mainMod+Shift, 7, movetoworkspace, 7
      bind = $mainMod+Shift, 8, movetoworkspace, 8
      bind = $mainMod+Shift, 9, movetoworkspace, 9
      bind = $mainMod+Shift, 0, movetoworkspace, 10

      # Move focused window to a relative workspace
      bind = $mainMod+Ctrl+Alt, Right, movetoworkspace, r+1
      bind = $mainMod+Ctrl+Alt, Left, movetoworkspace, r-1

      # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
      $moveactivewindow=grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive
      binded = $mainMod SHIFT, left,Move activewindow to the right,exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l
      binded = $mainMod SHIFT, right,Move activewindow to the right,exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r
      binded = $mainMod SHIFT, up,Move activewindow to the right,exec, $moveactivewindow  0 -30 || hyprctl dispatch movewindow u
      binded = $mainMod SHIFT, down,Move activewindow to the right,exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d

      # Scroll through existing workspaces
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/Resize focused window
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      bindm = $mainMod, Z, movewindow
      bindm = $mainMod, X, resizewindow

      # Move/Switch to special workspace (scratchpad)
      bind = $mainMod+Alt, S, movetoworkspacesilent, special
      bind = $mainMod, S, togglespecialworkspace,

      # Toggle focused window split
      bind = $mainMod, J, togglesplit

      # Move focused window to a workspace silently
      bind = $mainMod+Alt, 1, movetoworkspacesilent, 1
      bind = $mainMod+Alt, 2, movetoworkspacesilent, 2
      bind = $mainMod+Alt, 3, movetoworkspacesilent, 3
      bind = $mainMod+Alt, 4, movetoworkspacesilent, 4
      bind = $mainMod+Alt, 5, movetoworkspacesilent, 5
      bind = $mainMod+Alt, 6, movetoworkspacesilent, 6
      bind = $mainMod+Alt, 7, movetoworkspacesilent, 7
      bind = $mainMod+Alt, 8, movetoworkspacesilent, 8
      bind = $mainMod+Alt, 9, movetoworkspacesilent, 9
      bind = $mainMod+Alt, 0, movetoworkspacesilent, 10
    '';
  };
}
