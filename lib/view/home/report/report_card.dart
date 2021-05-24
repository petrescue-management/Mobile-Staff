import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/home/report/detail/card_detail.dart';
import 'package:prs_staff/view/home/report/processing_card_detail.dart';

import '../../../main.dart';

// ignore: must_be_immutable
class ProgressCard extends StatefulWidget {
  FinderForm finder;

  ProgressCard({
    this.finder,
  });

  @override
  _ProgressCard createState() => _ProgressCard();
}

class _ProgressCard extends State<ProgressCard> {
  DatabaseReference _memberRef;
  final _repo = Repository();

  @override
  void initState() {
    super.initState();

    _memberRef = FirebaseDatabase.instance
        .reference()
        .child('authUser')
        .child('${widget.finder.insertedBy}')
        .child('Notification');
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
    return result;
  }

  getFinderFormStatus(int status) {
    String result = '';

    if (status == 1) {
      result = 'Đang chờ xử lý';
    } else if (status == 2) {
      result = 'Đang cứu hộ';
    } else if (status == 3) {
      result = 'Đã đến nơi';
    } else if (status == 4) {
      result = 'Cứu hộ thành công';
    } else {
      result = 'Bị hủy';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.finder.finderFormId);
        // waiting request
        if (widget.finder.finderFormStatus == 1) {
          confirmationDialog(
            context,
            'Nhận xử lý yêu cầu này?',
            title: '',
            confirm: false,
            neutralText: 'Không',
            positiveText: 'Có',
            positiveAction: () {
              showDialog(
                  context: context,
                  builder: (context) => ProgressDialog(message: 'Đang gửi...'));

              _repo
                  .updateFinderFormStatus(widget.finder.finderFormId, 2)
                  .then((value) {
                if (value == null) {
                  warningDialog(context, 'Lỗi hệ thống',
                      neutralText: 'Đóng', title: '', neutralAction: () {
                    Navigator.pop(context);
                  });
                } else if (value == false) {
                  warningDialog(
                      context, 'Đã có tình nguyện viên nhận yêu cầu này.',
                      neutralText: 'Đóng', title: '', neutralAction: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  });
                } else {
                  successDialog(
                    context,
                    'Đã nhận yêu cầu.',
                    title: 'Thành công',
                    neutralText: 'Quay lại trang chủ',
                    neutralAction: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                      );
                    },
                  );

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
                    'body': 'Tình nguyện viên đã nhận yêu cầu của bạn.',
                    'date': notiDate,
                    'titlte': 'Bạn có thông báo về yêu cầu cứu hộ.',
                    'type': 2,
                  };

                  _memberRef.child(widget.finder.finderFormId).set(memberNoti);
                }
              });
            },
          );
        }
        // processing request
        else if (widget.finder.finderFormStatus == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ProcessingCardDetail(
                  finder: widget.finder,
                );
              },
            ),
          );
        }
        // delivering request
        else if (widget.finder.finderFormStatus == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Details(
                  finder: widget.finder,
                );
              },
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.15,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: mainColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  // image
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.finder.finderImageUrl.elementAt(0)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // finderName & status
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.finder.finderName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày yêu cầu: ${formatDateTime(widget.finder.finderDate)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                Text(
                                  getFinderFormStatus(widget
                                                  .finder.finderFormStatus) ==
                                              null ||
                                          getFinderFormStatus(widget
                                                  .finder.finderFormStatus) ==
                                              ''
                                      ? ''
                                      : getFinderFormStatus(
                                          widget.finder.finderFormStatus),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: primaryGreen,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
