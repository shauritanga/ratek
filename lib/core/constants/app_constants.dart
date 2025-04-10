class AppConstants {
  static const String appName = 'Ratek';
  
  // API endpoints
  static const String baseUrl = 'your-api-base-url';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Firebase collections
  static const String usersCollection = 'users';
  static const String farmersCollection = 'farmers';
  static const String groupsCollection = 'groups';
  static const String salesCollection = 'sales';
  
  // Error messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unexpected error occurred';
  
  // Success messages
  static const String saveSuccess = 'Data saved successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
} 