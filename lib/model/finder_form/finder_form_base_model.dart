import 'package:prs_staff/model/finder_form/finder_form_model.dart';

class FinderFormBaseModel {
  List<FinderForm> result;

  // FinderFormBaseModel(baseModel) {
  //   List<FinderForm> tempList = [];
  //   for (var i = 0; i < baseModel['result'].length; i++) {
  //     FinderForm tmp = FinderForm(baseModel['result'][i]);
  //     tempList.add(tmp);
  //   }
  //   result = tempList;
  // }

  // FinderFormBaseModel({
  //   this.result,
  // });

  FinderFormBaseModel.fromJson(Map<String, dynamic> json) {
    List<FinderForm> tmpList = [];
    for (var i = 0; i < json['result'].length; i++) {
      FinderForm tmp = FinderForm(json['result'][i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
