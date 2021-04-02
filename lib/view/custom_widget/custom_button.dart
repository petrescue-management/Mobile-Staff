import 'package:flutter/material.dart';
import 'package:prs_staff/src/style.dart';


// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  var onTap;
  String label;

  CustomButton({this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomRaiseButtonIcon extends StatelessWidget {
  String assetName;
  String labelText;
  VoidCallback onPressed;

  CustomRaiseButtonIcon({
    this.assetName,
    this.labelText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color2,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        onPressed: onPressed,
        icon: Image(image: AssetImage(assetName), height: 30.0),
        label: Text(
          labelText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        splashColor: Colors.red[100],
        color: Colors.white,
      ),
    );
  }
}
