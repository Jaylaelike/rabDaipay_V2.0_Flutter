import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jayshowloaction/utility/my_style.dart';
import 'package:jayshowloaction/utility/normal_dialog.dart';
import 'package:jayshowloaction/widget/my_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//Field
  String gendle, name, email, password, urlAvartar, uid;
  File file;

//Method

  Widget registerButton() {
    return IconButton(
      icon: Icon(
        Icons.fingerprint,
        size: 35.0,
      ),
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'คุณยังไม่มีรูปภาพ', 'กรุณากดอัพโหลดรูปภาพ');
        } else if (name == null ||
            name.isEmpty ||
            email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(
              context, 'ข้อมูลของคุณยังว่าง', 'กรุณากรอกข้อมูลคุณให้ครบ');
          // } else if (gendle == null) {
          //   normalDialog(context, 'ระบุเพศของคุณ', 'โปรดระบุเพศของคุณ');
          // }
        } else {
          uploadtoFirebase();
        }
      },
    );
  }

//upload firebase storege fuiction
  Future<void> uploadtoFirebase() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String fileName = 'avartar$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    StorageReference reference =
        firebaseStorage.ref().child('Avartar/$fileName');
    StorageUploadTask storageUploadTask = reference.putFile(file);

    urlAvartar =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlAvartat ==> $urlAvartar');
    registerAuth();
  }

//Authen
  Future<void> registerAuth() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser firebaseUser = value.user;
      uid = firebaseUser.uid;
      print('Iid ==> $uid');

      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = urlAvartar;
      firebaseUser.updateProfile(userUpdateInfo);
      insertVlaueToFirestore();
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      normalDialog(context, title, message);
    });
  }

  Future<void> insertVlaueToFirestore() async {
    Map<String, dynamic> map = Map();
    map['Email'] = email;
    map['Gender'] = gendle;
    map['Name'] = name;
    map['Uid'] = uid;
    map['UrlAvartar'] = urlAvartar;

    Firestore firestore = Firestore.instance;
    CollectionReference reference = firestore.collection('UserCollect');

    await reference.document(uid).setData(map).then((value) {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (value) => MyService());
      Navigator.of(context).pushAndRemoveUntil(route, (vlaue) => false);
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      normalDialog(context, title, message);
    });
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 20.0,
      width: 10.0,
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
          mySizeBox(),
          nameForm(),
          mySizeBox(),
          // chooseGender(),  //ios
          emailForm(),
          mySizeBox(),
          passForm(),
        ],
      ),
    );
  }

//ios Gender not show
  // Row chooseGender() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[maleRadio(), femaleRadio()],
  //     );

  // Row maleRadio() => Row(
  //       children: <Widget>[
  //         Radio(
  //           value: 'Male',
  //           groupValue: gendle,
  //           onChanged: (value) {
  //             setState(() {
  //               gendle = value;
  //             });
  //           },
  //         ),
  //         Text('ชาย'),
  //       ],
  //     );

  // Row femaleRadio() => Row(
  //       children: <Widget>[
  //         Radio(
  //           value: 'Female',
  //           groupValue: gendle,
  //           onChanged: (value) {
  //             setState(() {
  //               gendle = value;
  //             });
  //           },
  //         ),
  //         Text('หญิง'),
  //       ],
  //     );

  Widget nameForm() {
    String title = "ชื่อของคุณ: ";
    // String subtitle = "ภาษาอังกฤษเท่านั้น: ";

    IconData iconData = Icons.account_box;
    Color color = Colors.blue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => name = value.trim(),
            decoration: InputDecoration(
              hintText: 'กรุณากรอกชื่อของคุณ',
              hintStyle: TextStyle(color: color),
              // helperText: subtitle,
              // helperStyle: TextStyle(color: color),
              labelText: title,
              labelStyle: TextStyle(color: color),
              border: OutlineInputBorder(),
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
    String title = " Email: ";

    IconData iconData = Icons.email;
    Color color = Colors.green;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => email = value.trim(),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'กรุณากรอก Email ของคุณ',
              helperStyle: TextStyle(color: color),
              labelText: title,
              labelStyle: TextStyle(color: color),
              border: OutlineInputBorder(),
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

  Widget passForm() {
    String title = "Password: ";

    IconData iconData = Icons.lock;
    Color color = Colors.pinkAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => password = value.trim(),
            decoration: InputDecoration(
              hintText: 'กรุณากรอก รหัสผ่าน ของคุณ',
              helperStyle: TextStyle(color: color),
              labelText: title,
              labelStyle: TextStyle(color: color),
              border: OutlineInputBorder(),
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

  Row showButon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton.icon(
          onPressed: () {
            getAvtar(ImageSource.camera);
          },
          icon: Icon(Icons.add_a_photo),
          label: Text('ถ่ายรูป'),
        ),
        RaisedButton.icon(
          onPressed: () => getAvtar(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
          label: Text('ภาพจากเครื่อง'),
        ),
      ],
    );
  }

  Future<void> getAvtar(ImageSource source) async {
    try {
      var result = await ImagePicker.pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = result;
      });
    } catch (e) {}
  }

  Widget showAwatar() {
    return Container(
      margin: EdgeInsets.all(30.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/awatar.png') : Image.file(file),
    );
  }
//class

}
