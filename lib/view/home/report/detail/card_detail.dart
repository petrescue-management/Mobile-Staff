import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:commons/commons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/repository/repository.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/custom_widget/custom_button.dart';
import 'package:prs_staff/view/custom_widget/video/custom_video_player.dart';

import '../../../../main.dart';

// ignore: must_be_immutable
class Details extends StatefulWidget {
  FinderForm finder;

  Details({this.finder});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  final _repo = Repository();

  DatabaseReference _memberRef;
  DatabaseReference _centerRef;

  List<String> imgUrlList;
  List<Widget> imageSliders;
  int _current = 0;

  String petAttribute;

  getPetAttribute(int petAttribute) {
    if (petAttribute == 1)
      return 'Đi lạc';
    else if (petAttribute == 2)
      return 'Bị bỏ rơi';
    else if (petAttribute == 3)
      return 'Bị thương';
    else
      return 'Cho đi';
  }

  @override
  void initState() {
    super.initState();

    _memberRef = FirebaseDatabase.instance
        .reference()
        .child('authUser')
        .child('${widget.finder.insertedBy}')
        .child('Notification');

    _repo.getUserDetails().then((value) {
      _centerRef = FirebaseDatabase.instance
          .reference()
          .child('manager')
          .child('${value.centerId}')
          .child('Notification');
    });

    setState(() {
      petAttribute = getPetAttribute(widget.finder.petAttribute);

      imgUrlList = widget.finder.finderImageUrl;

      imageSliders = imgUrlList
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgUrlList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 30, left: 30),
            alignment: Alignment.centerLeft,
            child: Text(
              'Hình ảnh mô tả',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgUrlList.map((url) {
              int index = imgUrlList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
          FormBuilder(
            key: _fbKey,
            child: Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _rescueForm(context),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 60,
                    ),
                    child: _btnAcceptFinderForm(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _btnAcceptFinderForm(context) {
    if (widget.finder.finderFormStatus == 1) {
      return CustomButton(
          label: 'NHẬN YÊU CẦU',
          onTap: () {
            confirmationDialog(
              context,
              'Bạn chắn chắn muốn nhận yêu cầu này?',
              title: '',
              confirm: false,
              negativeText: 'Không',
              positiveText: 'Có',
              positiveAction: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ProgressDialog(message: 'Đang gửi...'));

                _repo
                    .updateFinderFormStatus(widget.finder.finderFormId, 2)
                    .then((value) {
                  if (value == null) {
                    warningDialog(context, 'Lỗi hệ thống', title: '');
                  } else {
                    var currentDate = DateTime.now();
                    String currentDay = (currentDate.day < 10
                        ? '0${currentDate.day}'
                        : '${currentDate.day}');
                    String currentMonth = (currentDate.month < 10
                        ? '0${currentDate.month}'
                        : '${currentDate.month}');
                    String currentHour = (currentDate.hour < 10
                        ? '0${currentDate.hour}'
                        : '${currentDate.hour}');
                    String currentMinute = (currentDate.minute < 10
                        ? '0${currentDate.minute}'
                        : '${currentDate.minute}');
                    String currentSecond = (currentDate.second < 10
                        ? '0${currentDate.second}'
                        : '${currentDate.second}');
                    var notiDate =
                        '${currentDate.year}-$currentMonth-$currentDay $currentHour:$currentMinute:$currentSecond';

                    Map<String, dynamic> centerNoti = {
                      'date': notiDate,
                      'isCheck': false,
                      'type': 2,
                    };

                    _centerRef
                        .child(widget.finder.finderFormId)
                        .set(centerNoti);

                    Map<String, dynamic> memberNoti = {
                      'body': 'Yêu cầu cứu hộ của bạn đang được xử lý.',
                      'date': notiDate,
                      'titlte': 'Bạn có thông báo về yêu cầu cứu hộ.',
                      'type': 2,
                    };

                    _memberRef
                        .child(widget.finder.finderFormId)
                        .set(memberNoti);

                    successDialog(
                      context,
                      'Đã nhận yêu cầu.',
                      title: 'Thành công',
                      neutralText: 'Đóng',
                      neutralAction: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                    );
                  }
                });
              },
            );
          });
    } else if (widget.finder.finderFormStatus == 3) {
      return CustomButton(
          label: 'ĐÃ MANG VỀ',
          onTap: () {
            confirmationDialog(
              context,
              'Bạn đảm bảo đã mang thú cưng về đến trạm?',
              title: '',
              confirm: false,
              negativeText: 'Không',
              positiveText: 'Có',
              positiveAction: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ProgressDialog(message: 'Đang gửi...'));

                _repo
                    .updateFinderFormStatus(widget.finder.finderFormId, 4)
                    .then((value) {
                  if (value == null) {
                    warningDialog(context, 'Lỗi hệ thống', title: '');
                  } else {
                    var currentDate = DateTime.now();
                    String currentDay = (currentDate.day < 10
                        ? '0${currentDate.day}'
                        : '${currentDate.day}');
                    String currentMonth = (currentDate.month < 10
                        ? '0${currentDate.month}'
                        : '${currentDate.month}');
                    String currentHour = (currentDate.hour < 10
                        ? '0${currentDate.hour}'
                        : '${currentDate.hour}');
                    String currentMinute = (currentDate.minute < 10
                        ? '0${currentDate.minute}'
                        : '${currentDate.minute}');
                    String currentSecond = (currentDate.second < 10
                        ? '0${currentDate.second}'
                        : '${currentDate.second}');
                    var notiDate =
                        '${currentDate.year}-$currentMonth-$currentDay $currentHour:$currentMinute:$currentSecond';

                    Map<String, dynamic> memberNoti = {
                      'body': 'Yêu cầu cứu hộ của bạn đã hoàn thành.',
                      'date': notiDate,
                      'titlte': 'Bạn có thông báo về yêu cầu cứu hộ.',
                      'type': 2,
                    };

                    _memberRef.child(widget.finder.finderFormId).set(memberNoti);

                    successDialog(
                      context,
                      'Đã hoàn thành yêu cầu.',
                      title: 'Thành công',
                      neutralText: 'Đóng',
                      neutralAction: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                    );
                  }
                });
              },
            );
          });
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _rescueForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* VIDEO
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Video mô tả',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: (widget.finder.finderFormVidUrl == null ||
                        widget.finder.finderFormVidUrl == '')
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Không có video mô tả',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: VideoThumbnailFromUrl(
                          videoUrl: widget.finder.finderFormVidUrl,
                        ),
                      ),
              ),
              SizedBox(height: 15),
              //* FINDER NAME
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Người gửi yêu cầu',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.finderName,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              //* PHONE NUMBER
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.phone,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              //* RADIO
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Tình trạng của thú cưng',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: petAttribute,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.pets,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 15),
              //* DESCRIPTION
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả thêm',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.finderDescription,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
