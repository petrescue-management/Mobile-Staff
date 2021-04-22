import 'package:flutter/material.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/data.dart';

// ignore: must_be_immutable
class PolicyPage extends StatelessWidget {
  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'THỎA THUẬN CẤP PHÉP',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(warning),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: SizedBox(
            child: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                child: appPolicy,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
