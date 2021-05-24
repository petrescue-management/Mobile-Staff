import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/repository/repository.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/home/report/detail/card_detail.dart';
import 'package:prs_staff/view/home/report/detail/card_map.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/custom_widget/custom_divider.dart';

import 'package:prs_staff/main.dart';

// ignore: must_be_immutable
class ProcessingCardDetail extends StatefulWidget {
  FinderForm finder;

  ProcessingCardDetail({this.finder});

  @override
  _ProcessingCardDetailState createState() => _ProcessingCardDetailState();
}

class _ProcessingCardDetailState extends State<ProcessingCardDetail> {
  ScrollController scrollController = ScrollController();
  TextEditingController reasonController = TextEditingController();

  final _repo = Repository();

  DatabaseReference _memberRef;

  @override
  void initState() {
    super.initState();

    _memberRef = FirebaseDatabase.instance
        .reference()
        .child('authUser')
        .child('${widget.finder.insertedBy}')
        .child('Notification');
  }

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
          actions: [
            IconButton(
              icon: Icon(
                Icons.cancel,
                size: 35,
              ),
              color: Colors.black,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 6,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "LÍ DO HỦY YÊU CẦU",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: CustomDivider(),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: TextFormField(
                                    controller: reasonController,
                                    maxLines: 5,
                                    autofocus: false,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        counterText: '',
                                        hintText:
                                            'Hãy nhập lí do bạn hủy yêu cầu...'),
                                    maxLength: 1000,
                                  )),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.white,
                                    child: Text(
                                      "HỦY YÊU CẦU",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (reasonController.text == null ||
                                          reasonController.text == '') {
                                        warningDialog(
                                          context,
                                          'Xin hãy nhập lí do bạn hủy yêu cầu.',
                                          title: '',
                                          neutralText: 'Đóng',
                                        );
                                      } else {
                                        confirmationDialog(
                                            context, 'Hủy yêu cầu cứu hộ?',
                                            title: '',
                                            confirm: false,
                                            negativeText: 'Không',
                                            positiveText: 'Có',
                                            positiveAction: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ProgressDialog(
                                                    message:
                                                        'Đang hủy yêu cầu...',
                                                  ));
                                          _repo
                                              .cancelFinderForm(
                                                  widget.finder.finderFormId,
                                                  reasonController.text)
                                              .then((value) {
                                            if (value != null) {
                                              var currentDate = DateTime.now();
                                              String currentDay =
                                                  (currentDate.day < 10
                                                      ? '0${currentDate.day}'
                                                      : '${currentDate.day}');
                                              String currentMonth =
                                                  (currentDate.month < 10
                                                      ? '0${currentDate.month}'
                                                      : '${currentDate.month}');
                                              String currentHour =
                                                  (currentDate.hour < 10
                                                      ? '0${currentDate.hour}'
                                                      : '${currentDate.hour}');
                                              String currentMinute =
                                                  (currentDate.minute < 10
                                                      ? '0${currentDate.minute}'
                                                      : '${currentDate.minute}');
                                              String currentSecond =
                                                  (currentDate.second < 10
                                                      ? '0${currentDate.second}'
                                                      : '${currentDate.second}');
                                              var notiDate =
                                                  '${currentDate.year}-$currentMonth-$currentDay $currentHour:$currentMinute:$currentSecond';

                                              Map<String, dynamic> memberNoti =
                                                  {
                                                'body':
                                                    'Yêu cầu của bạn đã bị hủy bởi tình nguyện viên.',
                                                'date': notiDate,
                                                'titlte':
                                                    'Bạn có thông báo về yêu cầu cứu hộ.',
                                                'type': 2,
                                              };

                                              _memberRef
                                                  .child(widget
                                                      .finder.finderFormId)
                                                  .set(memberNoti);

                                              successDialog(
                                                context,
                                                'Yêu cầu cứu hộ đã bị hủy',
                                                title: 'Đã hủy',
                                                neutralText: 'Đóng',
                                                neutralAction: () {
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyApp()));
                                                },
                                              );
                                            } else {
                                              warningDialog(
                                                context,
                                                'Không thể hủy yêu cầu cứu hộ này.',
                                                title: '',
                                                neutralText: 'Đóng',
                                                neutralAction: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }
                                          });
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Đóng",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            )
          ],
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
        Tab(text: 'Chi tiết'),
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
