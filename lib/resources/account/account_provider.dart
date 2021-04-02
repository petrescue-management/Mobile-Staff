import 'dart:async';
import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/src/api_url.dart';

class AccountProvider {
  Future<String> getJWT(String fbToken, String deviceToken) async {
    var resBody = {};
    resBody['token'] = fbToken;
    resBody['deviceToken'] = deviceToken;
    resBody['applicationName'] = 'Petrescue.app.volunteer';

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.getJWT,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: str,
    );

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove('token');
      sharedPreferences.setString('token', json.decode(response.body));
      print('JWT Token: ' + sharedPreferences.getString('token').toString());
      return response.body;
    } else {
      print(response.statusCode);
      throw Exception('Can not get jwt');
    }
  }

  Future<UserModel> getUserDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    final response = await http.get(
      ApiUrl.getUserDetail,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
    );

    if (response.statusCode == 200) {
      var result = UserModel.fromJson(json.decode(response.body));

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove('avatar');
      sharedPreferences.setString('avatar', result.imgUrl);
      sharedPreferences.remove('userId');
      sharedPreferences.setString('userId', result.id);
      sharedPreferences.remove('fullname');
      sharedPreferences.setString(
          'fullname', '${result.lastName} ${result.firstName}');

      return result;
    }
    return null;
  }

  Future<bool> updateUserDetail(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['userId'] = user.id;
    resBody['lastName'] = user.lastName;
    resBody['firstName'] = user.firstName;
    resBody['dob'] = user.dob;
    resBody['phone'] = user.phone;
    resBody['gender'] = user.gender;
    resBody['dob'] = user.dob;
    resBody['imgUrl'] = user.imgUrl;

    String str = json.encode(resBody);
    print(str);

    final response = await http.post(
      ApiUrl.updateUserDetail,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return null;
  }
}
