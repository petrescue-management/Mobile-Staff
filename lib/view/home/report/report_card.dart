import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/resources/location/assistant.dart';

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
  List<String> imgUrlList;
  String firstUrl;

  double latitude, longitude;
  Position finderPosition;
  String finderAddress = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      imgUrlList = widget.finder.finderFormImgUrl;
      firstUrl = imgUrlList.elementAt(0);

      latitude = widget.finder.lat;
      longitude = widget.finder.lng;
    });

    locateUserAddressPosition();
  }

  locateUserAddressPosition() async {
    String address = '';

    finderPosition = Position(latitude: latitude, longitude: longitude);

    address = await Assistant.searchCoordinateAddress(finderPosition, context);

    print('This is user Address: ' + address);

    setState(() {
      finderAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProgressCardDetail(
                finder: widget.finder,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.14,
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
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
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
                            finderAddress,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.finder.finderFormStatus == 1
                                ? 'Đang chờ xử lý'
                                : '',
                            style: TextStyle(
                              fontSize: 13,
                              color: fadedBlack,
                              fontStyle: FontStyle.italic,
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
                  color: color1,
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
