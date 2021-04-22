import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:prs_staff/src/style.dart';

import 'package:prs_staff/model/finder_form/finder_form_model.dart';
import 'package:prs_staff/resources/location/assistant.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';

// ignore: must_be_immutable
class FinderLocation extends StatefulWidget {
  FinderForm finder;

  FinderLocation({this.finder});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _FinderLocationState createState() => _FinderLocationState();
}

class _FinderLocationState extends State<FinderLocation> {
  TextEditingController addressTextController = TextEditingController();

  GoogleMapController newGoogleMapController;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Set<Marker> _markers = {};

  Position finderPosition;

  double lat, lng;

  var geoLocator = Geolocator();

  double bottomPaddingMap = 0, topPaddingMap = 0;

  bool _isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._isLoading = true;

      lat = widget.finder.lat;
      lng = widget.finder.lng;
    });

    Future.microtask(() async {
      await Permission.location.status;
      await Permission.location.request();
      await Permission.location.status.isGranted.then((value) {
        setState(() {
          this._isLoading = false;
        });
      });

      locatePosition();
    });
  }

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print('position: $position');

    finderPosition = Position(latitude: lat, longitude: lng);
    print(finderPosition);

    LatLng latLngPosition =
        LatLng(finderPosition.latitude, finderPosition.longitude);

    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 18,
    );

    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    addressTextController.text =
        await Assistant.searchCoordinateAddress(finderPosition, context);
    print('This is your Address: ' + addressTextController.text);

    Marker locateMarker = Marker(
      markerId: MarkerId('locate'),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        snippet: addressTextController.text,
      ),
    );

    setState(() {
      _markers.add(locateMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: _isLoading ? loading(context) : getLocation(context),
      ),
    );
  }

  Widget getLocation(BuildContext context) {
    var contextWidth = MediaQuery.of(context).size.width;
    var contextHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // map
        GoogleMap(
          padding:
              EdgeInsets.only(bottom: bottomPaddingMap, top: topPaddingMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: FinderLocation._kGooglePlex,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            setState(() {
              bottomPaddingMap = contextHeight * 0.0;
            });

            locatePosition();
          },
        ),
        Positioned(
          top: 20.0,
          child: Container(
            width: contextWidth,
            height: contextHeight * 0.14,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: mainColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.5, 0.5),
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: TextField(
                  enabled: false,
                  controller: addressTextController == null
                      ? ''
                      : addressTextController,
                  style: TextStyle(height: 1.3),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.room,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                  ),
                  maxLines: 5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
