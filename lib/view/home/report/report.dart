import 'package:flutter/material.dart';
import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/view/home/list/waiting_list.dart';
import 'package:prs_staff/view/home/list/processing_list.dart';
import 'package:prs_staff/view/home/list/done_list.dart';
import 'package:prs_staff/view/personal/personal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();

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
                Icons.settings,
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgxp),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            buildTabBody(),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Philosopher',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: color2,
      tabs: <Widget>[
        Tab(
          text: 'Chờ xử lý',
        ),
        Tab(
          text: 'Đang xử lý',
        ),
        Tab(
          text: 'Đã xử lý',
        ),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: <Widget>[
      WaitingList(),
      ProcessingList(),
      DoneList(),
    ]);
  }
}
