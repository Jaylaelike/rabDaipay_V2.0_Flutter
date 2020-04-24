import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jayshowloaction/utility/my_style.dart';
import 'package:jayshowloaction/widget/add_location.dart';
import 'package:jayshowloaction/widget/main_Home.dart';
import 'package:jayshowloaction/widget/show_map.dart';
import 'package:location/location.dart';

class MyService extends StatefulWidget {
  //state throw
  final Widget currentWidget;
  MyService({Key key, this.currentWidget}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
//Field
  Widget currrentWidget;
  String name, email, urlAvartar;
  double lat, lng;

//Method

  @override
  void initState() {
    super.initState();
    findLatLng();

    findNameandAvatar();

    var object = widget.currentWidget;
    if (object != null) {
      setState(() {
        currrentWidget = object;
      });
    }
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat =>>> $lat, lng ===>> $lng');
      currrentWidget = ShowMap(
        lat: lat,
        lng: lng,
      );
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

  Future<void> findNameandAvatar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    setState(() {
      name = firebaseUser.displayName;
      email = firebaseUser.email;
      urlAvartar = firebaseUser.photoUrl;
    });
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 180.0,
      width: 10.0,
    );
  }

  Widget myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          menuShowmap(),
          menuShowAdd(),
          mySizeBox(),
          menuSignOut(),
        ],
      ),
    );
  }

  ListTile menuShowmap() {
    return ListTile(
      onTap: () {
        setState(() {
          currrentWidget = ShowMap(
            lat: lat,
            lng: lng,
          );
        });
        Navigator.of(context).pop();
      },
      leading: Icon(
        Icons.map,
        size: 36.0,
        color: MyStyle().darkColor,
      ),
      title: Text('Show Map'),
      subtitle: Text('Descrpition Page Show map'),
    );
  }

  ListTile menuShowAdd() {
    return ListTile(
      onTap: () {
        setState(() {
          currrentWidget = AddLocation(
            lat: lat,
            lng: lng,
          );
        });
        Navigator.of(context).pop();
      },
      leading: Icon(
        Icons.add_location,
        size: 36.0,
        color: Colors.redAccent,  //MyStyle().darkColor
      ),
      title: Text('Show Add Location'),
      subtitle: Text('Show Add Location'),
    );
  }

  ListTile menuSignOut() {
    return ListTile(
      onTap: () {
        signOutProcess();
      },
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: MyStyle().darkColor,
      ),
      title: Text('Sign Out'),
      subtitle: Text('Sign out to Authen'),
    );
  }

//SignOut
  Future<void> signOutProcess() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((response) {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (value) => MainHome());
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  UserAccountsDrawerHeader showHead() {
    if (name == null) {
      name = '';
    } else if (email == null) {
      email = '';
    }
    if (urlAvartar == null) {
      urlAvartar =
          'https://firebasestorage.googleapis.com/v0/b/jayshowlocation.appspot.com/o/Avartar%2Favartar14005.jpg?alt=media&token=7ccc9346-2f7e-47bd-8719-71493878eb43';
    }
    return UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(urlAvartar),
        backgroundColor: Colors.grey,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall2.png'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text(
        '$name Login',
        style: TextStyle(color: MyStyle().primaryColor),
      ),
      accountEmail: Text(
        '$email',
        style: TextStyle(color: MyStyle().darkColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          title: Text('My Service'),
        ),
        body:
            currrentWidget == null ? MyStyle().showProgress() : currrentWidget);
  }
}
