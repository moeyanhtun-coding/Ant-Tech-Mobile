# Ant Tech Mobile HR

A professional, feature-rich human resource management mobile application built with **Flutter**. This project follows **Clean Architecture** principles to ensure scalability, maintainability, and testability.

## 🏗️ Architecture: Clean Architecture

This project is built using **Uncle Bob's Clean Architecture**, which decouples the business logic from external concerns like UI, databases, and APIs.

### The Three Layers

1.  **Domain Layer (Entities, Use Cases, Repositories Interfaces)**:
    -   The core of the application. It contains the business logic.
    -   It is independent of any other layer or framework.
    -   **Entities**: Simple data objects.
    -   **Use Cases**: Specific business rules (e.g., "Get Attendance Requests").
    -   **Repository Interfaces**: Define the contract for data operations.

2.  **Data Layer (Repositories Implementations, Data Sources, Models)**:
    -   Responsible for retrieving and saving data.
    -   **Models**: JSON-serializable versions of Entities.
    -   **Data Sources**: Remote (API via Dio) or Local (SQLite/SharedPrefs).
    -   **Repository Implementations**: Implement the contracts defined in the Domain layer.

3.  **Presentation Layer (UI, BLoC, Widgets)**:
    -   Responsible for displaying data and handling user interaction.
    -   **BLoC (Business Logic Component)**: Manages state and maps events to states.
    -   **Widgets**: UI components that react to BLoC states.

---

## 🔄 Work Flow

The application follows a unidirectional data flow and strict layer boundaries:

1.  **User Interaction**: The user performs an action in the **UI** (e.g., clicks "Refresh").
2.  **Event Dispatch**: The UI sends an **Event** to the **BLoC**.
3.  **Use Case Execution**: The BLoC calls a **Use Case** from the Domain layer.
4.  **Data Retrieval**: The Use Case calls a method on the **Repository Interface**.
5.  **Data Logic**: The **Repository Implementation** (Data layer) decides whether to fetch from the **Remote Data Source** or **Local Data Source**.
6.  **Result Propagation**: The data flows back as an `Either<Failure, Success>` object.
7.  **State Update**: The BLoC emits a new **State** (Loading, Loaded, or Error).
8.  **UI Build**: The UI rebuilds automatically to reflect the new state.

---

## 📂 Project Structure

```text
lib/
├── core/               # Shared logic, utilities, errors, and themes
│   ├── constants/      # App-wide constants
│   ├── error/          # Failure and Exception classes
│   ├── network/        # Network info and connectivity checks
│   ├── params/         # Request parameters for Use Cases
│   └── usecases/       # Base UseCase interface
├── features/           # Feature-first organization
│   ├── attendance/     # Attendance tracking feature
│   │   ├── data/       # Models, Repositories Impl, Data Sources
│   │   ├── domain/     # Entities, Use Cases, Repositories
│   │   └── presentation/ # BLoC, Pages, Widgets
│   ├── auth/           # Authentication feature
│   ├── payroll/        # Payroll and Payslips feature
│   └── ...             # Other features (Home, Settings, etc.)
├── injection_container.dart # Dependency Injection setup (GetIt)
└── main.dart           # App entry point
```

---

## 📦 Key Packages

| Package | Purpose | Why We Use It |
| :--- | :--- | :--- |
| `flutter_bloc` | State Management | Decouples UI from business logic with a predictable state machine. |
| `get_it` | Dependency Injection | Centralizes object creation and management for better testability. |
| `dio` | HTTP Client | Powerful networking library with interceptors and global configuration. |
| `dartz` | Functional Programming | Provides `Either`, making error handling explicit and readable. |
| `equatable` | Object Comparison | Simplifies state comparison to prevent unnecessary UI rebuilds. |
| `shared_preferences` | Local Storage | Persists user settings and auth tokens locally. |
| `geolocator` | Location Services | Accurate GPS tracking for attendance validation. |
| `mobile_scanner` | QR Scanning | Fast and reliable QR code scanning for check-ins. |

---

## 🚀 Getting Started

1.  **Prerequisites**:
    -   Flutter SDK (^3.10.1)
    -   Dart SDK
2.  **Installation**:
    ```bash
    flutter pub get
    ```
3.  **Environment Setup**:
    -   Ensure your API base URL is configured in `lib/core/constants/constants.dart`.
4.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 🛠️ Other Technical Details

-   **Error Handling**: Uses custom `Failure` classes in the Domain layer and `Exceptions` in the Data layer.
-   **Dependency Injection**: All dependencies (Data Sources, Repositories, Use Cases, BLoCs) are registered in `injection_container.dart` using a singleton pattern where appropriate.
-   **Localization**: Integrated using `intl` for multi-language support (if applicable) and date formatting.
