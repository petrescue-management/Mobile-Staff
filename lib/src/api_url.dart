class ApiUrl {
  static String getJWT =
      'https://petrescueapi.azurewebsites.net/jwt/login-by-volunteer';
  static String getUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users';
  static String updateUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users/update-profile';
  static String getWaitingFinderForm =
      'https://petrescueapi.azurewebsites.net/api/search-finder-form?Status=1';
  static String getProcessingFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-status?status=2';
  static String getDoneFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-status?status=4';
}
