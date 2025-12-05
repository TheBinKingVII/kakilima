# Kakilima

A Flutter project built with Clean Architecture principles.

## Project Structure

This project follows a feature-based Clean Architecture pattern, organizing code into distinct layers for better maintainability, testability, and scalability.

```
kakilima/
├── android/              # Android platform-specific code
├── ios/                  # iOS platform-specific code
├── linux/                # Linux platform-specific code
├── macos/                # macOS platform-specific code
├── web/                  # Web platform-specific code
├── windows/              # Windows platform-specific code
├── lib/                  # Main application code
│   ├── core/            # Shared utilities and core functionality
│   ├── features/        # Feature modules (organized by domain)
│   ├── screens/         # Top-level screen widgets
│   └── main.dart        # Application entry point
├── pubspec.yaml         # Flutter dependencies and configuration
└── analysis_options.yaml # Linter configuration
```

## Directory Details

### `/lib` - Main Application Code

The core of the application lives in the `lib` directory, following Clean Architecture principles.

#### `/lib/core` - Core Module
Shared utilities, constants, and core functionality used across the entire application.

- **`const.dart`** - Application-wide constants
- **`theme.dart`** - App theme configuration and styling
- **`failures/`** - Failure classes for error handling
  - `base_failure.dart` - Base failure class for error management
- **`utils/`** - Utility functions and helpers
  - `example_util.dart` - Example utility functions

#### `/lib/features` - Feature Modules
Each feature is organized as a self-contained module following Clean Architecture with three layers:

**Feature Structure:**
```
features/
└── [feature_name]/
    ├── data/           # Data layer (external data sources)
    │   ├── datasources/    # Remote/local data sources
    │   ├── models/         # Data models (DTOs)
    │   └── repositories/   # Repository implementations
    ├── domain/         # Domain layer (business logic)
    │   ├── entities/       # Business entities
    │   ├── repositories/   # Repository interfaces
    │   └── usecases/       # Business use cases
    └── presentation/   # Presentation layer (UI)
        ├── controllers/    # State management controllers
        ├── pages/          # Full page widgets
        └── widgets/        # Reusable UI components
```

**Current Features:**
- **`auth/`** - Authentication feature
  - `data/` - Authentication data sources, models, and repository implementations
  - `domain/` - Authentication entities, repository interfaces, and use cases
  - `presentation/` - Authentication UI, controllers, and widgets

#### `/lib/screens` - Top-Level Screens
High-level screen widgets that compose features together.

- **`main_screen.dart`** - Main application screen

#### `/lib/main.dart` - Application Entry Point
The main entry point of the Flutter application where the app is initialized and the root widget is created.

### Platform-Specific Directories

#### `/android` - Android Platform
Android-specific configuration and native code:
- `app/` - Android application module
  - `build.gradle.kts` - Build configuration
  - `src/` - Source files organized by build variants (debug, main, profile)
- `gradle/` - Gradle wrapper and configuration
- `build.gradle.kts` - Project-level build configuration
- `settings.gradle.kts` - Gradle settings

#### `/ios` - iOS Platform
iOS-specific configuration and native code:
- `Flutter/` - Flutter-generated iOS configuration
- `Runner/` - iOS app runner configuration
  - `Assets.xcassets/` - App icons and launch images
  - `Base.lproj/` - Storyboard files
- `Runner.xcodeproj/` - Xcode project files
- `Runner.xcworkspace/` - Xcode workspace
- `RunnerTests/` - iOS unit tests

#### `/web` - Web Platform
Web-specific assets and configuration:
- `index.html` - Web entry point
- `manifest.json` - Web app manifest
- `icons/` - Web app icons (PWA support)
- `favicon.png` - Browser favicon

#### `/linux`, `/macos`, `/windows` - Desktop Platforms
Desktop platform-specific configurations:
- CMake configuration files for Linux and Windows
- Xcode project files for macOS
- Native runner implementations

### Configuration Files

- **`pubspec.yaml`** - Flutter project configuration, dependencies, and assets
- **`analysis_options.yaml`** - Dart analyzer and linter configuration
- **`pubspec.lock`** - Locked dependency versions

## Architecture Principles

This project follows **Clean Architecture** principles:

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Rule**: Dependencies point inward (presentation → domain ← data)
3. **Testability**: Each layer can be tested independently
4. **Feature-Based Organization**: Features are self-contained modules

### Layer Responsibilities

- **Presentation Layer**: UI components, state management, user interactions
- **Domain Layer**: Business logic, entities, use cases (platform-independent)
- **Data Layer**: Data sources, API calls, local storage, repository implementations

## Getting Started

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

## Development Guidelines

- Add new features in `/lib/features/[feature_name]` following the three-layer structure
- Place shared utilities in `/lib/core`
- Keep platform-specific code in respective platform directories
- Follow the existing naming conventions and folder structure
