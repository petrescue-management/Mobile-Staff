import 'package:flutter/material.dart';

import 'package:prs_staff/model/center_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/repository/repository.dart';

import 'package:prs_staff/src/asset.dart';

import 'package:prs_staff/view/home/report/center/center_item.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';

// ignore: must_be_immutable
class NearestCenterList extends StatefulWidget {
  FinderForm finder;

  NearestCenterList({this.finder});

  @override
  _NearestCenterListState createState() => _NearestCenterListState();
}

class _NearestCenterListState extends State<NearestCenterList> {
  final _repo = Repository();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chọn trung tâm cứu hộ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
          ),
          Center(
            child: Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<CenterList>(
                  future: _repo.getCenterList(widget.finder.finderFormId),
                  builder: (context, AsyncSnapshot<CenterList> snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return loading(context);
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.result.length,
                        itemBuilder: (context, index) {
                          return CenterItem(
                            finder: widget.finder,
                            center: snapshot.data.result[index],
                          );
                        },
                      );
                    }
                  },
                )),
          )
        ],
      ),
    );
  }
}
