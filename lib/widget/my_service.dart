import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jayshowloaction/utility/my_style.dart';
import 'package:jayshowloaction/widget/add_location.dart';
import 'package:jayshowloaction/widget/main_Home.dart';
import 'package:jayshowloaction/widget/show_map.dart';

class MyService extends StatefulWidget {
  //state throw
  final Widget currentWidget;
  MyService({Key key, this.currentWidget}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
//Field
  Widget currrentWidget = ShowMap();

//Method

  @override
  void initState() {
    super.initState();
    var object = widget.currentWidget;
    if (object != null) {
      setState(() {
        currrentWidget = object;
      });
    }
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
          currrentWidget = ShowMap();
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
          currrentWidget = AddLocation();
        });
        Navigator.of(context).pop();
      },
      leading: Icon(
        Icons.local_grocery_store,
        size: 36.0,
        color: MyStyle().darkColor,
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
    return UserAccountsDrawerHeader(
      currentAccountPicture: Image.asset('images/logo2.png'),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall2.png'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text(
        'Name',
        style: TextStyle(color: MyStyle().primaryColor),
      ),
      accountEmail: Text(
        'Email',
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
      body: currrentWidget,
    );
  }
}
