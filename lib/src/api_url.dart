class ApiUrl {
  static String apiUrl = 'https://petrescuecapston.azurewebsites.net';

  // user
  static String getJWT = '$apiUrl/jwt/login-by-volunteer';
  static String getUserDetail = '$apiUrl/api/users';
  static String updateUserDetail = '$apiUrl/api/users/update-profile';
  static String updateVolunteerStatus =
      '$apiUrl/api/users/change-status-for-volunteer';
  static String updateLocation = '$apiUrl/api/users/update-location';

  // form
  static String getSystemParameters =
      '$apiUrl/api/config/get-system-parameters';
  static String getWaitingFinderForm =
      '$apiUrl/api/finder-forms/get-list-finder-form';
  static String updateFinderFormStatus =
      '$apiUrl/api/finder-forms/update-finder-form-status';
  static String cancelFinderForm =
      '$apiUrl/api/finder-forms/cancel-finder-form';
  static String getProcessingFinderForm =
      '$apiUrl/api/finder-forms/get-list-finder-form-by-status?status=2';
  static String getDeliveringFinderForm =
      '$apiUrl/api/finder-forms/get-list-finder-form-by-status?status=3';
  static String createPickerForm =
      '$apiUrl/api/picker-forms/create-picker-form';
  static String createPetDocument =
      '$apiUrl/api/rescue-documents/create-pet-document';
  static String getDoneFinderForm =
      '$apiUrl/api/finder-forms/get-list-finder-form-finish-by-userid';

  // center/
  static String getCenters = '$apiUrl/api/centers/get-list-distance-centers';
}
