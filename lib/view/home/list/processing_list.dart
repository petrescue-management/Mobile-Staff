import 'package:flutter/material.dart';
import 'package:commons/commons.dart';

import 'package:prs_staff/bloc/finder_bloc.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/model/finder_form/finder_form_processing.dart';

import 'package:prs_staff/src/asset.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/home/report/report_card.dart';

import 'package:prs_staff/main.dart';

class ProcessingList extends StatefulWidget {
  @override
  _ProcessingListState createState() => _ProcessingListState();
}

class _ProcessingListState extends State<ProcessingList> {
  ScrollController scrollController = ScrollController();
  final _repo = Repository();

  @override
  void initState() {
    super.initState();

    _repo.getUserDetails().then((value) {
      if (value == null) {
        infoDialog(
          context,
          'Phiên đăng nhập của bạn đã hết.',
          title: 'Thông báo',
          neutralText: 'Đăng xuất',
          neutralAction: () {
            _repo.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        );
      }
    });

    finderBloc.getProcessingList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: StreamBuilder(
        stream: finderBloc.processingList,
        builder: (context, AsyncSnapshot<FinderFormProcessingModel> snapshot) {
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
                      'Chưa có yêu cầu nào đang được xử lý',
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
            snapshot.data.result.sort((a, b) => DateTime.parse(b.finderDate)
                .compareTo(DateTime.parse(a.finderDate)));

            return Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: snapshot.data.result.length,
                itemBuilder: (context, index) {
                  return ProgressCard(finder: snapshot.data.result[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
