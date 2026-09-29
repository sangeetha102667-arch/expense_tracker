# Expense Tracker

A modern and user-friendly Expense Tracker mobile application built using Flutter.
A simple, clean Flutter expense tracking app built with Firebase Firestore.

## Features Implemented

- Add new expenses
- Edit existing expenses
- Update expense details
- Delete expenses
- View expense history
- Categorize expenses (Food, Transport, Shopping, Bills, Entertainment, Health, Other)
- Real-time storage and sync using Firebase Firestore
- Calculate monthly total expenses
- Search expenses by title
- Filter expenses by category
- Filter expenses by date range
- View expenses by selected month 
- Dark mode
- Expense history list
- Form validation (required title, valid positive amount)
- Loading, empty, and error states with retry
- Swipe-to-delete with confirmation dialog
- Empty state handling
- Clean and responsive mobile UI
- Sri Lankan Rupee (LKR) currency support
- Material 3 design

## Expense Details

Each expense can contain:

- Title
- Amount
- Category
- Date
- Note

## Technologies / Packages Used
- Flutter (Dart)
- Firebase Core & Cloud Firestore
- Provider (state management)
- Intl (date and currency formatting)

## Project Structure

```text
lib/
├── main.dart
├── models/
├── screens/
├── services/
└── providers/



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
- Write the form UI screens

All generated code was reviewed, tested on a physical Android device, and understood before submission.

