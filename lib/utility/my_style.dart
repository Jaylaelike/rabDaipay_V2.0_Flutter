import 'package:flutter/material.dart';

class MyStyle {
  // Field
  Color darkColor = Color.fromARGB(0xff, 0xc7, 0x91, 0x00);
  Color primaryColor = Color.fromARGB(0xff, 0xff, 0xc1, 0x07);

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showTitle(String string) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(
            string,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0xc7, 0x91, 0x00),
            ),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        ),
      ],
    );
  }
  // Method

  MyStyle();
}
