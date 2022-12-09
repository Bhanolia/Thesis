import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Archive_Model.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/Archive/Attachment_Card.dart';
import 'package:manager/pages/Archive/update_Archive.dart';
import 'package:manager/pages/Archive/upload_Archive.dart';
import 'package:intl/intl.dart';

class DetailPageArchive extends StatefulWidget {
  final Archive_Model Archive_model;

  const DetailPageArchive({
    Key? key,
    required this.Archive_model,
  }) : super(key: key);

  @override
  State<DetailPageArchive> createState() => _DetailPageArchiveState();
}

class _DetailPageArchiveState extends State<DetailPageArchive> {
  late String role;
  bool _isVisible = false;
  bool _isheaderadded = false;

  @override
  void initState() {
    getRole();
    if (widget.Archive_model.Header != "") {
      _isheaderadded = true;
    } else {
      _isheaderadded = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 40;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[],
      //   elevation: 0.0,
      //   title: Text(Archive_model.Tittle),
      // ),
      // drawer: DrawerUser(),
      body: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 20.0,
            bottom: 0.0,
            left: 20.0,
            right: 20.0),
        shrinkWrap: true,
        children: <Widget>[
          Visibility(
            visible: _isheaderadded,
            child: Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                // color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Image.network(widget.Archive_model.Header),
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          Row(children: <Widget>[
            Text("By ",
                style: TextStyle(
                    fontSize: 12,
                    // color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Text(widget.Archive_model.Uploader,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ]),
          Row(
            children: <Widget>[
              Text("Uploaded"),
              Text(" "),
              Text(
                "${DateFormat('MM/dd/yyyy').format(widget.Archive_model.Date_Creation).toString()}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(widget.Archive_model.Tittle,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            widget.Archive_model.Description,
            style: TextStyle(),
            textAlign: TextAlign.justify,
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text("Attachment",
              style: TextStyle(
                  fontSize: 12,
                  // color: Colors.black,
                  fontWeight: FontWeight.bold)),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.Archive_model.Attachment.length,
              itemBuilder: ((context, index) {
                return attachment_archive_card(
                  archive_model: widget.Archive_model as Archive_Model,
                  index: index,
                );
              })),
          Divider(
            color: Colors.transparent,
          ),
          Visibility(
            visible: _isVisible,
            child: // Center(
                //   child:
                Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Spacer(),
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.5),
                  // height: 70,
                  width: width * 0.5,
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      // size: 50.0,
                    ),
                    onPressed: () {
                      Update();
                    },
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.5),
                  // height: 70,
                  width: width * 0.5,
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      // size: 50.0,
                    ),
                    onPressed: () {
                      Delete();
                    },
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }

  Future getRole() async {
    String DocIdUser;
    final auth = await FirebaseAuth.instance.currentUser?.uid;
    final Firestore = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: auth)
        .limit(1)
        .get();

    Firestore.docs.forEach((element) async {
      // print(element.id);
      role = element.data()['role'];
      // print(role);
    });

    if (role == "Admin") {
      setState(() {
        _isVisible = true;
      });
    }
  }

  void Update() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Update_Archive(Archive_model: widget.Archive_model)));
  }

  Future Delete() async {
    showDialog(
        context: context,
        builder: (contex) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      // Firebase Firestore
      if (widget.Archive_model.Header != "") {
        final Header = widget.Archive_model.Header
            .toString()
            .split("2F")
            .last
            .split("?alt")
            .first
            .replaceAll("'", "");
        await FirebaseStorage.instance
            .ref()
            .child("Attachment/${widget.Archive_model.Id}/$Header")
            .delete();
      } else {
        // print("Header Empty");
      }
      await Future.forEach(widget.Archive_model.Attachment, (element) async {
        final Tittle = element
            .toString()
            .split("2F")
            .last
            .split("?alt")
            .first
            .replaceAll("'", "")
            .replaceAll("%20", " ");
        ;
        final path = "Attachment/${widget.Archive_model.Id}/$Tittle";
        // print(path);
        await FirebaseStorage.instance.ref().child(path).delete();
      });
      await FirebaseFirestore.instance
          .collection("Archive")
          .doc(widget.Archive_model.Id)
          .delete();

      Fluttertoast.showToast(
          msg: "Delete Succes",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      // print(e.toString());
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (contex) {
            return Center(
                child: AlertDialog(
              content: Text("Delete Failed"),
            ));
          });
    }
  }
}
