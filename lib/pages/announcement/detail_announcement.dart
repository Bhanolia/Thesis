import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/announcement/Attachment_Card.dart';
import 'package:manager/pages/announcement/update_announcement.dart';
import 'package:manager/pages/announcement/upload_announcement.dart';
import 'package:intl/intl.dart';

class DetailPageAnnouncement extends StatefulWidget {
  final Announcement_Model announcement_model;

  const DetailPageAnnouncement({
    Key? key,
    required this.announcement_model,
  }) : super(key: key);

  @override
  State<DetailPageAnnouncement> createState() => _DetailPageAnnouncementState();
}

class _DetailPageAnnouncementState extends State<DetailPageAnnouncement> {
  late String role;
  bool _isVisible = false;
  bool _isheaderadded = false;

  @override
  void initState() {
    getRole();
    if (widget.announcement_model.Header != "") {
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
      //   title: Text(announcement_model.Tittle),
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
              child: Image.network(widget.announcement_model.Header),
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
            Text(widget.announcement_model.Uploader,
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
                "${DateFormat('MM/dd/yyyy').format(widget.announcement_model.Date_Creation).toString()}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(widget.announcement_model.Tittle,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            widget.announcement_model.Description,
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
              itemCount: widget.announcement_model.Attachment.length,
              itemBuilder: ((context, index) {
                return attachment_announcement_card(
                  announcement_model:
                      widget.announcement_model as Announcement_Model,
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
            builder: (context) => Update_Announcement(
                announcement_model: widget.announcement_model)));
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
      // Firebase Storage
      if (widget.announcement_model.Header != "") {
        final Header = widget.announcement_model.Header
            .toString()
            .split("2F")
            .last
            .split("?alt")
            .first
            .replaceAll("'", "");
        await FirebaseStorage.instance
            .ref()
            .child("Attachment/${widget.announcement_model.Id}/$Header")
            .delete();
      } else {
        // print("Header Empty");
      }

      await Future.forEach(widget.announcement_model.Attachment,
          (element) async {
        final Tittle = element
            .toString()
            .split("2F")
            .last
            .split("?alt")
            .first
            .replaceAll("'", "")
            .replaceAll("%20", " ");
        final path = "Attachment/${widget.announcement_model.Id}/$Tittle";
        // print(path);
        await FirebaseStorage.instance.ref().child(path).delete();
      });
      await FirebaseFirestore.instance
          .collection("Announcement")
          .doc(widget.announcement_model.Id)
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
