mac_create(){
	printf '00:60:2F:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256]
}
mac_randomize(){
    sudo ifconfig $1 down
    local mac=$(mac_create)
    sudo ifconfig $1 hw ether $mac
    sudo ifconfig $1 up
    echo "$1 MAC set to $mac"
}

mac_randomize wlo1
mac_randomize eno2

