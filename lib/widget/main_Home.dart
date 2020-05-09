import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshowloaction/utility/my_style.dart';
import 'package:jayshowloaction/utility/normal_dialog.dart';
import 'package:jayshowloaction/widget/my_service.dart';
import 'package:jayshowloaction/widget/register.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
//Field

  String user, password;

// Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

// check login again
  Future<void> checkStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
      routeToMap();
    }
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo2.png'),
    );
  }

  Container userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
          hintText: 'กรุณากรอก User ของคุณ',
          border: OutlineInputBorder(),
          labelText: 'User :  ',
        ),
      ),
    );
  }

  Container passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        obscureText: true,
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          hintText: 'กรุณากรอก Password ของคุณ',
          border: OutlineInputBorder(),
          labelText: 'Password :  ',
        ),
      ),
    );
  }

  Text showAppName() => Text(
        'รับได้เพ',
        style: GoogleFonts.kanit(
            textStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: MyStyle().darkColor,
        )),
      );

  // Text showAppName1() {
  //   print('hello');
  //   return Text('Geolocation');
  // }
  Widget mySizeBox() {
    return SizedBox(
      height: 20.0,
      width: 10.0,
    );
  }

  Widget showBotton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInBotton(),
        mySizeBox(),
        signUpBotton(),
      ],
    );
  }

  OutlineButton signUpBotton() {
    return OutlineButton(
      borderSide: BorderSide(
        color: MyStyle().darkColor,
      ),
      onPressed: () {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Register());
        Navigator.of(context).push(route);
      },
      child: Row(
        children: <Widget>[
          Text(
            'สมัครสมาชิก',
            style: TextStyle(
              color: MyStyle().darkColor,
              
            ),
          ),
          Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ],
      ),
    );
  }

  RaisedButton signInBotton() {
    return RaisedButton(
      color: MyStyle().darkColor,
      onPressed: () {
        print('User = $user, password = $password');
        if (user == null ||
            user.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Blank');
        } else {
          checkAuthen();
        }
      },
      child: Row(
        children: <Widget>[
          Text(
            'เข้าใช้งาน',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
           Icon(
            Icons.assignment_ind,
            color: MyStyle().primaryColor,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ],
      ),
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((response) {
      print('Succsees Authen');

      routeToMap();
    }).catchError((err) {
      print('response catchError ==> ${err.toString()}');
      String title = err.code;
      String message = err.message;
      normalDialog(context, title, message);
    });
  }

  void routeToMap() {
    MaterialPageRoute route =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService();
    });
    Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 0.8,
            colors: <Color>[
              Colors.white,
              MyStyle().primaryColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                showAppName(),
                mySizeBox(),
                userForm(),
                mySizeBox(),
                passwordForm(),
                mySizeBox(),
                showBotton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
