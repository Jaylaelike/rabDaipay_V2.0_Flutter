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
            ImageConfiguration(size: Size(128.0, 128.0)), 'images/point2.png')
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

  Marker createMarker(
      MakerCollectModel markerCollectModel, String nameDocument) {
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
    list.add(bkkMaker());
    list.add((chpMarker()));
    list.add(rngMaker());
    list.add(kbrMaker());
    list.add(tskMaker());
    list.add(pkkMaker());
    list.add(huaMaker());
    list.add(pbrMaker());
    list.add(pnpMaker());
    list.add(tsaMaker());
    list.add(lhsMaker());
    list.add(swiMaker());
    list.add(phtMaker());
    list.add(kpoMaker());
    list.add(krbMaker());
    list.add(srtMaker());
    list.add(skaMaker());
    list.add(thsgMaker());
    list.add(phkMaker());
    list.add(trngMaker());
    list.add(nraMaker());
    list.add(ylaMaker());
    list.add(stnMaker());
    list.add(phngaMaker());
    list.add(ubnMaker());
    list.add(kknMaker());
    list.add(srnMaker());
    list.add(nkrsmMaker());
    list.add(nkswMaker());
    list.add(skawMaker());
    list.add(rayngMaker());
    list.add(trdMaker());
    list.add(bknMaker());
    list.add(sknMaker());
    list.add(mukdaMaker());
    list.add(roiMaker());
    list.add(sskMaker());
    list.add(yasoMaker());
    list.add(udnMaker());
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

  Marker chpMarker() {
    return Marker(
      icon: policeIcon,
      markerId: MarkerId('home2'),
      position: LatLng(10.53081, 99.19148),
      infoWindow: InfoWindow(
        title: 'สถานีชุมพร',
        snippet: 'สถานีชุมพร',
      ),
    );
  }

  Marker rngMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home3'),
      position: LatLng(10.028664, 98.669486),
      infoWindow: InfoWindow(
        title: 'สถานีระนอง',
        snippet: 'สถานีระนอง',
      ),
    );
  }

  Marker kbrMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home4'),
      position: LatLng(10.4819, 98.8944),
      infoWindow: InfoWindow(
        title: 'สถานีกระบุรี',
        snippet: 'สถานีกระบุรี',
      ),
    );
  }

  Marker tskMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home5'),
      position: LatLng(11.41896, 99.58825),
      infoWindow: InfoWindow(
        title: 'สถานีทับสะแก',
        snippet: 'สถานีทับสะแก',
      ),
    );
  }

  Marker pkkMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home6'),
      position: LatLng(11.90594, 99.8013),
      infoWindow: InfoWindow(
        title: 'สถานีประจวบคีรีขันธ์',
        snippet: 'สถานีประจวบคีรีขันธ์',
      ),
    );
  }

  Marker huaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home7'),
      position: LatLng(12.565142, 99.935176),
      infoWindow: InfoWindow(
        title: 'สถานีหัวหิน',
        snippet: 'สถานีหัวหิน',
      ),
    );
  }

  Marker pbrMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home8'),
      position: LatLng(13.104522, 99.929012),
      infoWindow: InfoWindow(
        title: 'สถานีเพชรบุรี',
        snippet: 'สถานีเพชรบุรี',
      ),
    );
  }

  Marker pnpMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home9'),
      position: LatLng(12.3420, 99.990111),
      infoWindow: InfoWindow(
        title: 'สถานีปากน้ำปราณ',
        snippet: 'สถานีปากน้ำปราณ',
      ),
    );
  }

  Marker tsaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home10'),
      position: LatLng(10.835377, 99.215555),
      infoWindow: InfoWindow(
        title: 'สถานีท่าแซะ',
        snippet: 'สถานีท่าแซะ',
      ),
    );
  }

  Marker lhsMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home11'),
      position: LatLng(9.959558, 99.064853),
      infoWindow: InfoWindow(
        title: 'สถานีหลังสวน',
        snippet: 'สถานีหลังสวน',
      ),
    );
  }

  Marker swiMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home12'),
      position: LatLng(10.227609, 98.931172),
      infoWindow: InfoWindow(
        title: 'สถานีสวี',
        snippet: 'สถานีสวี',
      ),
    );
  }

  Marker phtMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home13'),
      position: LatLng(9.79382, 98.77573),
      infoWindow: InfoWindow(
        title: 'สถานีพะโต๊ะ',
        snippet: 'สถานีพะโต๊ะ',
      ),
    );
  }

  Marker kpoMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home14'),
      position: LatLng(9.53297, 98.52367),
      infoWindow: InfoWindow(
        title: 'สถานีกะเปอร์',
        snippet: 'สถานีกะเปอร์',
      ),
    );
  }

  Marker krbMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home15'),
      position: LatLng(9.12644, 98.445694),
      infoWindow: InfoWindow(
        title: 'สถานีคุระบุรี',
        snippet: 'สถานีคุระบุรี',
      ),
    );
  }

  Marker srtMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home16'),
      position: LatLng(9.09233, 99.34853),
      infoWindow: InfoWindow(
        title: 'สถานีสุราษฏร์ธานี',
        snippet: 'สถานีสุราษฏร์ธานี',
      ),
    );
  }

  Marker bkkMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home17'),
      position: LatLng(13.7543, 100.54027),
      infoWindow: InfoWindow(
        title: 'สถานีกรุงเทพใบหยก',
        snippet: 'สถานีกรุงเทพใบหยก',
      ),
    );
  }

  Marker skaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home18'),
      position: LatLng(7.01517, 100.51969),
      infoWindow: InfoWindow(
        title: 'สถานีสงขลา',
        snippet: 'สถานีสงขลา',
      ),
    );
  }

  Marker thsgMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home19'),
      position: LatLng(8.21018, 99.489998),
      infoWindow: InfoWindow(
        title: 'สถานีทุ่งสง',
        snippet: 'สถานีทุ่งสง',
      ),
    );
  }

  Marker phkMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home20'),
      position: LatLng(7.89871, 98.3953),
      infoWindow: InfoWindow(
        title: 'สถานีภูเก็ต',
        snippet: 'สถานีภูเก็ต',
      ),
    );
  }

  Marker trngMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home21'),
      position: LatLng(7.656956, 99.486511),
      infoWindow: InfoWindow(
        title: 'สถานีตรัง',
        snippet: 'สถานีตรัง',
      ),
    );
  }

  Marker nraMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home23'),
      position: LatLng(6.411111, 101.801944),
      infoWindow: InfoWindow(
        title: 'สถานีนราธิวาส',
        snippet: 'สถานีนราธิวาส',
      ),
    );
  }

  Marker ylaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home24'),
      position: LatLng(6.335338, 101.389309),
      infoWindow: InfoWindow(
        title: 'สถานียะลา',
        snippet: 'สถานียะลา',
      ),
    );
  }

  Marker stnMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home25'),
      position: LatLng(6.635378, 100.0256),
      infoWindow: InfoWindow(
        title: 'สถานีสตูล',
        snippet: 'สถานีสตูล',
      ),
    );
  }

  Marker phngaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home26'),
      position: LatLng(8.434645, 98.50654),
      infoWindow: InfoWindow(
        title: 'สถานีพังงา',
        snippet: 'สถานีพังงา',
      ),
    );
  }

  Marker ubnMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home27'),
      position: LatLng(15.381667, 104.923611),
      infoWindow: InfoWindow(
        title: 'สถานีอุบล',
        snippet: 'สถานีอุบล',
      ),
    );
  }

  Marker kknMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home28'),
      position: LatLng(16.463686, 102.946222),
      infoWindow: InfoWindow(
        title: 'สถานีขอนแก่น',
        snippet: 'สถานีขอนแก่น',
      ),
    );
  }

  Marker srnMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home29'),
      position: LatLng(14.91952, 103.50768),
      infoWindow: InfoWindow(
        title: 'สถานีสุรินทร์',
        snippet: 'สถานีสุรินทร์',
      ),
    );
  }

  Marker nkrsmMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home30'),
      position: LatLng(14.947688, 101.995052),
      infoWindow: InfoWindow(
        title: 'สถานีนครราชสีมา',
        snippet: 'สถานีนครราชสีมา',
      ),
    );
  }

  Marker nkswMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home31'),
      position: LatLng(15.71617, 100.13358),
      infoWindow: InfoWindow(
        title: 'สถานีนครสวรรค์',
        snippet: 'สถานีนครสวรรค์',
      ),
    );
  }

  Marker skawMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home32'),
      position: LatLng(13.804003, 102.104231),
      infoWindow: InfoWindow(
        title: 'สถานีสระแก้ว',
        snippet: 'สถานีสระแก้ว',
      ),
    );
  }

  Marker rayngMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home33'),
      position: LatLng(12.675987, 101.412925),
      infoWindow: InfoWindow(
        title: 'สถานีระยอง',
        snippet: 'สถานีระยอง',
      ),
    );
  }

  Marker trdMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home34'),
      position: LatLng(12.19551, 102.29844),
      infoWindow: InfoWindow(
        title: 'สถานีตราด',
        snippet: 'สถานีตราด',
      ),
    );
  }

  Marker bknMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home35'),
      position: LatLng(18.35469, 103.55319),
      infoWindow: InfoWindow(
        title: 'สถานีบึงกาฬ',
        snippet: 'สถานีบึงกาฬ',
      ),
    );
  }

  Marker sknMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home36'),
      position: LatLng(17.13805, 103.98752),
      infoWindow: InfoWindow(
        title: 'สถานีสกลนคร',
        snippet: 'สถานีสกลนคร',
      ),
    );
  }

  Marker mukdaMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home37'),
      position: LatLng(16.613679, 104.718181),
      infoWindow: InfoWindow(
        title: 'สถานีมุกดาหาร',
        snippet: 'สถานีมุกดาหาร',
      ),
    );
  }

  Marker roiMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home38'),
      position: LatLng(15.97835, 103.62421),
      infoWindow: InfoWindow(
        title: 'สถานีร้อยเอ็ด',
        snippet: 'สถานีร้อยเอ็ด',
      ),
    );
  }

  Marker sskMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home39'),
      position: LatLng(15.042331, 104.345228),
      infoWindow: InfoWindow(
        title: 'สถานีศรีสะเกษ',
        snippet: 'สถานีศรีสะเกษ',
      ),
    );
  }


  Marker yasoMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home40'),
      position: LatLng(15.803563, 104.142504),
      infoWindow: InfoWindow(
        title: 'สถานียโสธร',
        snippet: 'สถานียโสธร',
      ),
    );
  }

    Marker udnMaker() {
    return Marker(
      //icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
      icon: policeIcon,
      markerId: MarkerId('home41'),
      position: LatLng(17.664041, 102.794088),
      infoWindow: InfoWindow(
        title: 'สถานีอุดรธานี',
        snippet: 'สถานีอุดรธานี',
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
