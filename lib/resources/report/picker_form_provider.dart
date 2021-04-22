import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:commons/commons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prs_staff/model/picker_form_model.dart';
import 'package:prs_staff/src/api_url.dart';

class PickerFormProvider {
  Future<PickerFormModel> createPickerForm(
      String pickerDescription, String pickerImageUrl) async {
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
      return PickerFormModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post ${response.statusCode}');
    }
    return null;
  }

  // trước là tên thư mục, sau là tên file
  Future<String> uploadPickerImage(File image, String uid) async {
    String result;
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference storageReference =
        storage.ref().child('pickerFormImg/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    result = url;
    return result;
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File('${(await getTemporaryDirectory()).path}/${asset.name}');
    final file = await tempFile.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));

    return file;
  }
}
