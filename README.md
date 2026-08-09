# Trip Expense Manager

A Flutter app for managing 3-day trip expenses among friends.

## Features
- Create multiple trips
- Add up to 20 members per trip
- Record daily expenses with custom participants per expense
- Automatic fair-share calculation
- Settlement suggestions (who pays whom)
- Reports with CSV export
- Offline-first with Hive local storage

## Login
- Username: `admin`
- Password: `admin`

## Build Instructions

### Local Build (Android APK)
```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

### Codemagic Build
1. Push this repo to GitHub
2. Connect repo to [codemagic.io](https://codemagic.io)
3. The `codemagic.yaml` is already configured
4. Start build → APK will be generated automatically

## Tech Stack
- Flutter 3.x
- Hive (local database)
- Provider (state management)
- Material 3 design
