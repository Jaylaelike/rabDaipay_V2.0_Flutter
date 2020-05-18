import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jayshowloaction/models/marker_collect_model.dart';
import 'package:jayshowloaction/models/user_model.dart';
import 'package:jayshowloaction/utility/my_style.dart';

class DetailMaker extends StatefulWidget {
  final MakerCollectModel model;
  //final String nameDocument;  ///EditForm
  DetailMaker({Key key, this.model}) : super(key: key);
  // DetailMaker({Key key, this.model,this.nameDocument}) : super(key: key); ///EditForm

  @override
  _DetailMakerState createState() => _DetailMakerState();
}

class _DetailMakerState extends State<DetailMaker> {
  MakerCollectModel model;
  UserModel userModel;
  String editName, nameDocument;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    // nameDocument = widget.nameDocument; ///EditForm
    print('name ==>> $nameDocument');
    findUser();

    // findAvatar();
  }

  Future<Null> findUser() async {
    print('uid ===>> ${model.uid}');
    Firestore firestore = Firestore.instance;
    CollectionReference reference = firestore.collection('UserCollect');
    await reference.document(model.uid).snapshots().listen((event) {
      var map = event.data;
      setState(() {
        userModel = UserModel.fromJson(map);
        print('NameUser ==>>>>> ${userModel.name}');
        print('URLAvartar ==>>>>> ${userModel.urlAvatar}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('RabdaiPay App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showName(),
            showImage(),
            showDetail(),
            showDate(),
            showLocation(context),
            showRecordname(),
            showAvartar(),
          ],
        ),
      ),
    );
  }

  Widget showRecordname() => MyStyle().showTitle('เพิ่มข้อมูลโดย คุณ:  ' + userModel.name);

  Text showRecord() => Text(userModel == null ? 'Name Record' : userModel.name);

  Container showLocation(BuildContext context) {
    LatLng latLng = LatLng(model.lat, model.lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.satellite,
        onMapCreated: (controller) {},
        markers: mySetMarker(),
      ),
    );
  }

  Set<Marker> mySetMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('idMark'),
          position: LatLng(model.lat, model.lng),
          infoWindow: InfoWindow(
            title: model.detail,
            snippet: model.name,
          )),
    ].toSet();
  }

  Widget showDate() => MyStyle().showTitle('วันที่เพิ่มข้อมูล:  ' + model.dateTime);

  Widget showDetail() => SingleChildScrollView(
      child: Column(
      children: <Widget>[
        MyStyle().showTitle('รายละเอียด:  ' + model.detail),
      ],
    ),
  );

  Widget showImage() => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Image.network(model.pathImage),
      );

  Widget showAvartar() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: CircleAvatar(
            radius: 70.0,
            backgroundImage: NetworkImage(userModel.urlAvatar),
            backgroundColor: Colors.grey,
          ),
        ),
      );
  // Future<Null> confirmEditName() async {              ///EditForm
  //   showDialog(
  //     context: context,
  //     builder: (context) => SimpleDialog(
  //       title: TextFormField(
  //         onChanged: (value) => editName = value.trim(),
  //         initialValue: model.name,
  //       ),
  //       children: <Widget>[
  //         RaisedButton(
  //           onPressed: () {
  //             print('editName ===>> $editName');

  //             Firestore firestore = Firestore.instance;
  //             CollectionReference reference = firestore.collection('MakerCollect');

  //           // // CollectionReference reference = Firestore.
  //           //   // Navigator.pop(context);
  //           },
  //           child: Text('OK'),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget showName() {
    return Center(
      child: ListTile(
        title: MyStyle().showTitle('ชื่อสถานที่:  ' + model.name),
        // trailing: IconButton(                ///EditForm
        //   icon: Icon(Icons.edit),
        //   onPressed: () => confirmEditName(),
        // ),
      ),
    );
  }
}
