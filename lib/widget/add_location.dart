import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jayshowloaction/utility/my_style.dart';
import 'package:jayshowloaction/utility/normal_dialog.dart';
import 'package:jayshowloaction/widget/my_service.dart';
import 'package:location/location.dart';

class AddLocation extends StatefulWidget {
  final double lat;
  final double lng;
  AddLocation({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
//Field
  double lat, lng;
  CameraPosition cameraPosition;
  LatLng latLng;
  File file;
  String name, detail, pathImage, dateString;

//Method
  @override
  void initState() {
    super.initState();
    // findLatLng();

    setState(() {
      lat = widget.lat;
      lng = widget.lng;
    });
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat, lon on add Location ==>>>>> $lat ,$lng');
    });
  }

  Future<LocationData> findLocationData() {
    var location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      print('addLacation ==>>> ${e.toString()}');
      return null;
    }
  }

  Set<Marker> mySetMaker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myId'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'ตำแหน่งของคุณ',
          snippet: 'ละติจูด = $lat, ลองติจูด = $lng',
        ),
      ),
    ].toSet();
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 10.0,
      width: 20.0,
    );
  }

  Widget showMap() {
    if (lat != null) {
      latLng = LatLng(lat, lng);
      cameraPosition = CameraPosition(
        target: latLng,
        zoom: 16.0,
      );
    }
    return Container(
      margin: EdgeInsets.all(24.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: lat == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: cameraPosition,
              mapType: MapType.satellite,
              onMapCreated: (value) {},
              markers: mySetMaker(),
            ),
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                labelText: 'สถานที่: ',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: Colors.redAccent,
                ),
                hintText: 'กรุณากรอกชื่อสถานที่',
              ),
            ),
          ),
        ],
      );

  Widget detailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) => detail = value.trim(),
              decoration: InputDecoration(
                labelText: 'รายละเอียด: ',
                prefixIcon: Icon(
                  Icons.directions_transit,
                  color: Colors.redAccent,
                ),
                hintText: 'กรุณากรอกรายละเอียด',
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().showTitle('รูปภาพของคุณ'),
            showImage(),
            MyStyle().showTitle('ข้อมูลรับได้เพ'),
            nameForm(),
            detailForm(),
            mySizeBox(),
            showDate(),
            mySizeBox(),
            MyStyle().showTitle('พิกัดที่อยู่ของคุณ'),
            showMap(),
          ],
        ),
      ),
    );
  }

  Row showDate() {
    DateTime datetime = DateTime.now();
    dateString = DateFormat('dd-MM-yyyy').format(datetime);

    return Row(
      children: <Widget>[
        MyStyle().showTitle('วันที่บันทึก : '),
        Text(
          dateString,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        )
      ],
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      child: Icon(Icons.cloud_upload),
      backgroundColor: Colors.pinkAccent,
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'ยังไม่ได้ใส่รูป', 'กรุณาแตะกล้องถ่ายรูป');
        } else if (name == null ||
            name.isEmpty ||
            detail == null ||
            detail.isEmpty) {
          normalDialog(context, 'มีช่องว่าง', 'กรุณากรอกข้อมูลให้ครบ');
        } else {
          uploadImage();
        }
      },
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    String nameImage = 'image$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Image/$nameImage');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    pathImage = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('pathImage = $pathImage');

    insertDataToFirestore();
  }

  Future<Null> insertDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    String uid = firebaseUser.uid;

    Map<String, dynamic> map = Map();
    map['DateTime'] = dateString;
    map['Detail'] = detail;
    map['Lat'] = lat;
    map['Lng'] = lng;
    map['Name'] = name;
    map['PathImage'] = pathImage;
    map['Uid'] = uid;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('MakerCollect');
    await collectionReference.document().setData(map).then((value) {
      print('upload success');

      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker.pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget showImage() => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.pink,
                size: 40.0,
              ),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            file == null
                ? Image.asset('images/photos_1.png')
                : Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Image.file(file),
                  ),
            IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.purple,
                  size: 40.0,
                ),
                onPressed: () => chooseImage(ImageSource.gallery)),
          ],
        ),
      );
}
