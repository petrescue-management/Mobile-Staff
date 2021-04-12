class FinderForm {
  String finderFormId;
  String finderDescription;
  List<String> finderImageUrl;
  String finderName;
  String finderDate;
  int petAttribute;
  int finderFormStatus;
  String phone;
  double lat;
  double lng;

  FinderForm(form) {
    this.finderFormId = form['finderFormId'];
    this.finderDescription = form['finderDescription'];
    this.finderImageUrl = getImgUrlList(form['finderImageUrl']);
    this.finderName = form['finderName'];
    this.finderDate = form['finderDate'];
    this.petAttribute = form['petAttribute'];
    this.finderFormStatus = form['finderFormStatus'];
    this.phone = form['phone'];
    this.lat = form['lat'];
    this.lng = form['lng'];
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

  getFinderFormStatus(int status) {
    if (status == 1) {
      return 'Đang chờ xử lý';
    } else if (status == 2) {
      return 'Đang cứu hộ';
    } else if (status == 3) {
      return 'Đã đến nơi';
    } else if (status == 4) {
      return 'Cứu hộ thành công';
    } else {
      return 'Bị hủy';
    }
  }
}
