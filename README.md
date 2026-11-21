
# Sell AI – AI-Powered Product Listing Assistant

Sell AI is a Flutter-based application designed to help online sellers create product listings more easily using AI.

The goal is to simplify product listing creation by turning product photos into useful listing content.

## Features

- User authentication (Login & Sign Up)
- Add products with multiple photos
- AI-assisted product listing generation
- Product title and description generation
- Product category and price suggestions
- Relevant tags for product listings
- Manage saved products
- View, edit and delete product details
- Firebase integration

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform app development |
| Dart | Application programming language |
| Firebase | Backend and app services |
| Cloud Functions | Server-side functionality |
| Gemini AI | AI-powered listing assistance |
| Git & GitHub | Version control |

## Project Structure

```text
lib/
├── main.dart
└── screens/
    ├── add_product_screen.dart
    ├── auth_gate.dart
    ├── home_screen.dart
    ├── listing_result_screen.dart
    ├── login_screen.dart
    ├── product_details_screen.dart
    ├── products_screen.dart
    ├── profile_screen.dart
    └── signup_screen.dart

functions/
└── index.js
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Firebase project

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Wasi709/sell-ai-assistant.git
```

2. Navigate to the project directory:

```bash
cd sell-ai-assistant
```

3. Install Flutter dependencies:

```bash
flutter pub get
```

### Firebase Configuration

Firebase configuration files are intentionally excluded from this repository.

To run the application:

- Configure your own Firebase project.
- Generate the Flutter Firebase configuration using FlutterFire CLI.
- Add the required Android Firebase configuration.
- Configure Firebase services used by the application.
- Set up the required Cloud Functions environment variables.

**Important:** Never upload API keys, private credentials, or `.env` files to GitHub.

## Screenshots

Screenshots will be added soon.

## Project Status

This project is under development.

## Developer

**Wasi Rashid**

- GitHub: [@Wasi709](https://github.com/Wasi709)

---

*Built with Flutter and AI to simplify product listing creation.*
