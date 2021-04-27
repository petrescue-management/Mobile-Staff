import 'package:flutter/material.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/home/list/waiting_list.dart';
import 'package:prs_staff/view/home/list/processing_list.dart';
import 'package:prs_staff/view/home/list/delivering_list.dart';
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
        fontSize: 15,
        fontFamily: 'Philosopher',
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

  Widget buildTabBody() {
    return TabBarView(children: <Widget>[
      WaitingList(),
      ProcessingList(),
      DeliveringList(),
    ]);
  }
}
