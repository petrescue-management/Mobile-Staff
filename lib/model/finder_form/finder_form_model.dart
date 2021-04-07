class FinderForm {
  String finderFormId;
  String finderDescription;
  double lat;
  double lng;
  List<String> finderFormImgUrl;
  int petAttribute;
  String phone;
  String insertedAt;
  int finderFormStatus;

  FinderForm(form) {
    this.finderFormId = form['finderFormId'];
    this.finderDescription = form['finderDescription'];
    this.lat = form['lat'];
    this.lng = form['lng'];
    this.finderFormImgUrl = getImgUrlList(form['finderFormImgUrl']);
    this.petAttribute = form['petAttribute'];
    this.phone = form['phone'];
    this.insertedAt = form['insertedAt'].toString();
    this.finderFormStatus = form['finderFormStatus'];
  }

  List getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });
    result = tmp;

    return result;
  }

  getFinderFormStatus(int status) {
    if (status == 1) {
      return 'Đang chờ';
    } else if (status == 2) {
      return 'Đang được xử lý';
    } else if (status == 3) {
      return 'Đã Hủy';
    } else {
      return 'Hoàn thành';
    }
  }
}
