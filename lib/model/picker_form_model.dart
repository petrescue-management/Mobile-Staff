class PickerFormModel {
  String pickerFormId;
  String pickerDescription;
  String pickerImageUrl;

  PickerFormModel({
    this.pickerFormId,
    this.pickerDescription,
    this.pickerImageUrl,
  });

  factory PickerFormModel.fromJson(Map<String,dynamic> json) {
    return PickerFormModel(
      pickerFormId: json['pickerFormId'],
      pickerDescription: json['pickerDescription'],
      pickerImageUrl: json['pickerImageUrl'],
    );
  }
}
