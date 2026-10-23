# 🎬 Guía de Presentación y Ejecución: Laboratorio 2 (FRRouting)

> 📌 **Propósito:** Guión paso a paso con los comandos exactos a ejecutar durante la defensa del laboratorio, incluyendo la explicación didáctica de su funcionamiento.

---

### 🟢 PASO 1: Verificación del Servicio y Demonios Activos

**1. Comando a ejecutar en Ubuntu:**

    sudo systemctl status frr --no-pager

**2. ¿Para qué funciona este comando?**
Consulta al sistema de inicio de Linux (`systemd`) el estado actual de la suite FRRouting. El parámetro `--no-pager` evita que la terminal se quede bloqueada esperando una tecla para salir.

**3. Qué decir durante la defensa:**
> "Primero comprobamos que el servicio FRR esté en estado `active (running)`. Previamente editamos el archivo `/etc/frr/daemons` para habilitar `zebra` (el coordinador que habla con el Kernel), `staticd` (para la ruta blackhole) y `ospfd` (para el enrutamiento dinámico)."

---

### 🟢 PASO 2: Despliegue Automatizado del Entorno Virtual

**1. Comando a ejecutar:**

    sudo ./setup-lab02.sh

**2. ¿Para qué funciona este comando?**
Ejecuta un script Bash que automatiza la configuración volátil del sistema: crea la interfaz virtual `dummy0`, le asigna la IP `10.10.10.1/24`, levanta la interfaz en el Kernel y luego inyecta la configuración en FRR (ruta de descarte y red OSPF).

**3. Qué decir durante la defensa:**
> "Al ser la interfaz `dummy0` parte de la memoria volátil del Kernel de Linux, utilizamos este script para recrear el entorno automáticamente. El script levanta la interfaz, asigna la IP de simulación y carga los parámetros en el Plano de Control."

---

### 🟢 PASO 3: Demostración de la Separación de Planos (Control vs. Datos)

**1. Comandos a ejecutar:**

    # Ver el Plano de Control (RIB en FRR)
    sudo vtysh -c 'show ip route'

    # Ver el Plano de Datos (FIB en el Kernel de Linux)
    ip -4 route

**2. ¿Para qué funcionan estos comandos?**
*   `vtysh -c '...'`: Envía un comando directamente a la consola de FRR. Muestra la tabla inteligente con códigos (`O`, `C`, `S`).
*   `ip -4 route`: Comando nativo de Linux que muestra las reglas reales de envío (FIB).

**3. Qué decir durante la defensa:**
> "Aquí demostramos la arquitectura de un router real. El primer comando nos muestra cómo la inteligencia (FRR) categoriza y elige las rutas (Plano de Control). El segundo comando nos muestra cómo el demonio `zebra` instaló exitosamente las mejores rutas en el motor de hardware/Kernel para mover los paquetes físicos (Plano de Datos)."

---

### 🟢 PASO 4: Verificación de la Ruta de Descarte (Blackhole)

**1. Comando a ejecutar:**

    ip route get 198.51.100.10

**2. ¿Para qué funciona este comando?**
Le pregunta al Kernel de Linux: "Si tuvieras que enviar un paquete a esta IP, ¿por dónde lo sacarías?".

**3. Qué decir durante la defensa:**
> "Al simular el envío de un paquete hacia la red `198.51.100.0/24`, el Kernel responde con un error. Esto prueba que la instrucción `blackhole` que configuramos en FRR se inyectó con éxito en el Plano de Datos, logrando que el tráfico hacia esa red sea destruido inmediatamente."

---

### 🟢 PASO 5: Comprobación del Enrutamiento Dinámico (OSPFv2)

**1. Comandos a ejecutar:**

    # Ver detalles de la interfaz en OSPF
    sudo vtysh -c 'show ip ospf interface dummy0'

    # Ver la tabla de vecinos descubiertos
    sudo vtysh -c 'show ip ospf neighbor'

**2. ¿Para qué funcionan estos comandos?**
El primero confirma que la interfaz virtual está emitiendo saludos (paquetes Hello). El segundo muestra la lista de routers adyacentes con los que se ha formado una relación.

**3. Qué decir durante la defensa:**
> "Verificamos que OSPF está habilitado en `dummy0` (Área 0) y emitiendo paquetes multicast a la IP `224.0.0.5`. El comando de vecinos devuelve '0' registros, lo cual es el comportamiento técnico correcto: OSPF requiere un segundo router para contestar el saludo. Al ser un nodo aislado, se mantiene en estado de espera (Waiting)."

---

### 🟢 PASO 6: Demostración de la Consola Cisco-Like (`vtysh`)

**1. Comandos a ejecutar:**

    sudo vtysh
    configure terminal
    exit
    write memory
    quit

**2. ¿Para qué funcionan estos comandos?**
`vtysh` es la VTY Shell, una CLI unificada. `write memory` guarda la configuración activa en el disco duro (`/etc/frr/frr.conf`).

**3. Qué decir durante la defensa:**
> "Finalmente, demostramos que la CLI unificada `vtysh` de FRRouting es estructuralmente idéntica a Cisco IOS, permitiendo usar comandos estándar de la industria como `configure terminal` y `write memory` para guardar los parámetros lógicos de forma persistente."
