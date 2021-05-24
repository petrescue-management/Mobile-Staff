import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:commons/commons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/model/center_model.dart';
import 'package:prs_staff/repository/repository.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/view/custom_widget/custom_button.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';

import '../../../../main.dart';

// ignore: must_be_immutable
class PickerForm extends StatefulWidget {
  FinderForm finder;
  CenterModel center;

  PickerForm({this.finder, this.center});

  @override
  _PickerFormState createState() => _PickerFormState();
}

class _PickerFormState extends State<PickerForm> {
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  List<Asset> _images = List<Asset>();
  int limitImg;
  bool hasImage = false;

  final _repo = Repository();

  DatabaseReference _memberRef;
  DatabaseReference _centerRef;

  @override
  void initState() {
    _repo.getNumberOfImage().then((value) {
      if (value != null) {
        print('not null: ${value.imageForPicker}');
        setState(() {
          limitImg = value.imageForPicker;
        });
      } else {
        setState(() {
          limitImg = 3;
        });
      }
    });

    super.initState();

    _memberRef = FirebaseDatabase.instance
        .reference()
        .child('authUser')
        .child('${widget.finder.insertedBy}')
        .child('Notification');

    _centerRef = FirebaseDatabase.instance
        .reference()
        .child('manager')
        .child('${widget.center.centerId}')
        .child('Notification');
  }

  Widget buildViewPickedImages() {
    if (_images.length == 0)
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 1,
        children: List.generate(3, (index) {
          return Card(
            child: IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          );
        }),
      );
    else
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: List.generate(_images.length, (index) {
          Asset asset = _images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        _images.remove(asset);

                        if (_images.length == 0) {
                          hasImage = false;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );
  }

  pickImages() async {
    List<Object> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: limitImg,
        enableCamera: true,
        selectedAssets: _images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Chọn hình ảnh ",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      _images = resultList;
    });

    if (_images.length > 0) {
      setState(() {
        hasImage = true;
      });
    }
  }

  _btnSubmitInformation(bool hasImage, BuildContext context) {
    if (hasImage == true) {
      return CustomButton(
        label: 'GỬI THÔNG BÁO',
        onTap: () {
          if (_fbKey.currentState.saveAndValidate()) {
            final formInputs = _fbKey.currentState.value;
            print(formInputs);

            showDialog(
                context: context,
                builder: (context) =>
                    ProgressDialog(message: 'Đang cập nhật...'));

            String url = '';
            int count = 0;
            _images.forEach((item) {
              Asset asset = item;

              _repo.getImageFileFromAssets(asset).then((result) {
                String baseName = basename(result.path);

                _repo.uploadPickerImage(result, baseName).then((value) {
                  setState(() {
                    url += '$value;';
                    count++;
                  });

                  if (count == _images.length) {
                    _repo
                        .createPickerForm(formInputs['description'], url)
                        .then((value) {
                      if (value == null) {
                        warningDialog(
                          context,
                          'Không thể tạo bản cập nhật yêu cầu cứu hộ.',
                          title: '',
                          neutralText: 'Đóng',
                          neutralAction: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        _repo
                            .createPetDocument(
                                value.pickerFormId, widget.finder.finderFormId)
                            .then((value) {
                          if (value == null) {
                            warningDialog(
                              context,
                              'Không thể cập nhật yêu cầu.',
                              title: '',
                              neutralText: 'Đóng',
                              neutralAction: () {
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            _repo
                                .updateFinderFormStatus(
                                    widget.finder.finderFormId, 3)
                                .then((value) {
                              if (value == null) {
                                warningDialog(
                                  context,
                                  'Không thể cập nhật trạng thái yêu cầu.',
                                  title: '',
                                  neutralText: 'Đóng',
                                  neutralAction: () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                successDialog(
                                  context,
                                  'Đã cập nhật thông tin.',
                                  title: 'Thành công',
                                  neutralText: 'Đóng',
                                  neutralAction: () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyApp(),
                                      ),
                                    );
                                  },
                                );

                                var currentDate = DateTime.now();
                                String currentDay = (currentDate.day < 10
                                    ? '0${currentDate.day}'
                                    : '${currentDate.day}');
                                String currentMonth = (currentDate.month < 10
                                    ? '0${currentDate.month}'
                                    : '${currentDate.month}');
                                String currentHour = (currentDate.hour < 10
                                    ? '0${currentDate.hour}'
                                    : '${currentDate.hour}');
                                String currentMinute = (currentDate.minute < 10
                                    ? '0${currentDate.minute}'
                                    : '${currentDate.minute}');
                                String currentSecond = (currentDate.second < 10
                                    ? '0${currentDate.second}'
                                    : '${currentDate.second}');
                                var notiDate =
                                    '${currentDate.year}-$currentMonth-$currentDay $currentHour:$currentMinute:$currentSecond';

                                Map<String, dynamic> centerNoti = {
                                  'date': notiDate,
                                  'isCheck': false,
                                  'type': 2,
                                };

                                _centerRef
                                    .child(widget.finder.finderFormId)
                                    .set(centerNoti);

                                Map<String, dynamic> memberNoti = {
                                  'body':
                                      'Tình nguyện viên đã đến vị trí cứu hộ.',
                                  'date': notiDate,
                                  'titlte':
                                      'Bạn có thông báo về yêu cầu cứu hộ.',
                                  'type': 2,
                                };

                                _memberRef
                                    .child(widget.finder.finderFormId)
                                    .set(memberNoti);
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                });
              });
            });
          } else {
            warningDialog(
              context,
              'Bạn chưa điền đầy đủ thông tin.\nXin hãy kiểm tra lại.',
              title: '',
            );
          }
        },
      );
    } else {
      return CustomDisableButton(
        label: 'GỬI THÔNG BÁO',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var contextHeight = MediaQuery.of(context).size.height;
    var contextWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'CẬP NHẬT BÁO CÁO',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgp8),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Container(
              height: contextHeight,
              width: contextWidth,
              child: Column(
                children: [
                  FormBuilder(
                    key: _fbKey,
                    child: Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _pickerForm(context),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _btnSubmitInformation(hasImage, context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* IMAGE PICKER
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ' Ảnh mô tả*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          color: Colors.blue[400],
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                          child: Text("Chọn ảnh"),
                          onPressed: pickImages,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    buildViewPickedImages(),
                  ],
                ),
              ),
              SizedBox(height: 30),
              //* DESCRIPTION
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: FormBuilderTextField(
                  attribute: 'description',
                  decoration: InputDecoration(
                    labelText: 'Mô tả tình trạng của bé*',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    hintText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryGreen,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy thêm mô tả về tình trạng của bé.'),
                  ],
                  maxLines: 6,
                  maxLength: 1000,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
