import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:commons/commons.dart';
import 'dart:async';

import 'account_provider.dart';

class FirebaseSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

//use the Google sign-in data to authenticate a FirebaseUser
//return that user
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    //google
    // ignore: unused_local_variable
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    // String tokenGoogle;
    // await user.getIdToken().then((value) => tokenGoogle = value.token);

    //firebase
    final FirebaseUser currentUser = await _auth.currentUser();
    String tokenFirebase;
    await currentUser.getIdToken().then((value) => tokenFirebase = value.token);

    final FirebaseMessaging _fbMessaging = FirebaseMessaging();
    String deviceToken;
    await _fbMessaging.getToken().then((token) => deviceToken = token);

    if (currentUser != null) {
      print('Firebase:' + tokenFirebase);
      print('signInWithGoogle succeeded: $currentUser');
      print('Device Token:' + deviceToken);

      var jwt = AccountProvider().getJWT(tokenFirebase, deviceToken);

      return jwt;
    }
    return null;
  }

//sign out of the current Google account
  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    sharedPreferences.remove('userId');
    sharedPreferences.remove('avatar');
    sharedPreferences.remove('fullname');

    print("User Signed Out");
  }

  // trước là tên thư mục, sau là tên file
  Future<String> uploadAvatar(File image, String uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference storageReference = storage.ref().child('volunteer/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
