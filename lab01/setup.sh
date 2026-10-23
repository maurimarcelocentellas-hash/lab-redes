#!/bin/bash
# Script Oficial ETN1011 - Laboratorio 1 (Red 10.10.1.0/30)

echo "[+] Limpiando namespaces previos..."
sudo ip netns del hostA 2>/dev/null
sudo ip netns del hostB 2>/dev/null

echo "[+] Creando namespaces hostA y hostB..."
sudo ip netns add hostA
sudo ip netns add hostB

echo "[+] Creando par veth (vethA <-> vethB)..."
sudo ip link add vethA type veth peer name vethB
sudo ip link set vethA netns hostA
sudo ip link set vethB netns hostB

echo "[+] Asignando direcciones IP /30..."
sudo ip netns exec hostA ip addr add 10.10.1.1/30 dev vethA
sudo ip netns exec hostB ip addr add 10.10.1.2/30 dev vethB

echo "[+] Habilitando interfaces (lo y veth)..."
sudo ip netns exec hostA ip link set lo up
sudo ip netns exec hostA ip link set vethA up
sudo ip netns exec hostB ip link set lo up
sudo ip netns exec hostB ip link set vethB up

echo "[+] Topología Laboratorio 1 desplegada con éxito."
