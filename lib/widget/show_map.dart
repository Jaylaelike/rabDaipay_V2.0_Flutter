import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jayshowloaction/models/marker_collect_model.dart';
import 'package:jayshowloaction/widget/add_location.dart';
import 'package:jayshowloaction/widget/detail_marker.dart';
import 'package:jayshowloaction/widget/my_service.dart';
import 'package:location/location.dart';

class ShowMap extends StatefulWidget {
  final double lat;
  final double lng;
  ShowMap({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
//  Field

  double lat, lng;
  BitmapDescriptor policeIcon;
  List<Marker> list = List();
  //  List<String> listDocuments = List();  ///EditForm

//Method

  @override
  void initState() {
    super.initState();
    //findLatLng();

    readDataFormFirebase();

    setState(() {
      lat = widget.lat;
      lng = widget.lng;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(128, 128)), 'images/point2.png')
        .then((value) {
      policeIcon = value;
    });
  }

  Future<Null> readDataFormFirebase() async {
    print('#############ReadDateFormFirebase Worked.##############');

    // list = [
    //   locationMarker(),
    //   jjMaker(),
    //   policeMarker(),
    // ];

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('MakerCollect');
    await collectionReference.snapshots().listen((event) {
      List<DocumentSnapshot> snapshots = event.documents;
      for (var map in snapshots) {
        MakerCollectModel model = MakerCollectModel.fromMap((map.data));
        print('Name ==>>> ${model.name}');
         String nameDocument = map.documentID;
          // listDocuments.add(nameDocument);  ///EditForm
        Marker marker = createMarker(model, nameDocument);
        setState(() {
          list.add(marker);
          print('myMarkers set lenght ==>>> ${myMarkers().length}');
        });
      }
    });
  }

  Marker createMarker(MakerCollectModel markerCollectModel, String nameDocument) {
    Marker marker;
    Random random = Random();
    int i = random.nextInt(100);
    String idString = 'id$i';

    marker = Marker(
      markerId: MarkerId(idString),
      position: LatLng(markerCollectModel.lat, markerCollectModel.lng),
      infoWindow: InfoWindow(
        title: markerCollectModel.name,
        snippet: markerCollectModel.detail,
      ),
      onTap: () {
        print('You Tap Name ==>> ${markerCollectModel.name}');

        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => DetailMaker(
            model: markerCollectModel, 
            // model: markerCollectModel, nameDocument: nameDocument,  ///EditForm
          ),
        );
        Navigator.push(context, route);
      },
    );
    return marker;
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat =>>> $lat, lng ===>> $lng');
    });
  }

  Future<LocationData> findLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('e location = ${e.toString()}');
      return null;
    }
  }

  Set<Marker> myMarkers() {
    list.add(locationMarker());
    list.add(jjMaker());
    list.add(policeMarker());

    return list.toSet();
  }

  Marker locationMarker() {
    return Marker(
      markerId: MarkerId('myLocation'),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: 'คุณอยุ่ตรงนี้? ',
        snippet: 'lat = $lat, lng = $lng',
      ),
    );
  }

  Marker policeMarker() {
    return Marker(
      icon: policeIcon,
      markerId: MarkerId('home2'),
      position: LatLng(10.5022093, 99.1736313),
      infoWindow: InfoWindow(
        title: 'สถานีตำรวจ',
        snippet: 'สถานีตำรวจ',
      ),
    );
  }

  Marker jjMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home3'),
      position: LatLng(10.496799, 99.181479),
      infoWindow: InfoWindow(
        title: 'ร้านค้า',
        snippet: 'ร้านค้า รับได้เพ',
      ),
    );
  }

  Widget showMap() {
    // lat = 10.501047;
    // lng = 99.173455;
    print('latlng on showmap ==>>> $lat, $lng');
    LatLng centerLatLng = LatLng(lat, lng);
    CameraPosition cameraPosition =
        CameraPosition(target: centerLatLng, zoom: 16.0);

//showmap button plus
    return Stack(
      children: <Widget>[
        GoogleMap(
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          markers: myMarkers(),
          onMapCreated: (value) {},
        ),
        addButton(),
        // refreshButton(),
      ],
    );
  }

//add Button
  Widget addButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: FloatingActionButton(
                backgroundColor: Colors.pinkAccent,
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (value) => MyService(
                            currentWidget: AddLocation(),
                          ));
                  Navigator.of(context)
                      .pushAndRemoveUntil(route, (value) => false);
                },
                child: Icon(
                  Icons.near_me,
                  size: 36.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

//Current location refresh
  // Widget refreshButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Container(
  //             margin: EdgeInsets.only(bottom: 40.0, left: 40.0),
  //             child: FloatingActionButton(
  //               backgroundColor: Colors.orange,
  //               onPressed: () {
  //                 MaterialPageRoute route = MaterialPageRoute(
  //                     builder: (value) => MyService(
  //                           currentWidget: AddLocation(),
  //                         ));
  //                 Navigator.of(context)
  //                     .pushAndRemoveUntil(route, (value) => false);
  //               },
  //               child: Icon(
  //                 Icons.near_me,
  //                 size: 36.0,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: lat == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : showMap());
  }
}
