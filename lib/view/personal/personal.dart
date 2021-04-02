import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:prs_staff/bloc/account_bloc.dart';
import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/view/personal/config_menu.dart';
import 'package:prs_staff/main.dart';
import 'package:prs_staff/view/personal/profile/profile_details.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/src/asset.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _repo = Repository();

  ScrollController scrollController = ScrollController();

  String avatar, fullname;

  @override
  void initState() {
    super.initState();
    accountBloc.getDetail();
    SharedPreferences.getInstance().then((value) => {
          setState(() {
            avatar = value.getString('avatar');
            print(avatar);
            fullname = value.getString('fullname');
            print(fullname);
          })
        });
  }

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
        resizeToAvoidBottomInset: false,
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
              child: StreamBuilder(
                stream: accountBloc.userDetail,
                builder: (context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                      child: Column(
                        children: [
                          profilePic(snapshot.data),
                          configMenu(snapshot.data),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.chevron_left,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePic(UserModel user) {
    var height = MediaQuery.of(context).size.height * 0.28;

    if (avatar != user.imgUrl ||
        fullname != '${user.lastName} ${user.firstName}') {
      return Container(
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color3, color2, color1],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: NetworkImage(user.imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '${user.lastName} ${user.firstName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget configMenu(UserModel user) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ConfigMenu(
              text: 'Chỉnh sửa thông tin',
              icon: Icons.account_circle,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileDetails(
                        user: user,
                      );
                    },
                  ),
                );
              },
            ),
            ConfigMenu(
              text: 'Điều khoản của chúng tôi',
              icon: Icons.pets,
              press: () {},
            ),
            ConfigMenu(
              text: 'Đăng xuất',
              icon: Icons.logout,
              press: () {
                confirmationDialog(context, "Bạn chắc chắn muốn đăng xuất ?",
                    positiveText: "Có",
                    neutralText: "Không",
                    confirm: false,
                    title: "", positiveAction: () {
                  _repo.signOut().then((_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
