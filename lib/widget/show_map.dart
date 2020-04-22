import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jayshowloaction/widget/add_location.dart';
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

//Method

  @override
  void initState() {
    super.initState();
    //findLatLng();
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
    return <Marker>[
      Marker(
        markerId: MarkerId('myLocation'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'คุณอยุ่ตรงนี้? ',
          snippet: 'lat = $lat, lng = $lng',
        ),
      ),
      jjMaker(),
      policeMarker()
    ].toSet();
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
              margin: EdgeInsets.only(bottom: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (value) => MyService(
                            currentWidget: AddLocation(),
                          ));
                  Navigator.of(context)
                      .pushAndRemoveUntil(route, (value) => false);
                },
                child: Icon(
                  Icons.add_circle,
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
