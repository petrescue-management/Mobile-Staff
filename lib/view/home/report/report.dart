import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

import 'package:prs_staff/bloc/finder_bloc.dart';
import 'package:prs_staff/repository/repository.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/personal/personal.dart';
import 'package:prs_staff/view/home/list/waiting_list.dart';
import 'package:prs_staff/view/home/list/processing_list.dart';
import 'package:prs_staff/view/home/list/delivering_list.dart';

import 'package:prs_staff/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();
  final _repo = Repository();
  Timer timer;
  bool isAllowed;
  bool isOnline;
  var location = Location();

  @override
  void initState() {
    super.initState();

    setState(() {
      isAllowed = false;
      isOnline = false;
    });

    WidgetsBinding.instance.addObserver(this);

    _repo.getUserDetails().then((value) {
      if (value == null) {
        infoDialog(
          context,
          'Phiên đăng nhập của bạn đã hết.',
          title: 'Thông báo',
          neutralText: 'Đóng',
          neutralAction: () {
            _repo.changeVolunteerStatus(0);
            _repo.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        );
      } else if (!value.roles.contains('volunteer')) {
        infoDialog(
          context,
          'Bạn không phải là tình nguyện viên của hệ thống. Hãy đăng nhập lại bằng email được cấp quyền.',
          title: 'Thông báo',
          neutralText: 'Đóng',
          neutralAction: () {
            _repo.changeVolunteerStatus(0);
            _repo.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        );
      }
    });

    checkPermission();

    finderBloc.getWaitingList();
    finderBloc.getProcessingList();
    finderBloc.getDeliveringList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      print('destroy app');
      _repo.changeVolunteerStatus(0).then((value) {
        if (value != null) {
          print('offline');
          setState(() {
            isAllowed = false;
          });
        }
      });
    }
  }

  // locate volunteer's current position
  locatePosition() async {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.best,
    );
    print('position: $position');

    _repo.updateLocation(position.latitude, position.longitude).then((value) {
      if (value != null) {
        print('${position.longitude} - ${position.longitude}');
      } else {
        print('null');
      }
    });
  }

  // check location permission
  checkPermission() async {
    Permission.location.request().then((value) {
      if (!value.isGranted) {
        print('not granted');
        confirmationDialog(context,
            'Hãy cấp quyền truy cập vị trí để nhận được các yêu cầu cứu hộ cần được xử lý từ hệ thống của chúng tôi.',
            title: '',
            confirm: false,
            neutralText: 'Đóng ứng dụng',
            positiveText: 'Đồng ý', positiveAction: () {
          Permission.location.isGranted;
          checkGPS();
          setState(() {
            isAllowed = true;
          });
          print('is allow: $isAllowed');
        }, neutralAction: () {
          setState(() {
            isAllowed = false;
          });
          print('is allow: $isAllowed');
          exit(0);
        });
      } else {
        checkGPS();
        setState(() {
          isAllowed = true;
        });
        print('is allow: $isAllowed');
      }

      if (isAllowed == true) {
        _repo.changeVolunteerStatus(1).then((value) {
          setState(() {
            isOnline = true;
          });
          print('is online: $isOnline');

          if (isOnline == true) {
            timer = Timer.periodic(Duration(seconds: 5), (timer) {
              locatePosition();
            });
          }
        });
      }
    });
  }

  checkGPS() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'THÔNG BÁO CỨU HỘ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return PersonalPage();
                    },
                  ),
                );
              },
            ),
          ],
          bottom: buildTabBar(),
        ),
        body: Stack(
          children: [
            Container(
              color: backgroundColor,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            buildTabBody(context),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 15,
        fontFamily: 'SamsungSans',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Hàng đợi'),
        Tab(text: 'Cứu hộ'),
        Tab(text: 'Đưa về'),
      ],
    );
  }

  Widget buildTabBody(context) {
    return TabBarView(
      children: <Widget>[
        // waiting list
        WaitingList(),
        // processing list
        ProcessingList(),
        // delivering list
        DeliveringList(),
      ],
    );
  }
}
