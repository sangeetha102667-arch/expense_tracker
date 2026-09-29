# Expense Tracker

A simple, clean Flutter expense tracking app built with Firebase Firestore.

## Features Implemented
- Add, edit, and delete expenses
- Categorize expenses (Food, Transport, Shopping, Bills, Entertainment, Health, Other)
- Real-time storage and sync using Firebase Firestore
- Monthly total calculation with month navigation
- Expense history list
- Filter by category and by date range
- Search expenses by title
- Form validation (required title, valid positive amount)
- Loading, empty, and error states with retry
- Swipe-to-delete with confirmation dialog

## Technologies / Packages Used
- Flutter (Dart)
- Firebase Core & Cloud Firestore
- Provider (state management)
- Intl (date and currency formatting)

## Setup Instructions
1. Clone the repository
2. Run `flutter pub get`
3. Create a Firebase project and enable Cloud Firestore
4. Add an Android app to the Firebase project with package name `com.example.expense_tracker`
5. Download `google-services.json` and place it in `android/app/`
6. Connect an Android device or emulator
7. Run `flutter run`

## AI Tools Used
This project was built with the help of Claude (Anthropic). Claude was used to:
- Generate the initial project structure (models, services, provider, screens)
- Write the Firestore integration (add/update/delete/stream expenses)
- Debug Gradle and Android Gradle Plugin version conflicts during setup
- Write the form validation logic and UI screens

All generated code was reviewed, tested on a physical Android device, and understood before submission.