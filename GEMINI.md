
# IntelliResume Project Documentation

## 1. Overview

IntelliResume is a Flutter-based application (PWA and Mobile) for creating and managing professional resumes. It leverages AI to provide features like resume evaluation, translation, and grammar correction.

## 2. Architecture

The project follows a clean architecture pattern, separating the code into three main layers:

*   **Data:** Handles data sources (local and remote) and repositories.
*   **Domain:** Contains business logic, use cases, and entities.
*   **Presentation:** Includes UI components (pages, widgets) and state management.

## 3. AI Integration

The AI-powered features are provided by the `AIService` class, which acts as a wrapper for an AI provider's SDK. Currently, the project uses the `chat_gpt_sdk` package to interact with the OpenAI API.

### 3.1. `AIService`

The `AIService` class (`lib/services/ia_services.dart`) is a singleton that provides the following methods:

*   `evaluate(String text)`: Evaluates a resume.
*   `translate(String text, String to)`: Translates a resume to a specified language.
*   `correct(String text)`: Corrects grammar and style errors in a resume.

### 3.2. Swapping AI Providers

To use a different AI provider, you need to:

1.  **Create a new `AIService` implementation:**
    *   Create a new class that implements the same public methods as the existing `AIService` (`evaluate`, `translate`, `correct`).
    *   This new class will use the SDK of the desired AI provider.

2.  **Update the dependency injection:**
    *   In the `lib/di.dart` file, replace the instantiation of the current `AIService` with your new implementation.

**Example:**

Let's say you want to use a fictional "MyAwesomeAI" provider.

1.  **Create `my_awesome_ai_service.dart`:**

    ```dart
    class MyAwesomeAIService {
      // Singleton
      MyAwesomeAIService._();
      static final instance = MyAwesomeAIService._();
    
      // Initialize the MyAwesomeAI SDK
      final _myAwesomeAI = MyAwesomeAI.initialize(apiKey: 'YOUR_AWESOME_AI_KEY');
    
      Future<String> evaluate(String text) async {
        // Implement resume evaluation using MyAwesomeAI SDK
      }
    
      Future<String> translate(String text, String to) async {
        // Implement resume translation using MyAwesomeAI SDK
      }
    
      Future<String> correct(String text) async {
        // Implement grammar correction using MyAwesomeAI SDK
      }
    }
    ```

2.  **Update `lib/di.dart`:**

    ```dart
    // import 'package:intelliresume/services/my_awesome_ai_service.dart';
    import 'package:intelliresume/services/ia_services.dart';
    
    // ...
    
    // final aiService = MyAwesomeAIService.instance;
    final aiService = AIService.instance;
    
    // ...
    ```

## 4. Dependencies

The main dependencies of the project are listed in the `pubspec.yaml` file. Key dependencies include:

*   `flutter`
*   `cloud_firestore`
*   `firebase_auth`
*   `chat_gpt_sdk`
*   `flutter_riverpod`
*   `go_router`

## 5. Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-repository/intelliresume.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Set up Firebase:**
    *   Create a new Firebase project.
    *   Configure your Android and iOS apps in the Firebase console.
    *   Download the `google-services.json` and `GoogleService-Info.plist` files and place them in the `android/app` and `ios/Runner` directories, respectively.
4.  **Set up AI Provider:**
    *   Get an API key from your chosen AI provider.
    *   In the `lib/services/ia_services.dart` file, replace `'YOUR_OPENAI_API_KEY'` with your actual API key.
5.  **Run the app:**
    ```bash
    flutter run
    ```
