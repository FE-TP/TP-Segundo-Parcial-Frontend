# 🚀 Guía de Instalación y Configuración del Proyecto

Esta guía te ayudará a configurar el entorno de desarrollo para el proyecto de Alquiler de Autos en Flutter, desde la instalación de las herramientas necesarias hasta la ejecución del proyecto.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Git** - Para clonar y gestionar el repositorio
- **Flutter SDK** - Versión estable más reciente
- **Editor de código** - VS Code (recomendado) o Android Studio
- **JDK** - Java Development Kit 11 o superior (para desarrollo Android)

## 🛠️ Instalación de Flutter

### Windows

```bash
# Usando Chocolatey
choco install flutter

# Verificar instalación
flutter doctor
```

### macOS

```bash
# Usando Homebrew
brew install flutter

# Verificar instalación
flutter doctor
```

### Linux (Ubuntu/Debian)

```bash
# Usando Snap
sudo snap install flutter --classic

# Verificar instalación
flutter doctor
```

## 🔧 Configuración de Android Studio

1. Descargar desde: https://developer.android.com/studio
2. Instalar componentes necesarios:
   - Android SDK
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android Emulator
3. Configurar emulador:
   - Abrir **AVD Manager**
   - Click en **Create Virtual Device**
   - Seleccionar **Pixel 5** o similar
   - Elegir **Android 13+** (API 33+)
4. Verificar dispositivos:

```bash
flutter devices
```

## 📥 Colaboración en el Proyecto

### 1️⃣ Clonar el Repositorio

```bash
git clone https://github.com/FE-TP/TP-Segundo-Parcial-Frontend.git
cd TP-Segundo-Parcial-Frontend
```

### 2️⃣ Inicializar el Proyecto

```bash
# Cambiar al directorio del proyecto Flutter
cd alquiler_autos

# Descargar todas las dependencias del proyecto
flutter pub get

# Verificar el estado del proyecto
flutter doctor
```

### 3️⃣ Crear tu Rama de Trabajo

```bash
# Asegúrate de estar en la rama develop primero
git checkout develop

# Crear y cambiar a una nueva rama para tu módulo
# Reemplaza "nombre-modulo" con tu módulo asignado: vehiculos, clientes, reservas, entregas, o estadisticas
git checkout -b feature/nombre-modulo
```

### 4️⃣ Ejecutar la Aplicación

```bash
# Verificar dispositivos disponibles
flutter devices

# Ejecutar en modo debug (desarrollo)
flutter run

# O especificar un dispositivo si hay varios
flutter run -d nombre-dispositivo
```

## 🔄 Flujo de Trabajo con Git

### Guardar Cambios

```bash
# Ver archivos modificados
git status

# Agregar archivos
git add .

# Crear commit (Importante: seguir la convención de mensajes)
git commit -m "[NombreModulo] Descripción del cambio"

# Subir cambios a tu rama
git push origin feature/nombre-modulo
```

### Actualizar tu Rama

```bash
# Asegúrate de estar en tu rama
git checkout feature/nombre-modulo

# Actualiza tu rama con los cambios de develop
git pull origin develop

# Resuelve conflictos si es necesario
# ...

# Sube los cambios actualizados
git push origin feature/nombre-modulo
```

## 🧪 Pruebas Básicas

```bash
# Ejecutar análisis estático del código
flutter analyze

# Formatear código automáticamente
flutter format .

# Ejecutar tests (si están configurados)
flutter test
```

## 🧩 Estructura de Archivos por Módulo

### Ejemplo para el módulo de Vehículos

```
lib/modules/vehiculos/
├── models/
│   └── vehiculo_model.dart           # Definir aquí tu modelo
├── pages/
│   ├── vehiculos_list_page.dart      # Pantalla de listado
│   └── vehiculo_form_page.dart       # Formulario de creación/edición
├── widgets/
│   ├── vehiculo_card.dart            # Componente de tarjeta
│   └── vehiculo_filter.dart          # Componente de filtrado
└── providers/
    └── vehiculo_provider.dart         # Lógica y estado
```

## 🔍 Solución de Problemas Comunes

### Error de Dependencias

Si encuentras errores después de hacer `flutter pub get`:

```bash
# Limpiar caché de paquetes
flutter pub cache clean

# Intentar nuevamente
flutter pub get
```

### Error en Android SDK

Si encuentras problemas con el SDK de Android:

```bash
# Verificar la configuración
flutter doctor --android-licenses

# Aceptar todas las licencias
# Seguir las instrucciones en pantalla
```

### Errores de Compilación

```bash
# Limpiar la build
flutter clean

# Intentar nuevamente
flutter pub get
flutter run
```

## 🎯 Próximos Pasos

1. Familiarízate con la estructura del proyecto
2. Revisa el módulo asignado en el archivo README-CONTEXT.md
3. Implementa las funcionalidades básicas de tu módulo
4. Asegúrate de seguir las convenciones de código
5. Prueba tu módulo tanto de forma individual como integrada

## 📞 Soporte y Contacto

Si encuentras problemas durante la configuración, contacta a:

- **Coordinador del Proyecto:** Fernando Fleitas
- **Profesor:** Ing. Gustavo Sosa Cataldo (sosacataldo@gmail.com)

---

¡Listo para empezar! Ahora tienes todo lo necesario para trabajar en el proyecto de Alquiler de Autos con Flutter.