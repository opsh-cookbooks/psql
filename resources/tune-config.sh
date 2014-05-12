
ram_kb=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}')
ram_rm=$(($ram_kb / 1024))



echo $ram_rm
