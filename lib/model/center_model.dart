class CenterModel {
  String centerId;
  String centerAddrees;
  String centerName;
  String centerImgUrl;
  String phone;
  double distance;

  CenterModel(center) {
    this.centerId = center['centerId'];
    this.centerAddrees = center['centerAddrees'];
    this.centerName = center['centerName'];
    this.centerImgUrl = getImgUrl(center['centerImgUrl']);
    this.phone = center['phone'];
    this.distance = center['distance'];
  }

  getImgUrl(String imgUrl) {
    String result = '';

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });
    tmp.removeLast();
    result = tmp.first;

    return result;
  }
}

class CenterList {
  List<CenterModel> result;

  CenterList.fromJson(List<dynamic> json) {
    List<CenterModel> tmpList = [];
    for (var i = 0; i < json.length; i++) {
      CenterModel tmp = CenterModel(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
