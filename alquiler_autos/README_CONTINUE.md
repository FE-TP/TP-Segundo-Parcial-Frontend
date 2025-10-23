## Instrucciones de Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/FE-TP/TP-Segundo-Parcial-Frontend
cd TP-Segundo-Parcial-Frontend
```

2. Instalar dependencias:
```bash
cd alquiler_autos
flutter pub get
```

3. Ejecutar la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

El proyecto sigue una arquitectura modular:

```
lib/
├── core/                # Componentes compartidos
│   ├── theme/           # Temas y estilos
│   ├── widgets/         # Widgets reutilizables
│   ├── utils/           # Utilidades (validadores, formateadores)
│   └── routes/          # Definición de rutas
│
├── modules/             # Módulos de la aplicación
│   ├── vehiculos/       # Módulo de vehículos (completo)
│   ├── clientes/        # Módulo de clientes (pendiente)
│   ├── reservas/        # Módulo de reservas (pendiente)
│   ├── entregas/        # Módulo de entregas (pendiente)
│   ├── estadisticas/    # Módulo de estadísticas (pendiente)
│   └── home/            # Pantalla principal
│
├── app.dart             # Configuración de la app
└── main.dart            # Punto de entrada
```

## Convenciones de Código

- **Clases**: PascalCase (VehiculoModel)
- **Archivos**: snake_case (vehiculo_model.dart)
- **Variables/funciones**: camelCase (agregarVehiculo)
- **Constantes**: UPPER_SNAKE_CASE (MAX_VEHICULOS)
- **Widgets privados**: _camelCase (_buildCard)

## Flujo de Trabajo con Git

1. Crear rama para tu módulo:
```bash
git checkout -b feature/tu-modulo
```

2. Hacer commit de tus cambios:
```bash
git add .
git commit -m "[TuModulo] Descripción del cambio"
```

3. Subir cambios:
```bash
git push origin feature/tu-modulo
```

## Notas para Colaboradores

- Cada módulo debe ser completamente funcional por sí mismo
- Usar los widgets y utilidades de `core/` para mantener coherencia visual
- Implementar validación en todos los formularios
- Mantener la persistencia en memoria usando los providers
- Seguir el patrón de diseño ya implementado en el módulo de Vehículos

## Fecha de Entrega

Lunes 27/10/2025