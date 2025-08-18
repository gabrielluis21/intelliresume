# IntelliResume

A new Flutter project designed to simplify and enhance the creation of professional resumes.

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/seu-usuario/intelliresume.git
cd intelliresume
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
- Create a project in the Firebase console.
- Configure your applications (Android, iOS, Web).
- Download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in the correct directories (`android/app/` and `ios/Runner/`).

### 4. Configure Environment Variables
- In the project root, copy the file `.env.example` to a new file called `.env`.
  ```bash
  cp .env.example .env
  ```
- Open the `.env` file and enter your API keys (OpenAI, Stripe, etc.).
- The `.env` file is already in `.gitignore` to ensure that your keys are not sent to the repository.

### 5. Run the Application
```bash
flutter run
```

For more details, see the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.