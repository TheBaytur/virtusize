import 'size_category.dart';

// Represents a size recommendation based on user data.

class VirtusizeRecommendation {
  VirtusizeRecommendation({
    required this.size,
    required this.bmi,
    required this.message,
  });

  final VirtusizeSize size;
  final double bmi;
  final String message;

  String get bmiLabel => bmi.toStringAsFixed(1);
}
