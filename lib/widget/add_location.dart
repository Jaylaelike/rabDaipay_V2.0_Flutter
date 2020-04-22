import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jayshowloaction/utility/my_style.dart';
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

  Widget showMap() {
    if (lat != null) {
      LatLng latLng = LatLng(lat, lng);
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
              mapType: MapType.normal,
              onMapCreated: (value) {},
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
              decoration: InputDecoration(
                labelText: 'Name: ',
                prefixIcon: Icon(Icons.account_box),
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
              decoration: InputDecoration(
                labelText: 'Detail: ',
                prefixIcon: Icon(Icons.details),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameForm(),
            detailForm(),
            showMap(),
          ],
        ),
      ),
    );
  }
}
