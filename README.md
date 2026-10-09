# ETN1011 - Laboratorio de Sistemas de Comunicación II (UMSA)
## Laboratorio 1: Orientación, Linux, Network Namespaces y Git

### Configuración del Entorno
- **Entorno de Trabajo:** Ubuntu 24.04 LTS sobre WSL2 en Windows
- **Herramienta Asistente:** OpenCode instalado y operativo
- **Topología Desplegada:** `hostA` (vethA: `192.168.1.1/24`) <---> `hostB` (vethB: `192.168.1.2/24`)

### Archivos del Repositorio
- `setup.sh`: Script ejecutable para reconstruir la red en memoria RAM con un solo comando (`sudo ./setup.sh`).
- `evidencia.txt`: Salida oficial formateada con la verificación de interfaces, rutas, ping y tabla ARP.
- `comandos_utilizados.txt`: Resumen técnico de todos los comandos explicados en la clase de orientación.
