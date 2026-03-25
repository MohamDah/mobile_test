# FitLife — Kigali Gym Directory

A Flutter app for discovering, saving, and managing gyms across Kigali's three districts (Gasabo, Kicukiro, Nyarugenge). Built with Clean Architecture and the BLoC pattern.

---

## Features

- **Browse gyms** — real-time feed from Firestore, filterable by district
- **Gym detail** — photo gallery with dot indicators, amenity chips, Hero animation from feed card
- **Save gyms** — bookmark gyms with optimistic UI updates and rollback on failure
- **Authentication** — email/password sign-up & sign-in, Google Sign-In, password reset
- **Admin panel** — create, edit, and delete gym listings with Cloudinary image uploads
- **Settings** — dark/light mode toggle (persisted), default district filter, push notification preference
- **Route guards** — unauthenticated users redirected to login; non-admin users blocked from `/admin`

---

## Architecture

The project follows Clean Architecture with three layers:

```
lib/
├── core/               # Shared infrastructure (DI, router, theme, errors, constants)
├── domain/             # Entities, repository interfaces, use cases — no Flutter deps
├── data/               # Repository implementations, Firestore/Firebase datasources, models
└── presentation/       # BLoC/Cubit, pages, widgets
```

State management uses `flutter_bloc`. Each feature has its own BLoC or Cubit:

| BLoC / Cubit       | Responsibility                                       |
|--------------------|------------------------------------------------------|
| `AuthBloc`         | Firebase auth stream, sign-in, register, sign-out    |
| `GymBloc`          | Real-time Firestore gym stream, district filter, CRUD |
| `SavedGymsCubit`   | User's saved gym IDs, optimistic toggle              |
| `SettingsCubit`    | Default district, notifications (SharedPreferences)  |
| `ThemeCubit`       | Light/dark mode toggle (SharedPreferences)           |

Dependency injection is handled by `get_it` via a single `initDependencies()` call at startup. Navigation uses `go_router` with a `ChangeNotifier` bridge to `AuthBloc` for reactive redirects.

---

## Tech Stack

| Package                 | Purpose                               |
|-------------------------|---------------------------------------|
| `flutter_bloc`          | State management (BLoC pattern)       |
| `firebase_auth`         | Authentication                        |
| `cloud_firestore`       | Gym & user data (real-time streams)   |
| `google_sign_in`        | OAuth sign-in                         |
| `go_router`             | Declarative routing with guards       |
| `get_it`                | Service locator / dependency injection |
| `equatable`             | Value equality for entities & states  |
| `shared_preferences`    | Local persistence for settings/theme  |
| `cached_network_image`  | Gym photo loading with caching        |
| `image_picker`          | Gallery/camera access for admin form  |
| `http`                  | Cloudinary image upload               |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10.4
- A Firebase project with **Authentication** (Email/Password + Google) and **Firestore** enabled
- A Cloudinary account with an unsigned upload preset

### Setup

1. **Clone the repo**

   ```bash
   git clone <repo-url>
   cd fitlife_real
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   Run FlutterFire CLI to generate `lib/firebase_options.dart` for your project:

   ```bash
   flutterfire configure
   ```

   Then add your Web OAuth client ID to `lib/core/di/injection.dart`:

   ```dart
   GoogleSignIn(serverClientId: '<your-web-client-id>')
   ```

4. **Configure Cloudinary**

   Update the constants in `lib/data/datasources/remote/firebase_storage_datasource.dart`:

   ```dart
   static const String _cloudName = '<your-cloud-name>';
   static const String _uploadPreset = '<your-unsigned-preset>';
   ```

5. **Run the app**

   ```bash
   flutter run
   ```

### Firestore data model

**`gyms` collection**

| Field               | Type             |
|---------------------|------------------|
| `name`              | string           |
| `description`       | string           |
| `district`          | string           |
| `subscriptionPrice` | number           |
| `galleryUrls`       | array of strings |
| `amenities`         | array of strings |

**`users` collection**

| Field       | Type                       |
|-------------|----------------------------|
| `uid`       | string                     |
| `email`     | string                     |
| `role`      | string (`user` or `admin`) |
| `savedGyms` | array of gym IDs           |

To grant admin access to a user, set their `role` field to `"admin"` in Firestore.

---

## Running Tests

```bash
flutter test
```

Tests cover:

- **`AuthBloc`** — bad credentials → `AuthError`, successful registration → `RegistrationSuccess`, sign-out → `Unauthenticated`
- **`GymBloc`** — stream loading, district filtering (specific district and clear), delete operation, `FilterGymsByDistrictUseCase` unit tests
- **`ThemeCubit`** — initial state from persisted preference, toggle, explicit set, persistence verification
- **`DistrictDropdown`** — renders all options, emits correct values including `null` for "All Districts"
- **`GymCard`** — name, district, price, amenity chips, bookmark state, tap and save-toggle callbacks
