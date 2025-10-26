# TP-Segundo-Parcial-Frontend

## 📋 Descripción del Proyecto

Aplicación móvil desarrollada en **Flutter** para la gestión integral de un sistema de alquiler de autos. La aplicación funciona completamente en memoria local sin necesidad de backend o API externa, permitiendo administrar vehículos, clientes, reservas, entregas y estadísticas del negocio.

## 👥 Integrantes del Equipo

- **Fernando Fleitas** - Módulo de Vehículos
- **José Ramirez** - Módulo de Clientes
- **Lucas Vargas** - Módulo de Reservas
- **Atilio Paredes** - Módulo de Entregas
- **Elias Figueredo** - Módulo de Estadísticas

## 🚀 Cómo Levantar el Proyecto

### Requisitos Previos

- Flutter SDK (versión 3.9.2 o superior)
- Android Studio / VS Code con plugins de Flutter
- Emulador Android/iOS o dispositivo físico conectado

### Instrucciones de Instalación y Ejecución

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/FE-TP/TP-Segundo-Parcial-Frontend
   cd TP-Segundo-Parcial-Frontend
   ```

2. **Navegar a la carpeta del proyecto Flutter:**
   ```bash
   cd alquiler_autos
   ```

3. **Instalar las dependencias:**
   ```bash
   flutter pub get
   ```

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

   O selecciona el dispositivo específico:
   ```bash
   flutter run -d <device_id>
   ```

5. **Ver dispositivos disponibles:**
   ```bash
   flutter devices
   ```

## 📁 Estructura del Proyecto

El proyecto está organizado en una arquitectura modular dentro de la carpeta `alquiler_autos/`:

- **Módulo de Vehículos**: CRUD completo de vehículos con filtros
- **Módulo de Clientes**: Gestión de clientes del sistema
- **Módulo de Reservas**: Creación y seguimiento de reservas
- **Módulo de Entregas**: Registro de entregas de vehículos
- **Módulo de Estadísticas**: Métricas y reportes del negocio

Para más detalles sobre la estructura y convenciones del proyecto, consulta el archivo `alquiler_autos/README.md`.
