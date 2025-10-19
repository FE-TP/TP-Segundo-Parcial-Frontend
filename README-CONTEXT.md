# 🚗 Sistema de Alquiler de Autos - Flutter

**Trabajo Práctico: Segundo Parcial**  
**Materia:** Programación Web - Frontend  
**Profesor:** Ing. Gustavo Sosa Cataldo  
**Fecha de Entrega:** Lunes 27/10/2025

---

## 📋 Descripción General

Aplicación mobile desarrollada en **Flutter** para la gestión integral de un sistema de alquiler de autos. La aplicación funciona **completamente en memoria local** sin necesidad de backend o API externa.

### Funcionalidades Principales

- ✅ Administración de Vehículos (CRUD completo)
- ✅ Administración de Clientes (CRUD completo)
- ✅ Gestión de Reservas (con validación de disponibilidad)
- ✅ Gestión de Entregas (devolución de vehículos)
- ✅ Estadísticas y Reportes básicos

---

## 👥 Equipo de Desarrollo

| Módulo | Responsable |
|--------|-------------|
| **Administración de Vehículos** | Fernando Fleitas |
| **Administración de Clientes** | José Ramirez |
| **Gestión de Reservas** | Lucas Vargas |
| **Gestión de Entregas** | Atilio Paredes |
| **Estadísticas Básicas** | Elias Figueredo |

---

## 🛠️ Requisitos Técnicos

### Tecnologías Obligatorias

- **Framework:** Flutter (última versión estable)
- **Persistencia:** Memoria local con listas o SharedPreferences (opcional)
- **Gestión de Estado:** Provider (recomendado)
- **Navegación:** Navigator 2.0 o navegación básica con rutas nombradas

### Especificaciones Técnicas

- ✅ Sin conexión a API o backend
- ✅ Interfaz responsive y coherente
- ✅ Componentes reutilizables
- ✅ Navegación fluida entre pantallas
- ✅ Filtrado de listas implementado

---

## 📁 Estructura de Carpetas

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart        # Paleta de colores del sistema
│   │   ├── app_theme.dart         # Tema global (light/dark)
│   │   └── text_styles.dart       # Estilos de texto reutilizables
│   │
│   ├── widgets/
│   │   ├── custom_app_bar.dart    # AppBar personalizado
│   │   ├── custom_button.dart     # Botones reutilizables
│   │   ├── custom_text_field.dart # Campos de texto personalizados
│   │   ├── loading_widget.dart    # Indicador de carga
│   │   ├── empty_state.dart       # Estado vacío para listas
│   │   └── confirmation_dialog.dart # Diálogos de confirmación
│   │
│   ├── utils/
│   │   ├── validators.dart        # Validadores de formularios
│   │   ├── date_formatter.dart    # Formateo de fechas
│   │   └── constants.dart         # Constantes globales
│   │
│   └── routes/
│       └── app_routes.dart        # Definición centralizada de rutas
│
├── modules/
│   ├── vehiculos/
│   │   ├── models/
│   │   │   └── vehiculo_model.dart
│   │   ├── pages/
│   │   │   ├── vehiculos_list_page.dart
│   │   │   └── vehiculo_form_page.dart
│   │   ├── widgets/
│   │   │   ├── vehiculo_card.dart
│   │   │   └── vehiculo_filter.dart
│   │   └── providers/
│   │       └── vehiculo_provider.dart
│   │
│   ├── clientes/
│   │   ├── models/
│   │   │   └── cliente_model.dart
│   │   ├── pages/
│   │   │   ├── clientes_list_page.dart
│   │   │   └── cliente_form_page.dart
│   │   ├── widgets/
│   │   │   ├── cliente_card.dart
│   │   │   └── cliente_filter.dart
│   │   └── providers/
│   │       └── cliente_provider.dart
│   │
│   ├── reservas/
│   │   ├── models/
│   │   │   └── reserva_model.dart
│   │   ├── pages/
│   │   │   ├── reservas_list_page.dart
│   │   │   └── reserva_form_page.dart
│   │   ├── widgets/
│   │   │   ├── reserva_card.dart
│   │   │   └── vehiculo_selector.dart
│   │   └── providers/
│   │       └── reserva_provider.dart
│   │
│   ├── entregas/
│   │   ├── models/
│   │   │   └── entrega_model.dart
│   │   ├── pages/
│   │   │   ├── entregas_list_page.dart
│   │   │   └── entrega_form_page.dart
│   │   ├── widgets/
│   │   │   └── entrega_card.dart
│   │   └── providers/
│   │       └── entrega_provider.dart
│   │
│   ├── estadisticas/
│   │   ├── pages/
│   │   │   └── estadisticas_page.dart
│   │   └── widgets/
│   │       ├── stat_card.dart
│   │       └── top_cliente_card.dart
│   │
│   └── home/
│       ├── pages/
│       │   └── home_page.dart
│       └── widgets/
│           └── menu_card.dart
│
├── app.dart                        # Configuración de la app (routes, theme)
└── main.dart                       # Punto de entrada
```

---

## 📦 Modelos de Datos

### 1️⃣ Vehículo

```dart
class Vehiculo {
  final int idVehiculo;
  String marca;
  String modelo;
  int anio;
  bool disponible;

  Vehiculo({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.disponible = true,
  });
}
```

### 2️⃣ Cliente

```dart
class Cliente {
  final int idCliente;
  String nombre;
  String apellido;
  String numeroDocumento;

  Cliente({
    required this.idCliente,
    required this.nombre,
    required this.apellido,
    required this.numeroDocumento,
  });
}
```

### 3️⃣ Reserva

```dart
class Reserva {
  final int idReserva;
  final int idCliente;
  final int idVehiculo;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool activa;

  Reserva({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaInicio,
    required this.fechaFin,
    this.activa = true,
  });
}
```

### 4️⃣ Entrega

```dart
class Entrega {
  final int idEntrega;
  final int idReserva;
  DateTime fechaEntregaReal;
  String? observaciones;
  int? kilometrajeFinal;

  Entrega({
    required this.idEntrega,
    required this.idReserva,
    required this.fechaEntregaReal,
    this.observaciones,
    this.kilometrajeFinal,
  });
}
```

---

## 🔧 Instalación y Configuración

### 1️⃣ Instalar Flutter

#### **Windows**

```bash
# Usando Chocolatey
choco install flutter

# Verificar instalación
flutter doctor
```

#### **macOS**

```bash
# Usando Homebrew
brew install flutter

# Verificar instalación
flutter doctor
```

#### **Linux (Ubuntu/Debian)**

```bash
# Usando Snap
sudo snap install flutter --classic

# Verificar instalación
flutter doctor
```

### 2️⃣ Configurar Android Studio

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

### 3️⃣ Clonar el Repositorio

```bash
git clone https://github.com/FE-TP/TP-Segundo-Parcial-Frontend
cd TP-Segundo-Parcial-Frontend
```

### 4️⃣ Instalar Dependencias

```bash
flutter pub get
```

### 5️⃣ Ejecutar la Aplicación

```bash
# Verificar dispositivos disponibles
flutter devices

# Ejecutar en emulador/dispositivo
flutter run

# Ejecutar en modo release
flutter run --release
```

---

## 📝 Convenciones de Código

### Nomenclatura

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| **Clases** | PascalCase | `VehiculoModel`, `ReservaPage` |
| **Archivos** | snake_case | `vehiculo_model.dart`, `reserva_provider.dart` |
| **Variables y funciones** | camelCase | `idVehiculo`, `agregarReserva()` |
| **Constantes** | UPPER_SNAKE_CASE | `MAX_VEHICULOS`, `DEFAULT_COLOR` |
| **Rutas** | kebab-case | `/vehiculos/lista`, `/reservas/nueva` |
| **Widgets privados** | _camelCase | `_buildHeader()`, `_vehiculosList` |

### Estructura de Archivos

```dart
// 1. Imports de Flutter
import 'package:flutter/material.dart';

// 2. Imports de paquetes externos
import 'package:provider/provider.dart';

// 3. Imports locales
import '../models/vehiculo_model.dart';
import '../providers/vehiculo_provider.dart';

// 4. Definición de clase
class VehiculoListPage extends StatelessWidget {
  // ...
}
```

### Comentarios

```dart
/// Documentación de clase (usar ///)
/// Gestiona la lista de vehículos disponibles
class VehiculoProvider extends ChangeNotifier {
  
  // Comentario simple (usar //)
  // Lista privada de vehículos
  final List<Vehiculo> _vehiculos = [];
  
  /// Getter público para acceder a los vehículos
  List<Vehiculo> get vehiculos => _vehiculos;
}
```

---

## 🎯 Especificaciones por Módulo

### 1️⃣ Módulo: Vehículos (Fernando Fleitas)

**Responsabilidades:**
- CRUD completo de vehículos
- Listado con filtro por marca/modelo
- Validación de datos de entrada
- Control de disponibilidad

**Archivos necesarios:**

```
modules/vehiculos/
├── models/
│   └── vehiculo_model.dart           # Modelo de datos
├── pages/
│   ├── vehiculos_list_page.dart      # Lista principal
│   └── vehiculo_form_page.dart       # Formulario crear/editar
├── widgets/
│   ├── vehiculo_card.dart            # Tarjeta individual
│   └── vehiculo_filter.dart          # Widget de filtrado
└── providers/
    └── vehiculo_provider.dart         # Gestión de estado
```

**Funcionalidades:**
- ✅ Agregar nuevo vehículo
- ✅ Editar vehículo existente
- ✅ Eliminar vehículo (con confirmación)
- ✅ Listar todos los vehículos
- ✅ Filtrar por marca
- ✅ Filtrar por modelo
- ✅ Mostrar estado de disponibilidad

**Validaciones:**
- Marca: obligatorio, mínimo 2 caracteres
- Modelo: obligatorio, mínimo 2 caracteres
- Año: entre 1900 y año actual + 1
- ID único autogenerado

---

### 2️⃣ Módulo: Clientes (José Ramirez)

**Responsabilidades:**
- CRUD completo de clientes
- Listado con filtro por nombre/documento
- Validación de documento único

**Archivos necesarios:**

```
modules/clientes/
├── models/
│   └── cliente_model.dart
├── pages/
│   ├── clientes_list_page.dart
│   └── cliente_form_page.dart
├── widgets/
│   ├── cliente_card.dart
│   └── cliente_filter.dart
└── providers/
    └── cliente_provider.dart
```

**Funcionalidades:**
- ✅ Agregar nuevo cliente
- ✅ Editar cliente existente
- ✅ Eliminar cliente (verificar que no tenga reservas activas)
- ✅ Listar todos los clientes
- ✅ Filtrar por nombre completo
- ✅ Filtrar por número de documento

**Validaciones:**
- Nombre: obligatorio, mínimo 2 caracteres
- Apellido: obligatorio, mínimo 2 caracteres
- Documento: obligatorio, único, solo números
- ID único autogenerado

---

### 3️⃣ Módulo: Reservas (Lucas Vargas)

**Responsabilidades:**
- Crear nuevas reservas
- Mostrar solo vehículos disponibles
- Marcar vehículo como no disponible al confirmar
- Validar fechas (inicio < fin)

**Archivos necesarios:**

```
modules/reservas/
├── models/
│   └── reserva_model.dart
├── pages/
│   ├── reservas_list_page.dart
│   └── reserva_form_page.dart
├── widgets/
│   ├── reserva_card.dart
│   ├── vehiculo_selector.dart
│   └── cliente_selector.dart
└── providers/
    └── reserva_provider.dart
```

**Funcionalidades:**
- ✅ Crear nueva reserva
- ✅ Listar reservas activas
- ✅ Listar historial de reservas
- ✅ Selector de cliente (dropdown/búsqueda)
- ✅ Selector de vehículo disponible
- ✅ Validación de fechas
- ✅ Actualización automática de disponibilidad

**Validaciones:**
- Cliente: debe existir
- Vehículo: debe estar disponible
- Fecha inicio: no puede ser anterior a hoy
- Fecha fin: debe ser posterior a fecha inicio
- ID único autogenerado

**Interacciones con otros módulos:**
- ⚙️ Al crear reserva: marcar vehículo como no disponible
- ⚙️ Obtener lista de vehículos disponibles desde VehiculoProvider
- ⚙️ Obtener lista de clientes desde ClienteProvider

---

### 4️⃣ Módulo: Entregas (Atilio Paredes)

**Responsabilidades:**
- Registrar devolución de vehículos
- Marcar vehículo como disponible nuevamente
- Cerrar reserva asociada

**Archivos necesarios:**

```
modules/entregas/
├── models/
│   └── entrega_model.dart
├── pages/
│   ├── entregas_list_page.dart
│   └── entrega_form_page.dart
├── widgets/
│   └── entrega_card.dart
└── providers/
    └── entrega_provider.dart
```

**Funcionalidades:**
- ✅ Registrar nueva entrega
- ✅ Seleccionar reserva activa
- ✅ Ingresar fecha de entrega real
- ✅ Agregar observaciones (opcional)
- ✅ Registrar kilometraje final (opcional)
- ✅ Listar historial de entregas

**Validaciones:**
- Reserva: debe estar activa
- Fecha entrega: no puede ser anterior a fecha inicio de reserva
- ID único autogenerado

**Interacciones con otros módulos:**
- ⚙️ Al completar entrega: marcar vehículo como disponible
- ⚙️ Al completar entrega: marcar reserva como inactiva
- ⚙️ Obtener reservas activas desde ReservaProvider
- ⚙️ Actualizar estado de vehículo en VehiculoProvider

---

### 5️⃣ Módulo: Estadísticas (Elias Figueredo)

**Responsabilidades:**
- Dashboard con métricas principales
- Cálculo de estadísticas en tiempo real
- Presentación visual de datos

**Archivos necesarios:**

```
modules/estadisticas/
├── pages/
│   └── estadisticas_page.dart
└── widgets/
    ├── stat_card.dart              # Tarjeta de estadística individual
    ├── top_cliente_card.dart       # Cliente con más reservas
    └── chart_widget.dart           # Gráficos (opcional)
```

**Funcionalidades:**
- ✅ Total de reservas activas
- ✅ Cantidad de vehículos disponibles
- ✅ Cliente con más reservas realizadas
- ✅ Total de vehículos registrados
- ✅ Total de clientes registrados
- ✅ Presentación visual clara (cards/gráficos)

**Cálculos necesarios:**

```dart
// Total reservas activas
reservas.where((r) => r.activa).length

// Vehículos disponibles
vehiculos.where((v) => v.disponible).length

// Cliente con más reservas
Map<int, int> conteoReservas = {};
// Contar reservas por cliente...
// Retornar el cliente con mayor conteo
```

**Interacciones con otros módulos:**
- ⚙️ Lee datos de VehiculoProvider
- ⚙️ Lee datos de ClienteProvider
- ⚙️ Lee datos de ReservaProvider
- ⚙️ NO modifica datos, solo consulta

---

## 🏠 Módulo: Home/Menú Principal

**Responsabilidad:** Navegación principal del sistema

**Archivos necesarios:**

```
modules/home/
├── pages/
│   └── home_page.dart
└── widgets/
    └── menu_card.dart              # Tarjeta para cada módulo
```

**Funcionalidades:**
- ✅ Menú principal con acceso a todos los módulos
- ✅ Tarjetas visuales para cada sección
- ✅ Navegación fluida
- ✅ Puede incluir resumen rápido de estadísticas

---

## 🔗 Gestión de Estado con Provider

### Configuración en `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar todos los providers
import 'modules/vehiculos/providers/vehiculo_provider.dart';
import 'modules/clientes/providers/cliente_provider.dart';
import 'modules/reservas/providers/reserva_provider.dart';
import 'modules/entregas/providers/entrega_provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehiculoProvider()),
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ReservaProvider()),
        ChangeNotifierProvider(create: (_) => EntregaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Ejemplo de Provider

```dart
import 'package:flutter/foundation.dart';
import '../models/vehiculo_model.dart';

class VehiculoProvider extends ChangeNotifier {
  final List<Vehiculo> _vehiculos = [];
  int _nextId = 1;

  List<Vehiculo> get vehiculos => List.unmodifiable(_vehiculos);

  List<Vehiculo> get vehiculosDisponibles =>
      _vehiculos.where((v) => v.disponible).toList();

  Vehiculo? getById(int id) {
    try {
      return _vehiculos.firstWhere((v) => v.idVehiculo == id);
    } catch (e) {
      return null;
    }
  }

  void agregar(Vehiculo vehiculo) {
    _vehiculos.add(vehiculo);
    _nextId++;
    notifyListeners();
  }

  void actualizar(Vehiculo vehiculo) {
    final index = _vehiculos.indexWhere((v) => v.idVehiculo == vehiculo.idVehiculo);
    if (index != -1) {
      _vehiculos[index] = vehiculo;
      notifyListeners();
    }
  }

  void eliminar(int id) {
    _vehiculos.removeWhere((v) => v.idVehiculo == id);
    notifyListeners();
  }

  void cambiarDisponibilidad(int id, bool disponible) {
    final vehiculo = getById(id);
    if (vehiculo != null) {
      vehiculo.disponible = disponible;
      notifyListeners();
    }
  }

  List<Vehiculo> filtrarPorMarca(String marca) {
    if (marca.isEmpty) return vehiculos;
    return _vehiculos
        .where((v) => v.marca.toLowerCase().contains(marca.toLowerCase()))
        .toList();
  }

  int get nextId => _nextId;
}
```

### Uso en Widgets

```dart
// Leer datos (rebuilds cuando cambia)
final vehiculos = context.watch<VehiculoProvider>().vehiculos;

// Leer datos (NO rebuilds)
final vehiculos = context.read<VehiculoProvider>().vehiculos;

// Llamar métodos
context.read<VehiculoProvider>().agregar(nuevoVehiculo);
```

---

## 🎨 Temas y Estilos

### Definir colores en `core/theme/app_colors.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  // Colores secundarios
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFF57C00);
  
  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutros
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
}
```

### Configurar tema en `core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
```

---

## 🚦 Flujo de Trabajo con Git

### Estructura de Ramas

```
main (producción)
├── develop (desarrollo)
    ├── feature/vehiculos
    ├── feature/clientes
    ├── feature/reservas
    ├── feature/entregas
    └── feature/estadisticas
```

### Comandos Básicos

```bash
# Crear rama para tu módulo
git checkout -b feature/vehiculos

# Guardar cambios
git add .
git commit -m "[Vehiculos] Agregar modelo y provider"

# Subir cambios
git push origin feature/vehiculos

# Actualizar desde develop
git checkout develop
git pull origin develop
git checkout feature/vehiculos
git merge develop

# Merge a develop (cuando el módulo esté completo)
git checkout develop
git merge feature/vehiculos
git push origin develop
```

### Mensajes de Commit

```
[Módulo] Descripción breve

Ejemplos:
[Vehiculos] Agregar modelo VehiculoModel
[Vehiculos] Implementar VehiculoProvider con CRUD
[Clientes] Crear pantalla de listado
[Reservas] Agregar validación de fechas
[Core] Crear widget CustomButton reutilizable
[Fix] Corregir filtro en lista de vehículos
```

---

## ✅ Checklist de Entrega

### Documentación

- [ ] README.md completo
- [ ] Manual de implementación paso a paso
- [ ] Comentarios en código complejo
- [ ] Diagramas de flujo (opcional)

### Funcionalidad

- [ ] Todos los CRUDs funcionando
- [ ] Navegación entre pantallas
- [ ] Filtros implementados
- [ ] Validaciones activas
- [ ] Estadísticas calculadas correctamente

### Calidad de Código

- [ ] Sin errores de compilación
- [ ] Sin warnings críticos
- [ ] Código formateado (`flutter format .`)
- [ ] Convenciones de nomenclatura respetadas
- [ ] Componentes reutilizables en `core/widgets/`

### Testing Manual

- [ ] Crear vehículo
- [ ] Editar vehículo
- [ ] Eliminar vehículo
- [ ] Crear cliente
- [ ] Editar cliente
- [ ] Eliminar cliente
- [ ] Crear reserva (vehículo queda no disponible)
- [ ] Registrar entrega (vehículo queda disponible)
- [ ] Ver estadísticas actualizadas
- [ ] Filtros funcionando

### Git/GitHub

- [ ] Repositorio compartido con `sosacataldo@gmail.com`
- [ ] Commits descriptivos
- [ ] Código en rama `main` o `develop`
- [ ] Sin archivos innecesarios (build/, .idea/, etc.)

---

## Datos Profesor

**Profesor:** Ing. Gustavo Sosa Cataldo  
**Email:** sosacataldo@gmail.com  
**GitHub/GitLab:** sosacataldo@gmail.com

### Consultas Frecuentes

**¿Puedo usar otra librería de estado?**  
Sí, pero Provider es el recomendado por su simplicidad.

**¿Es necesario implementar dark mode?**  
No es obligatorio, pero suma puntos.

**¿Puedo usar Firebase/SQLite?**  
Sí, son opcionales. La implementación básica es en memoria.

**¿Cómo manejo los IDs autoincrementales?**  
Usa un contador en el Provider:

```dart
int _nextId = 1;
int get nextId => _nextId++;
```

---

## 🎓 Recursos Adicionales

- [Documentación oficial de Flutter](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---
