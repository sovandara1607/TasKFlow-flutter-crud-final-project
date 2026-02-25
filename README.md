<div align="center">

# ✅ TaskFlow

### A Full-Stack Task Management Application

**Flutter × Laravel — Modern, Beautiful, and Production-Ready**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Laravel](https://img.shields.io/badge/Laravel-12-FF2D20?logo=laravel&logoColor=white)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP-8.2+-777BB4?logo=php&logoColor=white)](https://php.net)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)]()

*A beautifully crafted, full-stack task management app featuring a Tiimo-inspired pastel UI, complete CRUD operations, token-based authentication with GitHub OAuth, dark mode, and bilingual localization (English/Khmer).*

---

**CS361 — Mobile Application Development • Final Project**
**Royal University of Phnom Penh • Spring 2026**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup (Laravel API)](#backend-setup-laravel-api)
  - [Frontend Setup (Flutter)](#frontend-setup-flutter)
- [API Reference](#-api-reference)
- [Database Schema](#-database-schema)
- [Authentication Flow](#-authentication-flow)
- [Screens & UI](#-screens--ui)
- [State Management](#-state-management)
- [Localization](#-localization)
- [Dependencies](#-dependencies)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🔍 Overview

**TaskFlow** is a cross-platform task management application built with a modern mobile-first approach. The project demonstrates end-to-end software engineering — from designing a RESTful API with Laravel Sanctum authentication to implementing a responsive, animated Flutter client with Provider-based state management.

The app empowers users to organize their daily tasks across customizable categories, track progress with real-time statistics, and stay on top of deadlines with an intelligent notification system — all wrapped in an elegant pastel-lavender design language.

---

## ✨ Key Features

### 🗂 Task Management (Full CRUD)
- **Create** tasks with title, description, due date, category, and status
- **Read** tasks with filtering by status (`Pending`, `In Progress`, `Completed`) and category (`General`, `School`, `Work`, `Home`, `Personal`)
- **Update** tasks inline with pre-populated edit forms
- **Delete** tasks with swipe-to-delete (Slidable) and confirmation dialogs
- **Toggle** task completion status with a single tap

### 🔐 Authentication & Security
- Email/password registration and login via **Laravel Sanctum** (token-based)
- **GitHub OAuth** sign-in with deep link callback (`taskflow://auth`)
- Auto-login with persisted tokens via `SharedPreferences`
- Token-scoped API — all task data is isolated per authenticated user
- Biometric authentication toggle (extensible via `local_auth`)

### 🎨 UI/UX Design
- **Tiimo-inspired** pastel/lavender design system with custom color palette
- **Material 3** with `colorSchemeSeed` and full light/dark theme support
- **Google Fonts (Poppins)** typography throughout
- Smooth animations: splash fade/scale, card transitions, navigation effects
- Responsive layout adapting to different screen sizes

### 🌍 Internationalization
- Bilingual support: **English** and **Khmer** (ភាសាខ្មែរ)
- 90+ translated UI strings with runtime locale switching
- Custom in-app localization engine (no build-time code generation required)

### 📊 Dashboard & Analytics
- Today view with time-of-day aware greeting
- Real-time task statistics: Total, Pending, Active, Completed
- Overdue/due-today/upcoming task notification center
- Grouped task lists by status with visual indicators

### ⚙️ Settings & Preferences
- Dark mode toggle with system-wide theme propagation
- Language selector (EN/KM)
- Push notification and biometric toggles
- All preferences persisted across sessions

---

## 🛠 Tech Stack

| Layer | Technology | Purpose |
|:---:|:---|:---|
| **Frontend** | Flutter 3.x / Dart 3.10 | Cross-platform mobile & web UI |
| **State Management** | Provider (ChangeNotifier) | Reactive state propagation |
| **Backend** | Laravel 12 / PHP 8.2+ | RESTful API server |
| **Authentication** | Laravel Sanctum | Token-based API authentication |
| **OAuth** | Laravel Socialite | GitHub OAuth 2.0 integration |
| **Database** | MySQL | Relational data persistence |
| **HTTP Client** | `package:http` | REST API communication |
| **Local Storage** | SharedPreferences | Token & settings persistence |
| **Typography** | Google Fonts (Poppins) | Consistent design language |
| **Deep Links** | `app_links` / `url_launcher` | OAuth callback handling |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter Client                           │
│                                                                 │
│  ┌───────────┐   ┌───────────────┐   ┌────────────────────┐    │
│  │  Screens   │──▶│   Providers   │──▶│    API Service      │    │
│  │  (UI)      │◀──│ (State Mgmt)  │◀──│   (HTTP Client)     │    │
│  └───────────┘   └───────────────┘   └─────────┬──────────┘    │
│                                                 │               │
│  ┌───────────┐   ┌───────────────┐              │               │
│  │  Widgets   │   │    Models     │              │               │
│  │(Reusable)  │   │  (Data Layer) │              │               │
│  └───────────┘   └───────────────┘              │               │
└─────────────────────────────────────────────────┼───────────────┘
                                                  │ HTTP/REST
                                                  │ Bearer Token
┌─────────────────────────────────────────────────┼───────────────┐
│                      Laravel API                │               │
│                                                 ▼               │
│  ┌───────────┐   ┌───────────────┐   ┌────────────────────┐    │
│  │  Routes    │──▶│  Controllers  │──▶│  Eloquent Models    │    │
│  │ (api.php)  │   │  (Auth/Task)  │   │  (User / Task)      │    │
│  └───────────┘   └───────────────┘   └─────────┬──────────┘    │
│                                                 │               │
│  ┌───────────┐   ┌───────────────┐              │               │
│  │  Sanctum   │   │  Migrations   │              ▼               │
│  │ (Tokens)   │   │  (Schema)     │       ┌──────────┐          │
│  └───────────┘   └───────────────┘       │  MySQL    │          │
│                                           └──────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
taskflow/
├── lib/                          # Flutter application source
│   ├── main.dart                 # App entry point, theme config, route definitions
│   ├── l10n/
│   │   └── app_localizations.dart   # Bilingual translations (EN/KM)
│   ├── models/
│   │   └── task.dart             # Task data model (fromJson, toJson, copyWith)
│   ├── screens/
│   │   ├── splash_screen.dart    # Animated splash with auto-login check
│   │   ├── login_screen.dart     # Email/password + GitHub OAuth login
│   │   ├── register_screen.dart  # User registration form
│   │   ├── main_shell.dart       # Bottom navigation shell (3 tabs)
│   │   ├── home_screen.dart      # Today dashboard with stats & greeting
│   │   ├── task_list_screen.dart  # Filterable task list with search
│   │   ├── add_task_screen.dart   # Create new task form
│   │   ├── edit_task_screen.dart  # Edit existing task form
│   │   ├── profile_screen.dart   # User profile & task statistics
│   │   ├── settings_screen.dart  # App preferences & appearance
│   │   └── notifications_screen.dart  # Overdue/upcoming task alerts
│   ├── services/
│   │   ├── api_service.dart      # REST client (CRUD operations)
│   │   ├── auth_service.dart     # Auth API calls (login, register, OAuth)
│   │   ├── auth_provider.dart    # Auth state management (ChangeNotifier)
│   │   ├── task_provider.dart    # Task state management (ChangeNotifier)
│   │   └── app_settings_provider.dart  # Settings persistence
│   ├── utils/
│   │   ├── constants.dart        # Colors, dimensions, helper methods
│   │   └── validators.dart       # Form validation utilities
│   └── widgets/
│       ├── app_dialogs.dart      # Reusable dialog/bottom sheet utilities
│       ├── app_drawer.dart       # Navigation drawer with user info
│       ├── custom_text_field.dart # Styled text input component
│       └── task_card.dart        # Animated task display card
│
├── taskflow-api/                 # Laravel backend API
│   ├── app/
│   │   ├── Http/Controllers/Api/
│   │   │   ├── AuthController.php    # Auth endpoints (register, login, OAuth)
│   │   │   └── TaskController.php    # Task CRUD endpoints
│   │   └── Models/
│   │       ├── User.php              # User model (Sanctum, Socialite)
│   │       └── Task.php              # Task model (Eloquent)
│   ├── database/migrations/         # Schema migrations (8 files)
│   ├── routes/
│   │   ├── api.php                   # API route definitions
│   │   └── web.php                   # OAuth redirect routes
│   └── ...
│
├── test/                         # Widget & unit tests
├── assets/images/                # Static image assets
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # You are here
```

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version | Installation |
|:---|:---|:---|
| Flutter SDK | 3.x+ | [flutter.dev/get-started](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥ 3.10 | Included with Flutter |
| PHP | ≥ 8.2 | [php.net](https://php.net) |
| Composer | Latest | [getcomposer.org](https://getcomposer.org) |
| MySQL | 8.0+ | [mysql.com](https://dev.mysql.com/downloads/) |
| Node.js | 18+ | [nodejs.org](https://nodejs.org) *(optional, for Laravel Mix)* |

### Backend Setup (Laravel API)

```bash
# 1. Navigate to the API directory
cd taskflow-api

# 2. Install PHP dependencies
composer install

# 3. Configure environment
cp .env.example .env
php artisan key:generate

# 4. Configure your database in .env
#    DB_CONNECTION=mysql
#    DB_HOST=127.0.0.1
#    DB_PORT=3306
#    DB_DATABASE=taskflow
#    DB_USERNAME=
#    DB_PASSWORD=

# 5. Configure GitHub OAuth in .env (optional)
#    GITHUB_CLIENT_ID=your_github_client_id
#    GITHUB_CLIENT_SECRET=your_github_client_secret
#    GITHUB_REDIRECT_URL=http://127.0.0.1:8000/login/oauth2/code/github

# 6. Run database migrations
php artisan migrate

# 7. Start the development server
php artisan serve
# API will be available at http://127.0.0.1:8000
```

### Frontend Setup (Flutter)

```bash
# 1. Navigate to the project root
cd flutter_final_project_app_with_full_ui_and_api_crud_integration

# 2. Install Flutter dependencies
flutter pub get

# 3. Verify the API base URL in lib/services/api_service.dart
#    Default: http://127.0.0.1:8000/api

# 4. Run on your target platform
flutter run                    # Default connected device
flutter run -d chrome          # Web
flutter run -d ios             # iOS Simulator
flutter run -d android         # Android Emulator

# 5. Build for production
flutter build apk              # Android APK
flutter build ios              # iOS Archive
flutter build web              # Web deployment
```

---

## 📡 API Reference

> **Base URL:** `http://127.0.0.1:8000/api`
> **Authentication:** Bearer Token (Laravel Sanctum)

### Authentication Endpoints

| Method | Endpoint | Description | Auth |
|:---:|:---|:---|:---:|
| `POST` | `/register` | Register a new user | ✗ |
| `POST` | `/login` | Authenticate & receive token | ✗ |
| `POST` | `/auth/github` | GitHub OAuth token exchange | ✗ |
| `GET` | `/user` | Get authenticated user profile | ✓ |
| `POST` | `/logout` | Revoke current access token | ✓ |

### Task Endpoints (Protected)

| Method | Endpoint | Description | Auth |
|:---:|:---|:---|:---:|
| `GET` | `/tasks` | List all tasks for current user | ✓ |
| `POST` | `/tasks` | Create a new task | ✓ |
| `GET` | `/tasks/{id}` | Get a specific task | ✓ |
| `PUT` | `/tasks/{id}` | Update a task | ✓ |
| `DELETE` | `/tasks/{id}` | Delete a task | ✓ |

### Request/Response Examples

<details>
<summary><b>POST /register</b></summary>

**Request:**
```json
{
  "username": "dara",
  "email": "dara@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response (201):**
```json
{
  "user": {
    "id": 1,
    "username": "dara",
    "email": "dara@example.com"
  },
  "token": "1|abc123..."
}
```
</details>

<details>
<summary><b>POST /tasks</b></summary>

**Request:**
```json
{
  "title": "Complete CS361 project",
  "description": "Finish the Flutter CRUD final project",
  "status": "in_progress",
  "category": "school",
  "due_date": "2026-03-01"
}
```

**Response (201):**
```json
{
  "id": 1,
  "title": "Complete CS361 project",
  "description": "Finish the Flutter CRUD final project",
  "status": "in_progress",
  "category": "school",
  "due_date": "2026-03-01",
  "user_id": 1,
  "created_at": "2026-02-25T10:00:00.000000Z",
  "updated_at": "2026-02-25T10:00:00.000000Z"
}
```
</details>

### Validation Rules

| Field | Rules |
|:---|:---|
| `title` | Required, string |
| `description` | Optional, string |
| `status` | Optional, one of: `pending`, `in_progress`, `completed` |
| `category` | Optional, one of: `general`, `school`, `work`, `home`, `personal` |
| `due_date` | Optional, valid date format |

---

## 🗄 Database Schema

### Users Table
| Column | Type | Constraints |
|:---|:---|:---|
| `id` | BIGINT | Primary Key, Auto Increment |
| `username` | VARCHAR | Required |
| `email` | VARCHAR | Required, Unique |
| `password` | VARCHAR | Nullable (for OAuth users) |
| `github_id` | VARCHAR | Nullable, Unique |
| `avatar` | VARCHAR | Nullable |
| `email_verified_at` | TIMESTAMP | Nullable |
| `remember_token` | VARCHAR | Nullable |
| `created_at` | TIMESTAMP | Auto-managed |
| `updated_at` | TIMESTAMP | Auto-managed |

### Tasks Table
| Column | Type | Constraints |
|:---|:---|:---|
| `id` | BIGINT | Primary Key, Auto Increment |
| `title` | VARCHAR | Required |
| `description` | TEXT | Nullable |
| `status` | ENUM | `pending`, `in_progress`, `completed` (default: `pending`) |
| `category` | VARCHAR | Default: `general` |
| `due_date` | DATE | Nullable |
| `user_id` | BIGINT | Foreign Key → `users.id` (CASCADE delete) |
| `created_at` | TIMESTAMP | Auto-managed |
| `updated_at` | TIMESTAMP | Auto-managed |

---

## 🔑 Authentication Flow

### Email/Password Authentication
```
User → Login Screen → AuthService.login() → POST /api/login
                                                    ↓
                                            Sanctum Token
                                                    ↓
                              SharedPreferences ← AuthProvider ← Token stored
                                                    ↓
                              ApiService.setToken() → All subsequent requests
                                                      include Bearer token
```

### GitHub OAuth Flow
```
1. User taps "Sign in with GitHub"
2. url_launcher opens → GET /auth/github/redirect (Laravel)
3. Laravel redirects → GitHub Authorization Page
4. User authorizes → GitHub redirects → GET /login/oauth2/code/github (Laravel)
5. Laravel creates/finds user → Generates Sanctum token
6. Redirect to deep link → taskflow://auth?token={TOKEN}
7. AppLinks listener captures URI → AuthProvider.loginWithToken()
8. Token persisted → User authenticated
```

### Auto-Login
```
App Launch → SplashScreen → AuthProvider.tryAutoLogin()
                                    ↓
                          SharedPreferences.get('token')
                                    ↓
                          GET /api/user (validate token)
                                    ↓
                        Valid? → Navigate to Home
                        Invalid? → Navigate to Login
```

---

## 🖥 Screens & UI

| # | Screen | Description |
|:-:|:---|:---|
| 1 | **Splash** | Animated logo with fade/scale transition, auto-login check |
| 2 | **Login** | Email/password form + GitHub OAuth button with deep link listener |
| 3 | **Register** | Registration form with real-time validation (8+ char password) |
| 4 | **Home (Today)** | Dashboard with greeting, date, stat bubbles, grouped task lists |
| 5 | **Task List** | Searchable, filterable list with status/category chips & swipe actions |
| 6 | **Add Task** | Create form with visual category selector and date picker |
| 7 | **Edit Task** | Pre-populated edit form with delete capability |
| 8 | **Profile** | User avatar, info, live task statistics, app/course info |
| 9 | **Settings** | Theme toggle, language selector, notification/biometric preferences |
| 10 | **Notifications** | Overdue, due-today, and upcoming task sections |
| 11 | **Navigation Drawer** | Gradient header, quick links to all screens, logout |

### Design System

| Element | Value |
|:---|:---|
| **Primary Color** | `#8B7EC8` (Lavender) |
| **Primary Light** | `#B8ACE6` |
| **Primary Dark** | `#6B5CA5` |
| **Accent Colors** | Pink `#FFB5C2`, Mint `#B8E6CF`, Peach `#FFD4A8`, Sky `#A8D4FF` |
| **Corner Radius** | Cards: `20px`, Inputs: `16px` |
| **Font** | Poppins (Google Fonts) |
| **Design Language** | Material 3 with custom pastel/lavender theme |

---

## 🧩 State Management

TaskFlow uses **Provider** with `ChangeNotifier` for reactive state management across three providers:

| Provider | Responsibility |
|:---|:---|
| `AuthProvider` | User authentication state, token management, auto-login |
| `TaskProvider` | Task CRUD operations, list management, computed statistics |
| `AppSettingsProvider` | Theme mode, locale, notifications, biometrics, user preferences |

All providers are injected at the root via `MultiProvider` and consumed with `context.watch<T>()` / `context.read<T>()` throughout the widget tree.

---

## 🌐 Localization

TaskFlow supports full bilingual UI localization:

| Language | Code | Coverage |
|:---|:---:|:---|
| English | `en` | ✅ Complete (90+ strings) |
| Khmer (ភាសាខ្មែរ) | `km` | ✅ Complete (90+ strings) |

Language can be switched at runtime from **Settings → Language** and is persisted across sessions via `SharedPreferences`.

---

## 📦 Dependencies

### Flutter (Frontend)

| Package | Version | Purpose |
|:---|:---:|:---|
| `provider` | ^6.1.2 | State management |
| `http` | ^1.2.1 | HTTP client for REST API |
| `google_fonts` | ^6.2.1 | Poppins typography |
| `shared_preferences` | ^2.2.3 | Local key-value persistence |
| `flutter_slidable` | ^3.1.1 | Swipe-to-action on task cards |
| `local_auth` | ^2.3.0 | Biometric authentication |
| `url_launcher` | ^6.2.5 | External URL/browser launching |
| `app_links` | ^6.3.3 | Deep link handling (OAuth callback) |
| `font_awesome_flutter` | ^10.8.0 | GitHub & social icons |
| `intl` | ^0.19.0 | Date formatting & i18n |

### Laravel (Backend)

| Package | Version | Purpose |
|:---|:---:|:---|
| `laravel/framework` | ^12.0 | Core framework |
| `laravel/sanctum` | ^4.3 | API token authentication |
| `laravel/socialite` | ^5.24 | GitHub OAuth integration |

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'feat: add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

Please follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with ❤️ using Flutter & Laravel**

*TaskFlow — Organize your life, one task at a time.*

</div>
