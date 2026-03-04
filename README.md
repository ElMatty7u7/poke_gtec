# Pokedex GTec

Una aplicación interactiva del catálogo de Pokémon (Pokédex) desarrollada en **Flutter** utilizando los principios limpios de **Clean Architecture**. La aplicación consume la [PokéAPI](https://pokeapi.co/) para mostrar una lista paginada de Pokémon, permitiendo buscar Pokémon específicos y ver sus detalles.

---

## 🚀 Características Principales

- **Listado Paginado:** Carga progresiva de Pokémon al presionar el botón de "Cargar más", optimizando el uso de red.
- **Búsqueda Integrada:** Permite buscar un Pokémon específico por su nombre o ID exacto, conectándose de manera directa con la API.
- **Vista de Detalles:** Al tocar un Pokémon, la app descarga y muestra información adicional (altura, peso, tipos) con una transición fluida (Hero Animation).
- **Manejo de Estados de Carga:** Uso de la librería `skeletonizer` para mostrar esqueletos de carga amigables mientras se resuelven las peticiones de red.
- **Clean Architecture:** Separación estricta de responsabilidades a través de las capas de Dominio (`domain`), Datos (`data`) y Presentación (`presentation`).
- **Gestor de Estado Nativo:** Uso de `ChangeNotifier` y el patrón _Provider_ nativo para vincular la lógica de negocio con la interfaz de usuario de forma sencilla.
- **Personalización Nativa:** Splash screen y Launcher Icons configurados para hacer que la app se vea profesional en el dispositivo.

---

## 🛠️ Tecnologías y Paquetes Empleados

- **Framework:** [Flutter](https://flutter.dev/)
- **Lenguaje:** Dart
- **Peticiones HTTP:** [`http`](https://pub.dev/packages/http)
- **Efectos de Carga:** [`skeletonizer`](https://pub.dev/packages/skeletonizer)
- **Íconos de Aplicación:** [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
- **Pantalla de Inicio (Splash):** [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash)

---

## 📂 Patrón de Arquitectura (Clean Architecture)

El proyecto está organizado dentro de la carpeta `lib/` bajo la siguiente estructura:

```text
lib/
├── config/              # Configuración global como el AppTheme
├── data/
│   ├── datasources/     # Implementación de las llamadas a la API (PokeAPI)
│   ├── models/          # Modelos de datos (parseo JSON a objetos)
│   └── repositories/    # Implementación local de los repositorios del dominio
├── domain/
│   ├── entities/        # Entidades puras de negocio (ej. Pokemon)
│   ├── repositories/    # Contratos/Interfaces del repositorio
│   └── usecases/        # Lógica de negocio específica (GetPokemons, SearchPokemon)
└── presentation/
    ├── pages/           # Pantallas principales (PokemonHomePage, PokemonDetailPage)
    ├── providers/       # Gestores de estado (PokemonProvider)
    └── widgets/         # Componentes reutilizables (PokemonListView, PokemonSearchDelegate)
```

---

## ⚙️ Instrucciones de Instalación

Sigue estos pasos para clonar y ejecutar la aplicación en tu entorno local:

### 1. Requisitos Previos

Asegúrate de tener instalado en tu sistema:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión compatible con Material 3).
- Un emulador de Android/iOS configurado, o un dispositivo físico conectado.

### 2. Obtener el Proyecto

Clona este repositorio o descarga el código fuente y navega hasta el directorio del proyecto en tu terminal:

```bash
cd /ruta/hacia/el/proyecto/gtec
```

### 3. Instalar Dependencias

Ejecuta el siguiente comando para descargar todos los paquetes necesarios descritos en `pubspec.yaml`:

```bash
flutter pub get
```

### 4. Ejecutar la Aplicación

Inicia la aplicación en tu dispositivo o emulador activo usando:

```bash
flutter run
```

---

## 💡 Notas Adicionales

- Los sprites e imágenes de los Pokémon se sirven directamente de la URL base del raw de _Github Content_ (`https://raw.githubusercontent.com/PokeAPI/sprites/...`) para evitar la cascada de llamadas a la API sólo por imágenes, ahorrando ancho de banda.
- En la PokéAPI, las búsquedas por texto deben realizarse en minúsculas, por lo que la app ya se encarga de estandarizar la entrada del usuario antes de solicitar los datos.
