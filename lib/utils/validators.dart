class Validators {
  static String? Function(String?) required(String fieldName) => (value) {
        if (value == null || value.trim().isEmpty) {
          return '$fieldName is required.';
        }
        return null;
      };

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }
    const pattern = r'^\+?[0-9]{10,15}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid phone number.';
    }
    return null;
  }
  static String? requiredEnum(dynamic value, String fieldName) {
  if (value == null) return '$fieldName is required.';
  return null;
}

}