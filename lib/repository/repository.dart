// Repository <----- the central point from where the data will flow to the BLOC

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_base_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_processing.dart';
import 'package:prs_staff/resources/report/finder_form_provider.dart';
import 'package:prs_staff/resources/account/account_provider.dart';
import 'package:prs_staff/resources/account/sign_in_fb.dart';
import 'package:prs_staff/resources/report/picker_form_provider.dart';

class Repository {
  final accountProvider = AccountProvider();
  final firebaseProvider = FirebaseSignIn();
  final finderFormProvider = FinderFormProvider();
  final pickerFormProvider = PickerFormProvider();

  // user
  Future<String> signIn() => firebaseProvider.signInWithGoogle();

  Future<FirebaseUser> getCurrentUser() => firebaseProvider.getCurrentUser();

  Future<void> signOut() => firebaseProvider.signOutGoogle();

  Future<String> getJWT(String firebaseToken, String deviceToken) =>
      accountProvider.getJWT(firebaseToken, deviceToken);

  Future<UserModel> getUserDetails() => accountProvider.getUserDetail();

  Future<bool> updateUserDetails(UserModel user) =>
      accountProvider.updateUserDetail(user);

  Future<String> uploadAvatar(File image, String uid) =>
      firebaseProvider.uploadAvatar(image, uid);

  // finder form
  Future<FinderFormBaseModel> getWaitingFinderForms() =>
      finderFormProvider.getWaitingFinderForms();

  Future<FinderFormProcessingModel> getProcessingFinderForms() =>
      finderFormProvider.getProcessingFinderForms();

  Future<FinderFormProcessingModel> getDeliveringFinderForms() =>
      finderFormProvider.getDeliveringFinderForms();

  Future<FinderFormProcessingModel> getDoneFinderForms() =>
      finderFormProvider.getDoneFinderForms();

  Future<bool> updateFinderFormStatus(String finderFormId, int status) =>
      finderFormProvider.updateFinderFormStatus(finderFormId, status);

  // picker form
  Future<bool> createPickerForm(
          String pickerDescription, String pickerImageUrl) =>
      pickerFormProvider.createPickerForm(pickerDescription, pickerImageUrl);

  Future<String> uploadPickerImage(File image, String uid) =>
      pickerFormProvider.uploadPickerImage(image, uid);

  Future<File> getImageFileFromAssets(Asset asset) =>
      pickerFormProvider.getImageFileFromAssets(asset);
}
