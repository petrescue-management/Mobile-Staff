import 'dart:async';
import 'dart:convert';

import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;

import 'package:prs_staff/model/done_form.dart';
import 'package:prs_staff/src/api_url.dart';

class DocumentProvider {
  Future<bool> createPetDocument(String pickerId, String finderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['pickerFormId'] = pickerId;
    resBody['finderFormId'] = finderId;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.createPetDocument,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    print(str);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to load post ${response.statusCode}');
    }
    return null;
  }

  Future<DoneBaseModel> getDoneFinderForms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getDoneFinderForm,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result = DoneBaseModel.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }
}
