sudo ip link delete dummy0 2>/dev/null
sudo ip link add dummy0 type dummy
sudo ip addr add 10.10.10.1/24 dev dummy0
sudo ip link set dummy0 up

sudo vtysh << 'FRR_CONF'
configure terminal
ip route 198.51.100.0/24 blackhole
router ospf
 network 10.10.10.0/24 area 0
end
write memory
FRR_CONF
