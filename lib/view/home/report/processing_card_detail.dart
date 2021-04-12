import 'package:flutter/material.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/home/report/detail/card_detail.dart';
import 'package:prs_staff/view/home/report/detail/card_map.dart';
import 'package:prs_staff/view/home/report/detail/picker_form.dart';

// ignore: must_be_immutable
class ProcessingCardDetail extends StatefulWidget {
  FinderForm finder;

  ProcessingCardDetail({this.finder});

  @override
  _ProcessingCardDetailState createState() => _ProcessingCardDetailState();
}

class _ProcessingCardDetailState extends State<ProcessingCardDetail> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
        fontFamily: 'Philosopher',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Bản đồ'),
        Tab(text: 'Chi tiết'),
        Tab(text: 'Cập nhật'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: [
      FinderLocation(finder: widget.finder),
      Details(finder: widget.finder),
      PickerForm(finder: widget.finder),
    ]);
  }
}
