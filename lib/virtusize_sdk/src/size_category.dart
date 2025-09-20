enum VirtusizeSize { small, medium, large, extraLarge }

extension VirtusizeSizeLabel on VirtusizeSize {
  String get label {
    switch (this) {
      case VirtusizeSize.small:
        return 'S';
      case VirtusizeSize.medium:
        return 'M';
      case VirtusizeSize.large:
        return 'L';
      case VirtusizeSize.extraLarge:
        return 'XL';
    }
  }

  String get description {
    switch (this) {
      case VirtusizeSize.small:
        return 'BMI under 18.5';
      case VirtusizeSize.medium:
        return 'BMI between 18.5 and 24.9';
      case VirtusizeSize.large:
        return 'BMI between 25 and 29.9';
      case VirtusizeSize.extraLarge:
        return 'BMI 30 or above';
    }
  }
}
