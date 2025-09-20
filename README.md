# Virtusize SDK Assignment

This repository contains a lightweight Flutter SDK that collects a shopper's
height and weight, calculates their BMI, and recommends an apparel size based on
Virtusize guidelines. It also includes a sample app that demonstrates how to
integrate and use the SDK.

## Features
- BMI based sizing logic with the ranges provided in the assignment brief
- Reusable `VirtusizeRecommendationView` widget that handles validation and UI
- Programmatic access to the recommendation engine via `VirtusizeCalculator`
- Sample Flutter app showcasing end-to-end usage

## Running the Sample App
1. Ensure Flutter is installed and available on your PATH.
2. Fetch packages: `flutter pub get`
3. Launch the demo: `flutter run`

The application starts on a single screen where you can enter height (cm) and
weight (kg) to receive the recommended size.

## SDK Integration Guide

### 1. Add the SDK to your project
Copy the `lib/virtusize_sdk` directory into your Flutter project or publish it
internally and add it as a dependency.

### 2. Import the library
```dart
import 'package:virtusize/virtusize_sdk/virtusize_sdk.dart';
```
Adjust the import path to match your package name if it differs from `virtusize`.

### 3. Use the ready-made widget
Embed the recommendation flow anywhere in your UI:
```dart
class MyProductScreen extends StatelessWidget {
  const MyProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VirtusizeRecommendationView();
  }
}
```
The widget manages form validation, BMI calculation, and result presentation.

### 4. Use the calculator directly (optional)
If you would rather build a custom UI, interact with the calculator API:
```dart
final calculator = const VirtusizeCalculator();
final result = calculator.recommend(heightCm: 172, weightKg: 70);
print(result.size.label); // -> M
print(result.message);    // -> Based on your info, size M is recommended.
```

## Size Rules (BMI)
- `S` – BMI < 18.5
- `M` – BMI between 18.5 and 24.9
- `L` – BMI between 25 and 29.9
- `XL` – BMI ≥ 30

These thresholds are encoded in `VirtusizeCalculator` so both the widget and
programmatic API stay in sync.

## Project Structure
```
lib/
  main.dart             # Sample application entry point
  virtusize_sdk/
    virtusize_sdk.dart  # Public exports for the SDK
    src/
      recommendation.dart
      recommendation_calculator.dart
      size_category.dart
      widgets/virtusize_recommendation_view.dart
```

Feel free to extend the SDK with analytics, localization, or a platform channel
layer if you need to connect it to a native Virtusize implementation.
