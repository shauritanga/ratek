class ValidationService {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    
    if (!hasUpperCase || !hasLowerCase || !hasDigits) {
      return 'Password must contain uppercase, lowercase, and numbers';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    final nameRegex = RegExp(r'^[a-zA-Z\s-]+$');
    
    if (!nameRegex.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^(http|https):\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < 0 || age > 150) {
      return 'Please enter a valid age between 0 and 150';
    }
    
    return null;
  }

  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    
    final postalRegex = RegExp(r'^\d{5}(-\d{4})?$');
    
    if (!postalRegex.hasMatch(value)) {
      return 'Please enter a valid postal code';
    }
    
    return null;
  }

  static String? validateCreditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Credit card number is required';
    }
    
    // Remove spaces and dashes
    value = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!RegExp(r'^\d{16}$').hasMatch(value)) {
      return 'Please enter a valid credit card number';
    }
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = value.length - 1; i >= 0; i--) {
      int n = int.parse(value[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Please enter a valid credit card number';
    }
    
    return null;
  }

  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    
    return null;
  }
} 