# Diet & Nutrition App

A production-ready Flutter application for tracking calories, macronutrients, and following diet plans. Built with **Clean Architecture**, **Provider**, and **Firebase**.

## 🚀 Corrected & Implemented Features

### 1. Architecture (Clean & Scalable)
- **Features Split**: `auth`, `diet`, `home`, `tracker`.
- **Layers**:
    - **Domain**: Entities & Repository Interfaces (pure Dart).
    - **Data**: Models, Repository Implementations (Firebase logic).
    - **Presentation**: Providers (ViewModels) & Screens.
- **State Management**: `MultiProvider` at the root (`main.dart`) injecting all dependencies.

### 2. Diet Plans Feature (`features/diet`)
- **Entities**: `DietPlan`, `Meal`.
- **Repository**: Fetches plans from Firestore `diet_plans` collection.
- **UI**: `DietPlansScreen` displays available plans with a premium card layout.

### 3. Daily Calorie Tracker (`features/tracker`)
- **Entities**: `DailyLog`.
- **Repository**: Manages `users/{uid}/daily_logs/{date}`.
    - Uses **Firebase Transactions** to atomicially update total calories and macros when adding meals.
- **UI**:
    - `MealLoggerScreen`: Allows users to add meals (Food Name, Calories, Macros, Type).
    - `Dashboard`: Integated real-time "Calories Left" and Macro progress.

### 4. Integration
- **Dashboard**:
    - Shows "Calories Left" calculated from `Target - Consumed`.
    - Shows Macro progress bars (Protein, Carbs, Fats).
    - Quick Actions navigate to `MealLoggerScreen` and `DietPlansScreen`.
- **Navigation**: Full flow: Splash (Auth Check) -> Onboarding -> Login/Signup -> Gender Setup -> Dashboard.

## 🛠 Setup & Installation

1.  **Firebase**:
    - Add `google-services.json` to `android/app`.
    - Enable Authentication (Email/Password).
    - Enable Firestore Database.
2.  **Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run**:
    ```bash
    flutter run
    ```

## 🔒 Security
- **Firestore Rules**: Strict access control. Users can only read/write their own data (`users/{userId}`).
- **Data Integrity**: Transactions ensure daily log totals match individual meal sums.

## 🏗 Architecture Overview

```
lib/
├── core/               # Shared logic (Failures, UseCases)
├── features/
│   ├── auth/           # Authentication (Login, Signup)
│   ├── diet/           # Diet Plans & Plan viewing
│   ├── home/           # Dashboard & User Profile
│   └── tracker/        # Daily Calorie Logging
├── screens/            # Legacy screens integrated into features
└── main.dart           # App Entry & Dependency Injection
```
