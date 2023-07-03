#!/bin/bash

DEVICE_MAC="00:00:00:00:00:00"  # デバイスのMACアドレスを指定
KEEP=0
WAIT=0

# 音を鳴らす
play_sound() {
    # ここに音を鳴らすコマンドを追加してください
    play osaka.wav
    echo "Sound played!"
}

# デバイスが存在するかチェックする
check_device() {
    #devices_info=$(hcitool scan -length 3)
    #if [[ $devices_info =~ $DEVICE_MAC ]]; then
    devices_info=$(sudo hcitool cc $DEVICE_MAC 2>&1)
    echo "status; $devices_info"
    if [[ -z $devices_info ]]; then
        if [[ $KEEP -eq 0 ]]; then
            echo "Device found! Playing sound..."
            KEEP=1
            play_sound
        else
            echo "Device Keeping Mode"
            WAIT=0
        fi
    else
        echo "Device not found!"
        WAIT=$((WAIT + 1))
        #if [[ $KEEP -ge 1 && $KEEP -le 30 ]]; then
        if [[ $WAIT -eq 20 ]]; then
                KEEP=0
                WAIT=0
                echo "Device disconnected"
        fi
    fi
    sleep 3
}

# メインの処理
main() {
    while true; do
        check_device
    done
}

main