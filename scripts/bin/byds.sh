sudo rfkill unblock 3 # todo get num
sudo systemctl start bluetooth
bluetoothctl power on
bluetoothctl scan on
sleep 3 && bluetoothctl connect `bluetoothctl devices Paired | grep "Apple AirPods" | awk '{print $2}'`
