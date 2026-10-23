# 🎓 Laboratorio 2 — FRRouting, Redes Virtuales y Enrutamiento Modular en Linux

> 👤 **Estudiante:** Mauricio Marcelo Centellas  
> 📚 **Materia:** Sistemas de Comunicación II (ETN1011) — UMSA  
> 🐧 **Entorno:** Ubuntu 24.04 LTS en WSL2 (`mau@DESKTOP-3KRJ81R`)  
> 🛠️ **Routing Suite:** FRRouting (FRR versión 8.4.4)  

---

## 💡 1. Introducción y Contexto General

En el **Laboratorio 1** construimos una infraestructura básica con *Network Namespaces* conectados mediante enlaces `veth`. En este **Laboratorio 2**, el objetivo es transformar nuestra máquina Linux en un **Router Modular de Nivel Empresarial** utilizando **FRRouting (FRR)**. Este laboratorio demuestra cómo Linux desacopla la inteligencia del enrutamiento de la ejecución física del envío de paquetes, replicando el núcleo de routers comerciales como Cisco o Juniper.

---

## 🎯 2. Objetivos del Laboratorio

1. **Descomponer la Arquitectura de Enrutamiento:** Comprender la separación estricta entre el **Plano de Control** y el **Plano de Datos**.
2. **Administración de Demonios:** Orquestar los procesos `zebra`, `staticd` y `ospfd`.
3. **Simulación de Interfaces:** Implementar la interfaz lógica `dummy0` en el Kernel.
4. **Enrutamiento Estático Especializado:** Inyectar rutas de descarte explícito (`blackhole`).
5. **Enrutamiento Dinámico:** Activar OSPFv2 en el Área 0 y analizar el intercambio de paquetes *Hello*.
6. **Consola `vtysh`:** Dominar la CLI de FRR y construir un mapa comparativo con Cisco IOS.

---

## 🧠 3. Fundamentación Teórica (Los 4 Pilares)

### 🚗 Pilar 1: La Separación de Planos (El Waze vs. El Conductor)

Un router de alto rendimiento divide sus tareas en dos niveles independientes:

    ┌─────────────────────────────────────────────────────────┐
    │                   PLANO DE CONTROL                      │
    │   🧠 El "Waze" (Espacio de Usuario - FRRouting)         │
    │   - Calcula las rutas (OSPF, estáticas) en la RIB.      │
    └────────────────────────────┬────────────────────────────┘
                                 │ Inyecta rutas (ZAPI)
                                 ▼
    ┌─────────────────────────────────────────────────────────┐
    │                    PLANO DE DATOS                       │
    │   🚘 El "Conductor" (Espacio del Kernel - Linux)        │
    │   - Recibe el paquete, consulta la FIB y lo reenvía.    │
    └─────────────────────────────────────────────────────────┘

* **Plano de Control (FRRouting):** Ejecuta demonios en segundo plano. **`zebra`** es el coordinador central, **`staticd`** gestiona rutas manuales, y **`ospfd`** calcula rutas dinámicas.
* **Plano de Datos (Kernel):** Toma cada paquete, consulta la **FIB** (*Forwarding Information Base*) y lo mueve físicamente sin calcular rutas.

### 🏎️ Pilar 2: La Interfaz Virtual `dummy0`
Es un controlador del Kernel de Linux que simula un dispositivo Ethernet real. Al asignarle la IP **`10.10.10.1/24`**, el Kernel y FRR crean automáticamente una ruta directamente conectada (`C`), permitiendo que OSPF la anuncie sin requerir tarjetas de red físicas adicionales.

### 🕳️ Pilar 3: La Ruta `blackhole` (La Trituradora)
Configurada como `ip route 198.51.100.0/24 blackhole`. Instruye a `zebra` para que el Kernel instale una regla de descarte en la FIB. Cualquier paquete hacia esa red es destruido silenciosamente, lo cual es útil para mitigar ataques DDoS o prevenir bucles de enrutamiento.

### 📻 Pilar 4: OSPFv2 y el Misterio de los "0 Vecinos"
OSPF envía saludos multicast (`224.0.0.5`) para descubrir routers. Al ejecutar `show ip ospf neighbor`, devuelve **0 vecinos**. Esto es **técnicamente correcto** porque en esta topología aislada mononodo no existe otro router recibiendo ni respondiendo los paquetes *Hello*; por ende, la interfaz se mantiene en estado *Waiting*.

---

## 📊 4. Comparativa de Tablas: RIB vs. FIB

### A. Tabla RIB (Plano de Control - `vtysh`)

    C>* 10.10.10.0/24 is directly connected, dummy0, 00:00:00
    S>* 198.51.100.0/24 [1/0] unreachable (blackhole), weight 1, 00:01:00
    O   10.10.10.0/24 [110/10] is directly connected, dummy0, weight 1, 00:00:00

La RIB conoce todas las fuentes (Conectada, Estática, OSPF).

### B. Tabla FIB (Plano de Datos - Kernel Linux)

    10.10.10.0/24 dev dummy0 proto kernel scope link src 10.10.10.1
    blackhole 198.51.100.0/24 proto zebra

La FIB solo contiene las reglas finales de reenvío inyectadas por `zebra`.

---

## 🔄 5. Tabla Comparativa: FRRouting vs. Cisco IOS

| Operación de Red | 🐧 Comandos FRR (`vtysh`) | 🦅 Comandos Cisco IOS Clásico |
| :--- | :--- | :--- |
| **Acceso a la CLI** | `sudo vtysh` | `enable` |
| **Ver Tabla de Rutas** | `show ip route` | `show ip route` |
| **Configurar Blackhole**| `ip route 198.51.100.0/24 blackhole` | `ip route 198.51.100.0 255.255.255.0 Null0` |
| **Activar OSPF (Área 0)**| `router ospf` <br> `network 10.10.10.0/24 area 0` | `router ospf 1` <br> `network 10.10.10.0 0.0.0.255 area 0` |
| **Ver Vecinos OSPF** | `show ip ospf neighbor` | `show ip ospf neighbor` |
| **Guardar Cambios** | `write memory` | `copy running-config startup-config` |

---

## 🎤 6. Banco de Preguntas para la Defensa

1. **¿Por qué FRR usa demonios separados (`zebra`, `ospfd`)?** Por modularidad y tolerancia a fallos. Si `ospfd` se bloquea, `staticd` y `zebra` continúan operando el router.
2. **¿Qué guarda `write memory`?** Guarda exclusivamente la configuración de FRR (`/etc/frr/frr.conf`). No guarda la interfaz `dummy0` del Kernel, que es volátil y debe recrearse por script.
3. **Diferencia entre `show ip route` e `ip -4 route`:** El primero consulta la tabla RIB del Plano de Control; el segundo consulta la tabla FIB en el Plano de Datos del Kernel.
4. **¿Qué indica una Distancia Administrativa de 1 frente a 110?** AD 1 (Ruta Estática) tiene prioridad y es más confiable que AD 110 (OSPF) para alcanzar un mismo destino.
