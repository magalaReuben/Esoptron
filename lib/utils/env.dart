class ENV {
  static const String baseUrl = 'http://admin.esoptronsalon.com/api/';
  static const String registerUser = 'auth/create-account';
  static const String loginUser = 'auth/login';

  static const String getAllCategories = 'categories/all';

  static const String getAllServices = 'sub_categories/all';
  static const String getServiceTypes = 'service_types/all';
  static String getCategoriesUnderServiceType(id) =>
      "service_type/$id/categories";
  static String getSubCategory(id) => "category/$id/sub_categories";

  static String getServices(id) => "sub_category/$id/services";

  static String getOtp = 'auth/reset_password/send_otp';
  static String recoverPassword(phoneNumber) =>
      "auth/verify_otp/$phoneNumber/update_password";

  static String serviceProviders = 'users/service_providers';

  static String serviceProviderDetails(id) =>
      '/users/service_provider/$id/details';

  static String uploadPic = 'user/profileUpload';

  static String getFavorites = 'user/favourites/services';
}
