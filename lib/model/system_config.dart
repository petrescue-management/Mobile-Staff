class ConfigModel {
  int imageForPicker;

  ConfigModel({this.imageForPicker});

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      imageForPicker: json['imageForPicker'],
    );
  }
}
