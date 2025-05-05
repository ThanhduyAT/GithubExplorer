# 📱 GithubExplorer

**GithubExplorer** is a modern iOS app that allows users to explore GitHub profiles and user details using a clean, scalable architecture. Built with performance and maintainability in mind, it leverages modern iOS technologies such as **SwiftData**, **Swift Package Plugins**, and **modular architecture**.

---

## 🚀 Features

- 🔍 Fetch and display GitHub users
- 👤 View detailed information about individual users
- 💾 Persist data locally using SwiftData
- 🧪 Built-in unit testing with Apple’s modern **Testing framework** (iOS 17+)
- 🧱 Modular codebase with clear boundaries
- 🎯 Fast image caching with Kingfisher

---

## 🛠 Tech Stack

| Layer         | Technology                              |
|--------------|------------------------------------------|
| Architecture | Clean MVVM + Modular SwiftPM             |
| UI           | SwiftUI                                  |
| Networking   | Moya                                     |
| Image Caching| Kingfisher                               |
| DI           | Factory                                  |
| Persistence  | SwiftData                                |
| Linting      | SwiftLint via SwiftLintPlugin            |
| Testing      | Apple Testing framework (iOS 17+)        |

---

## 📦 Modular Architecture

This project follows a **modular architecture** using **Swift Package Manager**, making it scalable and easy to maintain.

### Module Breakdown

- **App Architecture**: The app is built using **Clean MVVM**, ensuring clear separation of concerns, independent features, and easy maintainability. Each team can focus on specific modules while remaining independent of others.
- **Feature/UserList**: Displays a list of GitHub users.
- **Core/Networking**: Networking logic powered by Moya for API calls.
- **Core/Common**: Shared UI components, constants, and reusable utilities that are used throughout the app.
- **Configurations**: Holds the configuration settings for different environments (e.g., development, production).
- **GitHubExplorer/Application**: Contains the application's coordinator and logic to communicate between different modules.

Each module is independently testable and reusable, allowing for easy feature expansion and maintenance.

---

## 🧰 SwiftLintPlugin Integration

Linting is enforced using a **custom SwiftLintPlugin** built on Swift Package Plugins.

### ✅ Setup

Make sure SwiftLint is installed:

```bash
brew install swiftlint
