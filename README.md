# loginpage

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 📱 Flutter University Application Tracker - Setup Guide

## 🚀 Introduction
This guide will help you set up the **Flutter University Application Tracker** project, which includes:
- **Google Sign-In** & **Firebase Authentication**
- **Firebase Firestore** for storing user details (name, profile picture)
- **Flutter Local Notifications** for push notifications
- **Tabbed Navigation** with **Home, Profile, and Settings**
- **Profile Picture Update**
- **Logout Button**

## 📂 Project Structure
```
/lib
  ├── main.dart          # Main entry point of the app
  ├── screens
  │   ├── home_page.dart     # Home screen
  │   ├── profile_page.dart  # Profile screen (update name, profile picture)
  │   ├── settings_page.dart # Settings & logout
  ├── services
  │   ├── auth_service.dart         # Firebase authentication
  │   ├── notification_service.dart # Local notification setup
  │   ├── firestore_service.dart    # Firestore database operations
```

## 🏗 Installation & Setup
1️⃣ **Clone the Repository**
```sh
git clone https://github.com/yourusername/flutter_project.git
cd flutter_project
```

2️⃣ **Install Dependencies**
```sh
flutter pub get
```

3️⃣ **Setup Firebase**
- Go to **[Firebase Console](https://console.firebase.google.com/)**.
- Create a new project and add your app.
- Download the **Google Services JSON** file:
  - **For Android:** Place `google-services.json` in `android/app/`.
  - **For iOS:** Place `GoogleService-Info.plist` in `ios/Runner/`.

4️⃣ **Enable Firebase Features**
- Enable **Authentication** (Google Sign-In, Email/Password Login)
- Enable **Firestore Database** (Store user profile details)

5️⃣ **Run the App**
```sh
flutter run
```

## 🔑 Firebase Authentication Setup
1. Enable **Google Sign-In** in Firebase Authentication.
2. Implement authentication logic in `auth_service.dart`.
3. Display user data (name, profile picture) in **Profile Tab**.

## 🔔 Push Notifications Setup
1. Add required permissions in `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```
2. Initialize notifications in `notification_service.dart`.
3. Add a button in the **Settings Tab** to trigger a test notification.

## 🏠 Tabbed Navigation Setup
- **Home Tab:** Displays general application info.
- **Profile Tab:** Allows updating name and profile picture.
- **Settings Tab:** Includes **Logout** and **Trigger Notification** button.

## 🛠 Common Issues & Fixes
### 1️⃣ Android `requestPermission()` Not Found Error
**Fix:** Update `flutter_local_notifications` to the latest version and use `requestPermissions()` instead.
```dart
await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestPermissions();
```

### 2️⃣ `compileDebugKotlin` Java Version Mismatch
**Fix:** Ensure the Java version in `android/gradle.properties` is consistent:
```properties
org.gradle.java.home=/path/to/java17
```

## 📜 License
This project is licensed under the **MIT License**.

## 💡 Author
Developed by **Ayush Juneja**. 🚀

---
🔗 **GitHub Repo:** [https://github.com/yourusername/flutter_project](https://github.com/yourusername/flutter_project)

