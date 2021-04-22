import 'package:flutter/material.dart';

import 'package:prs_staff/model/done_form.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/home/done/detail/picker_detail.dart';
import 'detail/finder_detail.dart';

// ignore: must_be_immutable
class DoneCardDetail extends StatefulWidget {
  DoneModel document;

  DoneCardDetail({this.document});

  @override
  _DoneCardDetailState createState() => _DoneCardDetailState();
}

class _DoneCardDetailState extends State<DoneCardDetail> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'THÔNG TIN CỨU HỘ',
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
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Từ người yêu cầu'),
        Tab(text: 'Từ tình nguyện viên'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: [
      FinderDetail(document: widget.document),
      PickerDetail(document: widget.document),
    ]);
  }
}
