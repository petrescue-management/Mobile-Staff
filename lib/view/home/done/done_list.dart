import 'package:flutter/material.dart';

import 'package:prs_staff/bloc/document_bloc.dart';
import 'package:prs_staff/model/done_form.dart';

import 'package:prs_staff/src/asset.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/home/done/done_card.dart';

class DoneList extends StatefulWidget {
  @override
  _DoneListState createState() => _DoneListState();
}

class _DoneListState extends State<DoneList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    documentBloc.getDoneList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
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
          padding: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 10),
          child: StreamBuilder(
            stream: documentBloc.doneList,
            builder: (context, AsyncSnapshot<DoneBaseModel> snapshot) {
              if (snapshot.hasError || snapshot.data == null) {
                return loading(context);
              } else if (snapshot.data.result.length == 0) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 200),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage(empty),
                          height: 100,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Chưa có yêu cầu nào hoàn thành',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                List<DoneModel> resultList = snapshot.data.result;

                resultList.sort((a, b) => DateTime.parse(b.finderDate)
                    .compareTo(DateTime.parse(a.finderDate)));

                return Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemCount: resultList.length,
                    itemBuilder: (context, index) {
                      DoneModel result = resultList[index];
                      return DoneCard(document: result);
                    },
                  ),
                );
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.chevron_left,
              size: 35.0,
            ),
          ),
        ),
      ]),
    );
  }
}