# Laboratorio de Redes y Namespaces en Linux (WSL2)

## Resumen de la Configuración
- **Usuario:** mau
- **Entorno:** Ubuntu 24.04 LTS en WSL2
- **Namespace Creado:** `demo-ns`
- **Interfaz Principal (`veth0`):** IP `192.168.1.1/24`
- **Interfaz Aislada (`veth1`):** IP `192.168.1.2/24`

## Pruebas de Conectividad
- Comunicacion verificada mediante `ping` desde el host hacia el espacio `demo-ns` con 0% de perdida de paquetes.
