#!/bin/bash
if pgrep -x "redshift" > /dev/null; then
    pkill -x redshift
    notify-send "Đã tắt chống ánh sáng xanh"
else
    redshift -c ~/.config/redshift/redshift.conf &
    notify-send "Đã bật chống ánh sáng xanh"
fi

