class DoneModel {
  String finderFormId;
  String pickerFormId;
  String finderDescription;
  List<String> finderImageUrl;
  String finderName;
  String finderDate;
  String petAttribute;
  String pickerFormDescription;
  List<String> pickerFormImg;
  String pickerName;
  String pickerDate;

  DoneModel(form) {
    this.finderFormId = form['finderFormId'];
    this.pickerFormId = form['PickerFormId'];
    this.finderDescription = form['finderDescription'];
    this.finderImageUrl = getImgUrlList(form['finderImageUrl']);
    this.finderName = form['finderName'];
    this.finderDate = form['finderDate'];
    this.petAttribute = getPetAttribute(form['petAttribute']);
    this.pickerFormDescription = form['pickerFormDescription'];
    this.pickerFormImg = getImgUrlList(form['pickerFormImg']);
    this.pickerName = form['pickerName'];
    this.pickerDate = form['pickerDate'];
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

  getPetAttribute(int petAttribute) {
    if (petAttribute == 1)
      return 'Đi lạc';
    else if (petAttribute == 2)
      return 'Bị bỏ rơi';
    else if (petAttribute == 3)
      return 'Bị thương';
    else
      return 'Cho đi';
  }
}

class DoneBaseModel {
  List<DoneModel> result;

  DoneBaseModel.fromJson(List<dynamic> json) {
    List<DoneModel> tmpList = [];
    for (var i = 0; i < json.length; i++) {
      DoneModel tmp = DoneModel(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
