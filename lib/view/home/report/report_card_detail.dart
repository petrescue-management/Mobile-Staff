import 'package:flutter/material.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/view/home/report/detail/card_detail.dart';
import 'package:prs_staff/view/home/report/detail/card_map.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';

// ignore: must_be_immutable
class ProgressCardDetail extends StatefulWidget {
  FinderForm finder;

  ProgressCardDetail({this.finder});

  @override
  _ProgressCardDetailState createState() => _ProgressCardDetailState();
}

class _ProgressCardDetailState extends State<ProgressCardDetail> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'CHI TIẾT CỨU HỘ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: buildTabBar(),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgp8),
                  fit: BoxFit.cover,
                ),
              ),
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
        fontSize: 16,
        fontFamily: 'SamsungSans',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Thông tin chi tiết'),
        Tab(text: 'Bản đồ'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: [
      Details(finder: widget.finder),
      FinderLocation(finder: widget.finder),
    ]);
  }
}
