import 'dart:async';
import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'package:prs_staff/src/api_url.dart';
import 'package:prs_staff/model/finder_form/finder_form_base_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_processing.dart';

class FinderFormProvider {
  Future<FinderFormBaseModel> getWaitingFinderForms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getWaitingFinderForm,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result = FinderFormBaseModel.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }

  Future<FinderFormProcessingModel> getProcessingFinderForms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getProcessingFinderForm,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result =
          FinderFormProcessingModel.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }

  Future<FinderFormProcessingModel> getDeliveringFinderForms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getDeliveringFinderForm,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result =
          FinderFormProcessingModel.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }

  Future<FinderFormProcessingModel> getDoneFinderForms() async {
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
      var result =
          FinderFormProcessingModel.fromJson(json.decode(response.body));
      return result;
    }
    return null;
  }

  Future<bool> updateFinderFormStatus(String finderFormId, int status) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['id'] = finderFormId;
    resBody['status'] = status;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.updateFinderFormStatus,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to load post ${response.statusCode}');
    }
    return null;
  }

  Future<bool> createPickerForm(String pickerDescription, String pickerImageUrl) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['pickerDescription'] = pickerDescription;
    resBody['pickerImageUrl'] = pickerImageUrl;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.createPickerForm,
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
}
