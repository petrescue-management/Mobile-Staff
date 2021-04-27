import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:prs_staff/bloc/document_bloc.dart';
import 'package:prs_staff/model/done_form.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/view/custom_widget/custom_button.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/custom_widget/custom_divider.dart';
import 'package:prs_staff/view/home/done/done_card.dart';

class DoneList extends StatefulWidget {
  @override
  _DoneListState createState() => _DoneListState();
}

class _DoneListState extends State<DoneList> {
  ScrollController scrollController = ScrollController();

  DateTimeRange dateRange;

  String getFrom() {
    if (dateRange == null) {
      return 'Ngày bắt đầu';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Ngày kết thúc';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.end);
    }
  }

  @override
  void initState() {
    super.initState();
    documentBloc.getDoneList();
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      initialDateRange: dateRange ?? initialDateRange,
      confirmText: 'Xác nhận',
      cancelText: 'Đóng',
      saveText: 'Xác nhận',
      helpText: 'Chọn ngày',
      errorFormatText: 'dd/MM/yyyy',
      initialEntryMode: DatePickerEntryMode.calendar,
      locale: Locale.fromSubtags(languageCode: 'vi'),
    );

    if (newDateRange == null) {
      return;
    } else {
      setState(() {
        dateRange = newDateRange;
      });

      documentBloc.getDoneList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: getFrom(),
                        onClicked: () => pickDateRange(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ButtonWidget(
                        text: getUntil(),
                        onClicked: () => pickDateRange(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: CustomDivider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 120,
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
                      if (dateRange != null) {
                        snapshot.data.result = snapshot.data.result
                            .where((element) =>
                                DateTime.parse(element.pickerDate)
                                        .compareTo(dateRange.start) >=
                                    0 &&
                                DateTime.parse(element.pickerDate)
                                        .compareTo(dateRange.end) <=
                                    0)
                            .toList();
                      }

                      snapshot.data.result.sort((a, b) =>
                          DateTime.parse(b.pickerDate)
                              .compareTo(DateTime.parse(a.pickerDate)));

                      return Container(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          itemCount: snapshot.data.result.length,
                          itemBuilder: (context, index) {
                            return DoneCard(
                                document: snapshot.data.result[index]);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
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
      ),
    );
  }
}
