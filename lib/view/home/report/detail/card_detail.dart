import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';

import 'package:prs_staff/src/asset.dart';
import 'package:prs_staff/src/data.dart';
import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/repository/repository.dart';

// ignore: must_be_immutable
class Details extends StatefulWidget {
  FinderForm finder;

  Details({this.finder});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  ScrollController scrollController = ScrollController();

  final _repo = Repository();

  List<String> imgUrlList;
  List<Widget> imageSliders;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      imgUrlList = widget.finder.finderFormImgUrl;

      imageSliders = imgUrlList
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgUrlList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgUrlList.map((url) {
              int index = imgUrlList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
