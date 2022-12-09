import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:manager/main.dart' as main;
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/User/Profil.dart';
import 'package:manager/pages/archive/Archive.dart';
import 'package:manager/pages/home.dart';
import 'package:manager/Widget/bug.dart' as bug;
import 'package:manager/pages/Users/user.dart' as user;
import 'package:manager/pages/announcement/academic.dart'
    as announcement_academic;
import 'package:manager/pages/announcement/non_academic.dart'
    as announcement_nonacademic;
import 'package:manager/pages/archive/academic.dart' as archive_academic;
import 'package:manager/pages/archive/non_academic.dart' as archive_nonacademic;

class DrawerUser extends StatefulWidget {
  @override
  State<DrawerUser> createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  late user_model umodel = user_model("", "", "", DateTime.now(),
      DateTime.now(), "", "", "", "", "", DateTime.now(), "", "", "");
  bool _isVisible = false;
  late String imageurl =
      "https://firebasestorage.googleapis.com/v0/b/manager-7236b.appspot.com/o/Assets%2FImage%2FTranparant.png?alt=media&token=5b330781-c04a-4a1b-8237-e60a44542fa6";
  late String greting = "Welcome to manager";
  var _colortransparant = Colors.transparent;

  @override
  void initState() {
    // getuserdata();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getuserdata();
    // setOption();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple.shade400,
      child: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple.shade400,
                  shape: BoxShape.rectangle,
                ),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.purple.shade400,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageurl),
                          backgroundColor: _colortransparant,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Text(greting,
                            style: TextStyle(
                                // color: Colors.white,
                                fontSize: 15.0,
                                color: _colortransparant,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new profil()));
                  },
                )),
            _createDrawerItem(
                icon: Icons.home,
                text: 'Hompage',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => new Home()));
                }),
            Divider(),
            _createDrawerItem(
                icon: FontAwesomeIcons.bullhorn,
                text: 'Announcement',
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.of(context).push(new MaterialPageRoute(
                  //     builder: (context) => new annoouncement.Announcement()));
                }),
            _createSubDrawerItem(
                text: "Academic",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new announcement_academic.Announcement_Academic()));
                }),
            _createSubDrawerItem(
                text: "Non-Academic",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new announcement_nonacademic
                          .Announcement_NonAcademic()));
                }),
            _createDrawerItem(
                icon: Icons.archive_sharp,
                text: 'Archive',
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.of(context).push(new MaterialPageRoute(
                  //     builder: (context) => new archive()));
                }),
            _createSubDrawerItem(
                text: "Academic",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new archive_academic.Archive_Academic()));
                }),
            _createSubDrawerItem(
                text: "Non-Academic",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new archive_nonacademic.Archive_NonAcademic()));
                }),
            // _createDrawerItem(icon: Icons.note, text: '',),
            Divider(),
            _createDrawerItem(
                icon: Icons.account_box_sharp,
                text: 'Profil',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new profil()));
                }),
            // _createDrawerItem(icon: Icons.face, text: 'Authors'),
            // _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation',),
            // _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
            Visibility(
                visible: _isVisible,
                child: _createDrawerItem(
                    icon: Icons.supervisor_account,
                    text: 'User',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new user.userlist()));
                    })),

            _createDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Sign Out ',
                onTap: () {
                  Signout();
                }),
            Divider(),
            _createDrawerItem(
                icon: Icons.bug_report,
                text: 'Bug',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new bug.Bug()));
                }),
            Divider(),
            // ListTile(
            //   title: Text('Aplikasi Versi 0.0.1'),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.purple,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.purple),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createSubDrawerItem(
      {
      // required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          // Icon(
          //   icon,
          //   color: Colors.purple,
          // ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.purple),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Future getuserdata() async {
    var Docid;
    final auth = await FirebaseAuth.instance.currentUser?.uid;
    final Firestore = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: auth)
        .limit(1)
        .get();

    Firestore.docs.forEach((element) async {
      // print(element.id);
      Docid = element.data()['DocID'];
      // print(Docid);
    });

    final readuserdata =
        await FirebaseFirestore.instance.collection("users").doc(Docid).get();

    umodel = user_model.fromSnapshot(readuserdata);

    // print(umodel.lastlogin);

    if (umodel.role == "Admin") {
      setState(() {
        _isVisible = true;
      });
    }
    await setOption();
  }

  Future setOption() async {
    if (umodel.imageUrl != "") {
      setState(() {
        imageurl = umodel.imageUrl;
      });
    }
    if (umodel.name != "") {
      final namesplit = umodel.name.split(" ").first;
      setState(() {
        greting = "Hello $namesplit";
        _colortransparant = Colors.white;
        // print("greting length is ${greting.length}");
      });
    }
  }

  Future Signout() async {
    await FirebaseFirestore.instance
        .collection("Fcm_Token")
        .doc(umodel.userId)
        .delete();
    await FirebaseAuth.instance.signOut();
    // Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => main.MyApp()),
        (route) => false);
  }
}
