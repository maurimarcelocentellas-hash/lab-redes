# 🎓 Laboratorio 2 — FRRouting, Redes Virtuales y Enrutamiento en Linux (ETN1011 - UMSA)

> 👤 **Estudiante:** Mauricio Marcelo Centellas  
> 📚 **Materia:** Sistemas de Comunicación II (ETN1011) — UMSA  
> 🐧 **Entorno:** Ubuntu 24.04 LTS en WSL2 (`mau@DESKTOP-3KRJ81R`)  
> 🛠️ **Herramientas:** FRRouting (FRR 8.4.4), `vtysh`, `iproute2`  

---

## 💡 1. ¿De qué trata este Laboratorio en sencillo?

En el **Laboratorio 1** conectamos dos computadoras virtuales mediante un cable simulado (`veth`)[cite: 1].

En este **Laboratorio 2**, el objetivo es transformar nuestra computadora en un **Router Comercial de Nivel Empresarial** (como un router Cisco o Juniper) utilizando la suite de software **FRRouting (FRR)**.

---

## 🧠 2. Los 4 Pilares Teóricos Explicados con Analogías

### 🚗 Pilar 1: El Waze vs. El Conductor (Plano de Control vs. Plano de Datos)

Un router empresarial no es un bloque monolítico; divide sus tareas en dos niveles totalmente independientes:

```text
 ┌─────────────────────────────────────────────────────────┐
 │                   PLANO DE CONTROL                      │
 │   🧠 El "Waze" (FRRouting / vtysh / demonios)           │
 │   - Calcula las rutas inteligentes con OSPF y estáticas. │
 └────────────────────────────┬────────────────────────────┘
                              │ Envía la mejor ruta (ZAPI)
                              ▼
 ┌─────────────────────────────────────────────────────────┐
 │                    PLANO DE DATOS                       │
 │   🚘 El "Conductor" (Kernel de Linux / Tabla FIB)       │
 │   - Recibe el paquete real y lo mueve por la red.        │
 └─────────────────────────────────────────────────────────┘
