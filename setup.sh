#!/bin/bash
# Script para recrear el laboratorio de redes

echo "[+] Creando namespace demo-ns..."
sudo ip netns del demo-ns 2>/dev/null
sudo ip netns add demo-ns

echo "[+] Creando cable virtual veth..."
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns demo-ns

echo "[+] Configurando direcciones IP..."
sudo ip addr add 192.168.1.1/24 dev veth0
sudo ip link set veth0 up

sudo ip netns exec demo-ns ip addr add 192.168.1.2/24 dev veth1
sudo ip netns exec demo-ns ip link set veth1 up
sudo ip netns exec demo-ns ip link set lo up

echo "[+] Configuración completada."
