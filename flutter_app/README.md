# Khmer Luna Date - Flutter App

Cross-platform app for Windows, Mac, Android, and iOS using Flutter + WebView.

## Features
- Works fully **offline** — all assets bundled
- Calendar UI with Khmer lunar dates
- Copy / Share result
- Supports Windows, Mac, Android, iOS

## Requirements
- Flutter SDK >= 3.0: https://flutter.dev/docs/get-started/install
- For Android: Android Studio + Android SDK
- For iOS/Mac: Xcode (Mac only)
- For Windows: Visual Studio 2022 with Desktop development workload

## Build

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build release APK (Android)
flutter build apk --release

# Build for Windows
flutter build windows --release

# Build for macOS
flutter build macos --release

# Build for iOS
flutter build ios --release
```

## Distribution

- **Android:** Share the `.apk` from `build/app/outputs/flutter-apk/`
- **Windows:** Share the folder from `build/windows/x64/runner/Release/`
- **macOS:** Share the `.app` from `build/macos/Build/Products/Release/`
- **iOS:** Requires Apple Developer account ($99/year) for App Store

## Architecture

The app uses `flutter_inappwebview` to render your existing HTML/CSS/JS calendar UI as a WebView. All assets (HTML, CSS, JS, momentkh.js) are bundled in `assets/web/` and loaded locally — no internet required after install.

A JavaScript bridge allows the WebView to call Flutter's clipboard and share APIs natively.
