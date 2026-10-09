# Laboratorio 1 — Redes virtuales con Linux (ETN1011 - UMSA)

## 1. Datos del entorno
- **Estudiante:** Mauricio Marcelo Centellas
- **Fecha:** Octubre 2026
- **Distribución:** Ubuntu 24.04 LTS
- **Entorno:** WSL2 en Windows
- **Kernel:** $(uname -r)

## 2. Objetivo
Construir y verificar una red virtual aislada mediante *network namespaces* (`hostA` y `hostB`), interconectados con interfaces `veth` y direccionamiento IPv4 `/30`, analizando tráfico con `tcpdump` y diagnosticando fallas controladas.

## 3. Topología
```text
             Linux Kernel
       hostA                           hostB
┌───────────────────┐          ┌───────────────────┐
│ network namespace │          │ network namespace │
│  10.10.1.1/30     │          │  10.10.1.2/30     │
│       vethA       ├══════════┤       vethB       │
└───────────────────┘   veth   └───────────────────┘
---

### Paso 4: Actualizar `README.md` y sincronizar todo en GitHub

Actualiza el `README.md` principal para apuntar al nuevo informe y sube los cambios a tu repositorio remoto:

```bash
cat << 'EOF' > README.md
# ETN1011 - Laboratorio de Sistemas de Comunicación II (UMSA)
## Laboratorio 1: Redes Virtuales con Linux

- **Topología Desplegada:** `hostA` (`10.10.1.1/30`) <---> `hostB` (`10.10.1.2/30`)
- **Informe Oficial Completo:** Ver archivo [`informe-lab01.md`](informe-lab01.md)
- **Script Reproducible:** Executar `sudo ./setup.sh`
