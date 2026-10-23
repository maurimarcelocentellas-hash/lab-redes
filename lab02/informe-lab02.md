# Laboratorio 2 — FRRouting en Linux/WSL2 y Equivalencias con Cisco IOS (ETN1011 - UMSA)

## 1. Datos del Entorno
- **Estudiante:** Mauricio Marcelo Centellas
- **Materia:** Sistemas de Comunicación II (ETN1011) — UMSA
- **Sistema Operativo:** Ubuntu 24.04 LTS en WSL2 (`mau@DESKTOP-3KRJ81R`)
- **Kernel:** Linux 6.6.87.2-microsoft-standard-WSL2
- **Suite de Enrutamiento:** FRRouting (FRR 8.4.4)

## 2. Objetivos
1. Comprender la arquitectura de enrutamiento modular en Linux mediante la separación entre el **Plano de Control** (FRR / `zebra`) y el **Plano de Datos** (Kernel Linux / Forwarding)[cite: 3, 5].
2. Configurar y administrar los demonios `zebra`, `staticd` y `ospfd` en `/etc/frr/daemons`[cite: 3, 5].
3. Desplegar la interfaz virtual `dummy0` (`10.10.10.1/24`) y la ruta estática de descarte `blackhole` (`198.51.100.0/24`)[cite: 3, 5].
4. Activar OSPFv2 en Área 0 mediante la consola `vtysh` y justificar técnicamente la presencia de 0 vecinos en un único router[cite: 3, 5].
5. Comparar la sintaxis y comandos operativos entre FRRouting/Linux y Cisco IOS clásico[cite: 3, 5].

## 3. Justificación Técnica: Vecindad OSPF en Router Único
Al ejecutar `show ip ospf neighbor`, la consola devuelve **0 vecinos** (`Neighbor Count is 0`)[cite: 3, 5].
- **Explicación:** OSPF es un protocolo dinámico basado en adyacencias que requiere intercambiar paquetes *Hello* de multicast (`224.0.0.5`) para descubrir otros routers activos en el mismo segmento[cite: 3, 5]. Al tratarse de una topología con un solo router, no existe un segundo nodo con el cual establecer el estado de adyacencia *Full*[cite: 3, 5].

## 4. Tabla Comparativa: FRRouting vs. Cisco IOS

| Operación de Red | Comando FRR (`vtysh`) / Linux | Comando Cisco IOS |
|---|---|---|
| Acceso a la CLI | `sudo vtysh`[cite: 3, 5] | `enable`[cite: 5] |
| Modo Configuración Global | `configure terminal`[cite: 3, 5] | `configure terminal`[cite: 3, 5] |
| Ver Tabla de Rutas IPv4 | `show ip route`[cite: 3, 5] | `show ip route`[cite: 3, 5] |
| Ver Configuración Activa | `show running-config`[cite: 3, 5] | `show running-config`[cite: 3, 5] |
| Guardar Configuración | `write memory`[cite: 3, 5] | `copy running-config startup-config`[cite: 3, 5] |
| Ruta de Descarte | `ip route 198.51.100.0/24 blackhole`[cite: 3, 5] | `ip route 198.51.100.0 255.255.255.0 Null0`[cite: 5] |
| Configurar OSPFv2 | `router ospf` <br> `network 10.10.10.0/24 area 0`[cite: 5] | `router ospf 1` <br> `network 10.10.10.0 0.0.0.255 area 0`[cite: 3, 5] |
| Consultar Vecinos OSPF | `show ip ospf neighbor`[cite: 3, 5] | `show ip ospf neighbor`[cite: 3, 5] |
| Asignar IP a Interfaz | `ip addr add 10.10.10.1/24 dev dummy0` *(Linux)*[cite: 3, 5] | `interface GigabitEthernet0/1` <br> `ip address 10.10.10.1 255.255.255.0`[cite: 5] |

## 5. Persistencia y Conclusiones
- `write memory` guarda la configuración de FRR en `/etc/frr/frr.conf`[cite: 3, 5].
- La reconstrucción de la interfaz `dummy0` se automatiza mediante `setup-lab02.sh`[cite: 3, 5].
- Se comprobó la funcionalidad de Linux y FRRouting como plataforma de enrutamiento empresarial[cite: 3, 5].
