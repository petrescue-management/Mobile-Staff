import 'package:prs_staff/model/finder_form/finder_form_model.dart';

class FinderFormBaseModel {
  List<FinderForm> result;

  FinderFormBaseModel.fromJson(List<dynamic> json) {
    List<FinderForm> tmpList = [];
    for (var i = 0; i < json.length; i++) {
      FinderForm tmp = FinderForm(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
