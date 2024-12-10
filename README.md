# GitHubUser

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.7-orange.svg)
![RxSwift](https://img.shields.io/badge/RxSwift-6.5-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

GitHubUser is an iOS application built to showcase GitHub user profiles with a focus on clean architecture, modular design, and a seamless user experience. The app uses **RxSwift**, **MVVM-C**, and modern best practices to deliver a scalable and testable codebase.

## Features

- 🚀 **Paginated GitHub Users**: Displays a paginated list of users.
- 🔍 **User Details**: Includes user profile, followers, following, and blog links.
- ⚡ **Local Cache**: Combines API and local storage for efficient data retrieval.
- 🌐 **Reactive UI**: Built with RxSwift for responsive and declarative code.
- 🎨 **Reusable Design System**: Consistent UI components.

## Tech Stack

- **Programming Language**: Swift 5.7
- **Frameworks**:
  - RxSwift & RxCocoa
  - Action
  - SDWebImage
  - Alamofire
  - ObjectMapper
- **Architecture**: MVVM-C (Model-View-ViewModel-Coordinator) + Clean architecture
- **Dependency Management**: CocoaPods
- **Testing**:
  - XCTest for unit testing.
  - Mocking dependencies for ViewModel and UseCase.

## Architecture

GitHubUser uses **Clean Architecture** and **MVVM-C** to ensure modularity, scalability, and testability.

### Clean Architecture Overview

Clean Architecture divides the app into well-defined layers, each with its responsibilities. This structure promotes:

1. **Separation of Concerns**: Each layer handles a specific aspect of the application.
2. **Dependency Rule**: Higher-level layers depend on abstractions in lower layers, avoiding direct dependencies.
3. **Testability**: Each layer can be tested independently due to loose coupling.

### Layers in Clean Architecture

1. **Presentation Layer**:
   - Contains **ViewControllers** and **ViewModels**.
   - Handles user interactions and updates the UI based on reactive streams.

2. **Domain Layer**:
   - Contains **UseCases** and core business logic.
   - Provides a bridge between the data and presentation layers.
   - Independent of UI and data sources, making it reusable across different platforms.

3. **Data Layer**:
   - Handles API calls, local caching, and data transformation.
   - Implements **Repositories** that abstract data sources (remote and local).
## Modular Architecture

GitHubUser employs a **Modular Architecture** by splitting the app into feature-focused and utility modules. This approach improves maintainability, reusability, and build times.

### Module Structure

1. **App**: The main app target that ties all modules together.
2. **Modules**:
   - **UserProfile**: Handles GitHub user-related features such as the user list and details.
   - **ApiClient**: Manages networking, API calls, and HTTP request logic.
   - **DesignSystem**: Provides reusable UI components and a consistent design language.
   - **Common**: Contains shared utilities like extensions, error handling, and type aliases.
3. **Third-party Dependencies**: Managed separately for clarity and maintainability.

### Example: UserProfile Module

The `UserProfile` module encapsulates all GitHub user-related functionality, including:

- **Views**: User list and detail screens.
- **ViewModels**: Manages UI state and business logic.
- **UseCases**: Coordinates application logic, such as fetching user data.
- **Repositories**: Abstracts data sources (remote API and local cache).

### Benefits of Modular Architecture

- **Separation of Concerns**: Features and utilities are isolated, reducing interdependencies.
- **Scalability**: New features can be added as separate modules without affecting the existing codebase.
- **Reusability**: Shared modules like `ApiClient` or `DesignSystem` can be reused across multiple apps.
- **Improved Build Times**: Changes in one module don't require rebuilding the entire project.

