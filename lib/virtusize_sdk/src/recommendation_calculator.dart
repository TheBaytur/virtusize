import 'recommendation.dart';
import 'size_category.dart';

// Calculates size recommendations based on user data.
// 14.10

class VirtusizeCalculator {
  const VirtusizeCalculator();

  VirtusizeRecommendation recommend({
    required double heightCm,
    required double weightKg,
  }) {
    if (heightCm <= 0 || weightKg <= 0) {
      throw ArgumentError('Height and weight should be greater than zero');
    }

    final bmi = _calculateBmi(heightCm: heightCm, weightKg: weightKg);
    final size = _sizeForBmi(bmi);
    final message = 'Based on your info, size ${size.label} is recommended.';
    return VirtusizeRecommendation(size: size, bmi: bmi, message: message);
  }

  double _calculateBmi({required double heightCm, required double weightKg}) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  VirtusizeSize _sizeForBmi(double bmi) {
    if (bmi < 18.5) {
      return VirtusizeSize.small;
    } else if (bmi < 25) {
      return VirtusizeSize.medium;
    } else if (bmi < 30) {
      return VirtusizeSize.large;
    }
    return VirtusizeSize.extraLarge;
  }
}
