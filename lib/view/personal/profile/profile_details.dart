import 'dart:io';

import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prs_staff/bloc/account_bloc.dart';
import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/view/custom_widget/custom_button.dart';
import 'package:prs_staff/view/custom_widget/custom_field.dart';
import 'package:prs_staff/view/custom_widget/custom_divider.dart';

import '../../../main.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatefulWidget {
  UserModel user;

  ProfileDetails({this.user});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ScrollController scrollController = ScrollController();

  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final _repo = Repository();
  
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      lastNameController.text = widget.user.lastName;
      firstNameController.text = widget.user.firstName;
      emailController.text = widget.user.email;
      phoneController.text = widget.user.phone;
      dobController.text = widget.user.dob;
    });
  }

  File _image;

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: () {
          return confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
              positiveText: "Có",
              neutralText: "Không",
              confirm: false,
              title: "", positiveAction: () {
            Navigator.of(context).pop();
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              'Chỉnh sửa thông tin',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 35,
              ),
              color: Colors.black,
              onPressed: () {
                confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
                    positiveText: "Có",
                    neutralText: "Không",
                    confirm: false,
                    title: "", positiveAction: () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bgsh),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    profilePic(context, widget.user),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        right: 40,
                        left: 40,
                      ),
                      child: CustomDivider(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: profileInfo(context),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                  label: 'LƯU CHỈNH SỬA',
                                  onTap: () {
                                    UserModel tmpUser = new UserModel();
                                    tmpUser.id = widget.user.id;
                                    tmpUser.lastName = lastNameController.text;
                                    tmpUser.firstName =
                                        firstNameController.text;
                                    tmpUser.email = emailController.text;
                                    tmpUser.phone = phoneController.text;
                                    tmpUser.gender = widget.user.gender;
                                    tmpUser.dob = widget.user.dob;
                                    tmpUser.imgUrl = widget.user.imgUrl;

                                    confirmationDialog(context,
                                        'Bạn muốn lưu thông tin chỉnh sửa?',
                                        title: '',
                                        confirm: false,
                                        negativeText: 'Không',
                                        positiveText: 'Có', positiveAction: () {
                                      accountBloc.updateUserDetail(tmpUser);
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // loading
  Widget loading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget profilePic(BuildContext context, UserModel user) {
    var height = MediaQuery.of(context).size.height * 0.16;
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color2, width: 2),
              image: DecorationImage(
                image: _image == null
                    ? NetworkImage(user.imgUrl)
                    : FileImage(_image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  convertStringtoDateTime(String date) {
    DateTime tmp = DateFormat('yyyy-MM-dd').parse(date);
    var result = DateFormat.yMMMMd('vi_VN').format(tmp);
    return result;
  }

  String getUserGender(int index) {
    if (index == 1)
      return 'Nữ';
    else if (index == 2)
      return 'Nam';
    else
      return 'Khác';
  }

  Widget profileInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
            //* EMAIL
            CustomTextFormField(
              textEditingController: emailController,
              labelText: 'Email',
              icon: Icon(
                Icons.mail,
                color: color2,
              ),
              maxLenth: 50,
              enable: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* LASTNAME
            CustomTextFormField(
              textEditingController: lastNameController,
              labelText: 'Họ',
              icon: Icon(
                Icons.edit_outlined,
                color: color2,
              ),
              maxLenth: 10,
            ),
            SizedBox(
              height: 20,
            ),
            //* FIRSTNAME
            CustomTextFormField(
              textEditingController: firstNameController,
              labelText: 'Tên',
              icon: Icon(
                Icons.edit_outlined,
                color: color2,
              ),
              maxLenth: 10,
            ),
            SizedBox(
              height: 20,
            ),
            //* PHONE
            CustomTextFormField(
              textEditingController: phoneController,
              labelText: 'Số điện thoại',
              icon: Icon(
                Icons.phone_iphone,
                color: color2,
              ),
              maxLenth: 10,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}