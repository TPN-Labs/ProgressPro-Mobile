# 💪🏽 About ProgressPro

📈 Fitness trainers can keep track of their clients' progress with ProgressPro. The app is designed specifically for fitness instructors and allows them to easily monitor and track their clients' performance over time.

🏋🏽 Instructors can input and track their clients' weight and sizes, as well as set fitness goals and monitor progress towards achieving them.

⏰ This app is perfect for busy fitness instructors who want to stay organized and on top of their clients' progress without spending hours on paperwork and manual tracking.

# 🚀 ProgressPro API: [here](https://github.com/hopingsteam/ProgressPro-API)

## 💻 Development

We recommend using IntelliJ for developing, running and testing the app functionalities.

The application was built with:

- [Flutter 3](https://github.com/flutter/flutter) as mobile framework
- [Get Storage 2.0](https://github.com/InsertKoinIO/koin) as local database for caching data
- [Intl 0.17](https://github.com/dart-lang/intl) for internationalization and localization support
- [Syncfusion Datepicker 20.2](https://github.com/syncfusion/flutter-examples) for picking dates from a calendar

### 📁 Project Structure

      + assets/
          Images and other static assets
      + lib/
        + config
            All app setups
        + controller
            Logic layer for processing data from the API
        + l10n
            Translations
        + model
            Persistence layer and object (student, meeting, etc) definitions
        + view
            Main user-story screens
        + widget
            Custom re-utilizable elements

        - main.dart <- The main class

## 🔨 Building

    flutter pub get

## ▶️ Running

    flutter run
