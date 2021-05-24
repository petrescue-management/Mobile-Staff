import 'package:flutter/material.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/model/center_model.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/home/report/detail/picker_form.dart';

// ignore: must_be_immutable
class CenterItem extends StatelessWidget {
  CenterModel center;
  FinderForm finder;

  CenterItem({this.center, this.finder});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: GestureDetector(
        onTap: () {
          showCenterDetail(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: mainColor,
              width: 2,
            ),
            color: Colors.white,
          ),
          margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: AspectRatio(
            aspectRatio: 3 / 1,
            child: Container(
              child: Row(
                children: [
                  // image
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          center.centerImgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center.centerName.trim(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${center.distance} km',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showCenterDetail(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 480,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // center logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        center.centerImgUrl,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // center name
                    Text(
                      center.centerName.trim(),
                      style: TextStyle(
                          fontSize: 20,
                          color: darkBlue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // center address
                    Text(
                      center.centerAddrees.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // contact
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[800],
                            fontFamily: 'SamsungSans'),
                        children: [
                          TextSpan(
                              text: 'Thông tin liên lạc:\n',
                              style: TextStyle(
                                  decoration: TextDecoration.underline)),
                          TextSpan(
                            text: 'Số điện thoại: ${center.phone} \n',
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PickerForm(
                              finder: finder,
                              center: center,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'VỀ TRUNG TÂM NÀY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
