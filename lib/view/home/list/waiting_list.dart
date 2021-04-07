import 'package:flutter/material.dart';
import 'package:prs_staff/bloc/finder_bloc.dart';
import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_base_model.dart';
import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/home/report/report_card.dart';

class WaitingList extends StatefulWidget {
  @override
  _WaitingListState createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    finderBloc.getWaitingList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: StreamBuilder(
        stream: finderBloc.waitingList,
        builder: (context, AsyncSnapshot<FinderFormBaseModel> snapshot) {
          if (snapshot.hasError) {
            return loading(context);
          } else if (snapshot.data == null || snapshot.data.result == []) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 150),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(empty),
                      height: 150,
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
            return Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.result.length,
                itemBuilder: (context, index) {
                  FinderForm result = snapshot.data.result[index];
                  return ProgressCard(finder: result);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
