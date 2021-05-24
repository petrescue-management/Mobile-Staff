class FinderForm {
  String finderFormId;
  String description;
  List<String> finderImageUrl;
  String insertedBy;
  String finderName;
  String finderDate;
  int petAttribute;
  int finderFormStatus;
  String phone;
  double lat;
  double lng;
  String finderFormVidUrl;

  FinderForm(form) {
    this.finderFormId = form['finderFormId'];
    this.description = form['description'];
    this.finderImageUrl = getImgUrlList(form['finderImageUrl']);
    this.finderName = form['finderName'];
    this.finderDate = form['finderDate'];
    this.petAttribute = form['petAttribute'];
    this.finderFormStatus = form['finderFormStatus'];
    this.phone = form['phone'];
    this.lat = form['lat'];
    this.lng = form['lng'];
    this.insertedBy = form['insertedBy'];
    this.finderFormVidUrl = form['finderFormVidUrl'];
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
