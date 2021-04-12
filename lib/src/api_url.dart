class ApiUrl {
  static String getJWT =
      'https://petrescueapi.azurewebsites.net/jwt/login-by-volunteer';
  static String getUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users';
  static String updateUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users/update-profile';
  static String getWaitingFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form';
  static String updateFinderFormStatus =
      'https://petrescueapi.azurewebsites.net/api/update-finder-form-status';
  static String getProcessingFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-status?status=2';
  static String getDeliveringFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-status?status=3';
  static String createPickerForm =
      'https://petrescueapi.azurewebsites.net/api/create-picker-form';
  static String getDoneFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-status?status=4';
}
