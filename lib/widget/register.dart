import 'package:flutter/material.dart';
import 'package:jayshowloaction/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//Field
  String gendle;

//Method

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().primaryColor,
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 50.0),
        children: <Widget>[
          showAwatar(),
          showButon(),
          nameForm(),
          chooseGender(),
          emailForm(),
          passForm(),
        ],
      ),
    );
  }

  Row chooseGender() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[maleRadio(), femaleRadio()],
      );

  Row maleRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Male',
            groupValue: gendle,
            onChanged: (value) {},
          ),
          Text('Male'),
        ],
      );

  Row femaleRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Female',
            groupValue: gendle,
            onChanged: (value) {},
          ),
          Text('Female'),
        ],
      );

  Widget nameForm() {
    String title = "Display Name: ";

    String subtitle = "Type Your Name in Blank: ";
    IconData iconData = Icons.account_box;
    Color color = Colors.green;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            decoration: InputDecoration(
              helperText: subtitle,
              helperStyle: TextStyle(color: color),
              labelText: title,
              labelStyle: TextStyle(color: color),
              icon: Icon(
                iconData,
                size: 36.0,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget emailForm() {
    String title = "Display Email: ";

    String subtitle = "Type Your Email in Blank: ";
    IconData iconData = Icons.email;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              helperText: subtitle,
              labelText: title,
              icon: Icon(
                iconData,
                size: 36.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passForm() {
    String title = "Display Password: ";

    String subtitle = "Type Your password in Blank: ";
    IconData iconData = Icons.lock;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            decoration: InputDecoration(
              helperText: subtitle,
              labelText: title,
              icon: Icon(
                iconData,
                size: 36.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row showButon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add_a_photo),
          label: Text('Camera'),
        ),
        RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Gallery'),
        ),
      ],
    );
  }

  Widget showAwatar() => Container(
        margin: EdgeInsets.all(30.0),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Image.asset('images/awatar.png'),
      );

//class

}
