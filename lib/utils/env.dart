class ENV {
  static const String baseUrl = 'http://admin.esoptronsalon.com/api/';
  static const String registerUser = 'auth/create-account';
  static const String loginUser = 'auth/login';

  static const String getAllCategories = 'categories/all';

  static const String getAllServices = 'services/all';

  static String getOtp = 'auth/reset_password/send_otp';
  static String recoverPassword(phoneNumber) =>
      "auth/verify_otp/$phoneNumber/update_password";

  static String uploadPic = 'user/profileUpload';
}
