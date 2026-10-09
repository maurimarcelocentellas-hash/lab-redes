#!/bin/bash
# Script oficial ETN1011: Topología hostA <-> hostB

echo "[+] Limpiando namespaces previos..."
sudo ip netns del hostA 2>/dev/null
sudo ip netns del hostB 2>/dev/null
sudo ip netns del demo-ns 2>/dev/null

echo "[+] Creando namespaces aislados: hostA y hostB..."
sudo ip netns add hostA
sudo ip netns add hostB

echo "[+] Creando enlace virtual vethA <-> vethB..."
sudo ip link add vethA type veth peer name vethB
sudo ip link set vethA netns hostA
sudo ip link set vethB netns hostB

echo "[+] Configurando IP 192.168.1.1/24 en hostA (vethA)..."
sudo ip netns exec hostA ip addr add 192.168.1.1/24 dev vethA
sudo ip netns exec hostA ip link set vethA up
sudo ip netns exec hostA ip link set lo up

echo "[+] Configurando IP 192.168.1.2/24 en hostB (vethB)..."
sudo ip netns exec hostB ip addr add 192.168.1.2/24 dev vethB
sudo ip netns exec hostB ip link set vethB up
sudo ip netns exec hostB ip link set lo up

echo "[+] Configuración completada."
