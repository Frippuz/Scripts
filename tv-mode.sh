#!/bin/bash

STATE_FILE="$HOME/.tvmode"

tv-mode-off(){
  # Set monitors to extend (all 3)
  gdctl set \
      --layout-mode logical \
      --logical-monitor \
          --monitor DP-1 \
          --mode 1920x1080@60.000 \
          --x 0 --y 0 --scale 1 --transform 270 \
      --logical-monitor \
          --monitor HDMI-4 \
          --mode 1920x1080@60.000 \
          --x 3640 --y 480 --scale 1 \
      --logical-monitor \
          --monitor DP-4 \
          --mode 2560x1440@144.000 \
          --primary \
          --x 1080 --y 480 --scale 1

  # pactl list short sinks

  # Set audio device to Focusrite Scarlett Solo dynamically
  SINK=$(pactl list short sinks | grep 'Focusrite_Scarlett_Solo_USB' | awk '{print $2}' | head -n1)
  if [ -n "$SINK" ]; then
    pactl set-default-sink "$SINK"
  fi


  sleep 1
  paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
  notify-send "TV Mode" "TV mode has been turned off"
}

tv-mode-on(){
  # Mirror LG and TV
  gdctl set \
      --layout-mode logical \
      --logical-monitor \
          --monitor HDMI-4 \
          --mode 1920x1080@60.000 \
          --monitor DP-4 \
          --mode 1920x1080@74.906 \
          --primary \
          --x 0 --y 0 --scale 1 \
  # pactl list short sinks

  # Set audio device to TV
  pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo
  

  # SINK=$(pactl list short sinks | grep 'hdmi-stereo' | awk '{print $2}' | head -n1)
  # echo "$SINK"
  # if [ -n "$SINK" ]; then
  #   pactl set-default-sink "$SINK"
  # fi


  sleep 1
  paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
  notify-send "TV Mode" "TV mode has been turned on"
}


# TODO: replace STATE_FILE with environment variable instead and make it non persistent across reboots.
if [ -f "$STATE_FILE" ] && grep -q "true" "$STATE_FILE"; then
    echo "Turning TV mode OFF..."
    tv-mode-off
    echo "false" > "$STATE_FILE"
else
    echo "Turning TV mode ON..."
    tv-mode-on
    echo "true" > "$STATE_FILE"
fi
