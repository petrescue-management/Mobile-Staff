import 'package:flutter/material.dart';

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
  List<String> imgUrlList;
  String firstUrl;

  String finderDate;
  String pickerDate;
  String status;

  @override
  void initState() {
    super.initState();
    setState(() {
      imgUrlList = widget.document.finderImageUrl;
      firstUrl = imgUrlList.elementAt(0);

      finderDate = formatDateTime(widget.document.finderDate);
      pickerDate = formatDateTime(widget.document.pickerDate);
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
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
        height: MediaQuery.of(context).size.height * 0.15,
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
                        image: NetworkImage(firstUrl),
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
                                  'Ngày yêu cầu: $finderDate',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                Text(
                                  'Ngày cứu hộ: $pickerDate',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
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
