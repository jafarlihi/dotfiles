xrandr --output eDP-1 --mode 1680x1050
sudo sh -c "echo 90 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
