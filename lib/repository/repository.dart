// Repository <----- the central point from where the data will flow to the BLOC

import 'package:firebase_auth/firebase_auth.dart';
import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/resources/account/account_provider.dart';
import 'package:prs_staff/resources/account/sign_in_fb.dart';

class Repository {
  final accountProvider = AccountProvider();
  final signInProvider = FirebaseSignIn();

  Future<String> signIn() => signInProvider.signInWithGoogle();

  Future<FirebaseUser> getCurrentUser() => signInProvider.getCurrentUser();

  Future<void> signOut() => signInProvider.signOutGoogle();

  Future<String> getJWT(String firebaseToken, String deviceToken) =>
      accountProvider.getJWT(firebaseToken, deviceToken);

  Future<UserModel> getUserDetails() => accountProvider.getUserDetail();

  Future<bool> updateUserDetails(UserModel user) => accountProvider.updateUserDetail(user);
}
