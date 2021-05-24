import 'dart:async';
import 'dart:convert';

import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;

import 'package:prs_staff/model/center_model.dart';
import 'package:prs_staff/src/api_url.dart';

class CenterProvider {
  Future<CenterList> getCenterList(String finderFormId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getCenters + '?finderFormId=$finderFormId',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result = CenterList.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }
}
