# 💪🏽 About ProgressPro

📈 Fitness trainers can keep track of their clients' progress with ProgressPro. The app is designed specifically for fitness instructors and allows them to easily monitor and track their clients' performance over time.

🏋🏽 Instructors can input and track their clients' weight and sizes, as well as set fitness goals and monitor progress towards achieving them.

⏰ This app is perfect for busy fitness instructors who want to stay organized and on top of their clients' progress without spending hours on paperwork and manual tracking.

### [🚀 ProgressPro API (Ktor)](https://github.com/hopingsteam/ProgressPro-API)
### [🌎 ProgressPro Web (React)](https://github.com/hopingsteam/ProgressPro-Web)

# 📱 ProgressPro Mobile (Flutter)

Home screen                |  All meetings screen      | Session details screen
:-------------------------:|:-------------------------:|:-------------------------:
![Simulator Screen Shot - iPhone 11 - 2023-03-06 at 16 52 09](https://user-images.githubusercontent.com/11734201/223145571-504aae63-82cd-4de0-890f-4fa2672fef46.png)  |  ![Simulator Screen Shot - iPhone 11 - 2023-03-06 at 16 52 12](https://user-images.githubusercontent.com/11734201/223145578-9ced644d-04d1-45ca-96f9-47970a202d16.png)  |  ![Simulator Screen Shot - iPhone 11 - 2023-03-06 at 16 52 19](https://user-images.githubusercontent.com/11734201/223145586-374bd931-8c9d-4e57-a6ae-b055c66fbd61.png)

----
#### 💾 Download it from

Google Play Store          |  Apple App Store      |
:-------------------------:|:----------------------:
[![google_store](https://user-images.githubusercontent.com/11734201/224337224-49da8a33-1822-4180-ad46-506dd98ee1a8.png)](https://play.google.com/store/apps/details?id=com.tpnindustries.progressp)   |   [![apple_store](https://user-images.githubusercontent.com/11734201/224337220-ab05546b-069e-4085-a76f-cabf5794922c.png)](https://apps.apple.com/app/progress-pro/id6446066882)

----

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

## 📦 Installing dependencies

    flutter pub get

## ▶️ Running

    flutter run

## 🔨 Building

Please following the official documentation of Flutter for the pre-requisites steps required for building the
app for a specific platform.
< [iOS Deployment (Flutter docs)](https://docs.flutter.dev/deployment/ios)
< [Android Deployment (Flutter docs)](https://docs.flutter.dev/deployment/android)


    flutter build ipa

Will build an .ipa file in `./build/ios/ipa/[project_name].ipa`. You will use that file for uploading your app
on App Store.

    flutter build appbundle

Will build an .aab file in `./build/app/outputs/bundle/release/app-release.aab`. You will use that file for uploading
your app on Play Store.
