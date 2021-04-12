import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/src/data.dart';
import 'package:prs_staff/view/custom_widget/custom_button.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';

import '../../main.dart';

class LoginRequest extends StatefulWidget {
  const LoginRequest({Key key}) : super(key: key);

  @override
  _LoginRequestState createState() => _LoginRequestState();
}

class _LoginRequestState extends State<LoginRequest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.57,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Chào mừng bạn đến với\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontFamily: 'Philosopher'),
                          ),
                          TextSpan(
                            text: 'RESCUE ME',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 36,
                              fontFamily: 'Salsa',
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: mainColor, width: 3),
                        image: DecorationImage(
                          image: AssetImage(app_logo_notitle),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          _signInButton(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 45),
                            child: SizedBox(
                              child: loginNotice(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _repo = Repository();

  bool hasRole = false;

  // sign in button
  Widget _signInButton() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: CustomRaiseButtonIcon(
        labelText: ' Đăng nhập với Google',
        assetName: google_logo,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  ProgressDialog(message: 'Đang kiểm tra tài khoản...'));

          _repo.signIn().then(
            (value) {
              if (value == null) {
                warningDialog(
                  context,
                  'Tài khoản của bạn chưa được cấp quyền để đăng nhập.',
                  neutralAction: () {
                    _repo.signOut();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                );
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              }
            },
          );
        },
      ),
    );
  }
}
