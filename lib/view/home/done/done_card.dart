import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:prs_staff/model/done_form.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/view/home/done/done_card_detail.dart';

// ignore: must_be_immutable
class DoneCard extends StatefulWidget {
  DoneModel document;

  DoneCard({
    this.document,
  });

  @override
  _DoneCard createState() => _DoneCard();
}

class _DoneCard extends State<DoneCard> {
  @override
  void initState() {
    super.initState();
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String day = (tmp.day < 10 ? '0${tmp.day}' : '${tmp.day}');
    String month = (tmp.month < 10 ? '0${tmp.month}' : '${tmp.month}');
    String hour = (tmp.hour < 10 ? '0${tmp.hour}' : '${tmp.hour}');
    String minute = (tmp.minute < 10 ? '0${tmp.minute}' : '${tmp.minute}');
    String result = '$day/$month/${tmp.year} - $hour:$minute';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DoneCardDetail(
                document: widget.document,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.13,
        child: Stack(
          children: [
            Container(
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
                        image: CachedNetworkImageProvider(widget.document.finderImageUrl.elementAt(0)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // location & status
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.document.finderName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
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
                                  'Ngày yêu cầu: ${formatDateTime(widget.document.finderDate)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                Text(
                                  'Ngày cứu hộ: ${formatDateTime(widget.document.pickerDate)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: mainColor,
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
