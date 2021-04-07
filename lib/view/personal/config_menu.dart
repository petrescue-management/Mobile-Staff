import 'package:flutter/material.dart';
import 'package:prs_staff/src/style.dart';

class ConfigMenu extends StatelessWidget {
  const ConfigMenu({
    @required this.text,
    this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: color2,
            width: 2,
          ),
        ),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            // menu icon
            Icon(
              icon,
              color: color1,
            ),
            SizedBox(width: 10),
            // menu title
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
