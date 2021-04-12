class PickerFormModel {
  String pickerDescription;
  List<String> pickerImageUrl;

  PickerFormModel({
    this.pickerDescription,
    this.pickerImageUrl,
  });

  factory PickerFormModel.fromJson(Map<String,dynamic> json) {
    return PickerFormModel(
      pickerDescription: json['pickerDescription'],
      pickerImageUrl: json['pickerImageUrl'],
    );
  }

  List getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });

    tmp.removeLast();

    result = tmp;

    return result;
  }
}
