import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/main.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/User/Update_Profile.dart';
import 'package:manager/pages/home.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class profil extends StatefulWidget {
  @override
  _profilState createState() => _profilState();
}

class _profilState extends State<profil> {
  final NameControler = TextEditingController();
  final RoleControler = TextEditingController();
  final LastLoginControler = TextEditingController();
  final NidnControler = TextEditingController();
  final EmailControler = TextEditingController();
  final GenderControler = TextEditingController();
  final PobControler = TextEditingController();
  final DobControler = TextEditingController();
  final AddressControler = TextEditingController();
  final TelephoneControler = TextEditingController();

  late user_model umodel = user_model("", "", "", DateTime.now(),
      DateTime.now(), "", "", "", "", "", DateTime.now(), "", "", "");
  late String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/manager-7236b.appspot.com/o/Assets%2FImage%2FTranparant.png?alt=media&token=5b330781-c04a-4a1b-8237-e60a44542fa6";

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    getUserData();
    setprofilepic();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  tooltip: 'Edit Profile',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Update_profil(umodel: umodel as user_model)));
                    // print("Edit Button Printed");
                  },
                ),
              ),
            ],
          ),
          drawer: DrawerUser(),
          backgroundColor: Colors.purple.shade400,
          body: LiquidPullToRefresh(
            onRefresh: getUserData,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                color: Colors.white,
                child:
                    // Column(
                    //   children: <Widget>[
                    ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                  children: <Widget>[
                    Container(
                      height: height * 0.2,
                      margin: EdgeInsets.only(top: 10.0, bottom: 50.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(imageUrl),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Nidn',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: NidnControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: NameControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: EmailControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: GenderControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Place Of Birth',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: PobControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Date Of Birth',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: DobControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: AddressControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Telephone',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: TelephoneControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Role',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: RoleControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.blue.shade100,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.purple),
                        ),
                        labelText: 'Last Login',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      enableInteractiveSelection: false,
                      controller: LastLoginControler,
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
          return true;
        });
  }

  Future getUserData() async {
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

    setState(() {
      umodel = user_model.fromSnapshot(readuserdata);
      // print(umodel.lastlogin);
      sync_Controller();
    });

    await setprofilepic();
    // if (umodel == "Admin") {
    //   setState(() {
    //     _isVisible = true;
    //   });
    // }
  }

  Future setprofilepic() async {
    if (umodel.imageUrl != "") {
      imageUrl = umodel.imageUrl;
      setState(() {
        imageUrl = umodel.imageUrl;
      });
    } else {
      setState(() {
        imageUrl = "https://source.unsplash.com/random/?face";
      });
    }

    // print(imageUrl);
  }

  Future sync_Controller() async {
    NameControler.text = umodel.name;
    EmailControler.text = umodel.email;
    RoleControler.text = umodel.role;
    LastLoginControler.text =
        "${DateFormat('dd/MM/yyyy').format(umodel.lastlogin).toString()}";
    NidnControler.text = umodel.nidn.toString();
    GenderControler.text = umodel.gender;
    PobControler.text = umodel.Pob;
    DobControler.text =
        "${DateFormat('dd/MM/yyyy').format(umodel.Dob).toString()}";
    AddressControler.text = umodel.address;
    TelephoneControler.text = umodel.telephone.toString();
  }
}
