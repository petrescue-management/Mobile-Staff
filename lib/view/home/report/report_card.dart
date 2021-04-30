import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/resources/location/assistant.dart';

import 'package:prs_staff/view/home/report/processing_card_detail.dart';
import 'package:prs_staff/view/home/report/delivering_card_detail.dart';
import 'package:prs_staff/view/home/report/report_card_detail.dart';

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
  Position finderPosition;
  String finderAddress = '';

  @override
  void initState() {
    super.initState();
    locateUserAddressPosition();
  }

  locateUserAddressPosition() async {
    String address = '';

    finderPosition =
        Position(latitude: widget.finder.lat, longitude: widget.finder.lng);

    address = await Assistant.searchCoordinateAddress(finderPosition, context);

    print('This is user Address: ' + address);

    setState(() {
      finderAddress = address;
    });
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
        if (widget.finder.finderFormStatus == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ProgressCardDetail(
                  finder: widget.finder,
                );
              },
            ),
          );
        } else if (widget.finder.finderFormStatus == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ProcessingCardDetail(
                  finder: widget.finder,
                );
              },
            ),
          );
        } else if (widget.finder.finderFormStatus == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return DeliveringCardDetail(
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
                            finderAddress,
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
