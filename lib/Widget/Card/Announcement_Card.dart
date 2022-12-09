import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/pages/Users/DetailPage.dart';
import 'package:manager/pages/announcement/detail_announcement.dart';
import 'package:manager/pages/archive/Archive.dart';
import 'package:manager/services/auto_archive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class announcement_card extends StatefulWidget {
  final Announcement_Model announcement_model;

  announcement_card({required this.announcement_model});

  @override
  State<announcement_card> createState() => _announcement_cardState();
}

class _announcement_cardState extends State<announcement_card> {
  late String role;
  bool slidable = false;
  String tittle = "";

  @override
  void initState() {
    sync_slidable();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sync_slidable();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.announcement_model.Tittle.length > 30) {
      tittle = widget.announcement_model.Tittle.substring(0, 29);
      tittle = "$tittle...";
    } else {
      tittle = widget.announcement_model.Tittle;
    }
    return Slidable(
      enabled: slidable,
      startActionPane: ActionPane(motion: DrawerMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
          // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          flex: 1,
          icon: Icons.archive,
          label: "Archive",
          onPressed: ((contex) {
            // print("slideable");
            autoarchive();
          }),
        ),
      ]),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/images/login crop.png"),
                  ),
                  // Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0, left: 20.0),
                        child: Text(
                          tittle,
                          // style: GoogleFonts.seymourOne(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                            "${DateFormat('dd/MM/yyyy').format(widget.announcement_model.Date_Creation).toString()}"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPageAnnouncement(
                      announcement_model: widget.announcement_model)));
        },
      ),
    );
  }

  Future sync_slidable() async {
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
        slidable = true;
      });
      // print("Sildeable enable");
    } else {
      setState(() {
        slidable = false;
      });
      // print("Sildeable disable becaue Not authorized");
    }
  }

  Future autoarchive() async {
    final archive = await FirebaseFirestore.instance
        .collection("Archive")
        .doc(widget.announcement_model.Id);
    final addarchive = Announcement_Model(
        widget.announcement_model.Id,
        widget.announcement_model.Categories,
        widget.announcement_model.Tittle,
        widget.announcement_model.Description,
        widget.announcement_model.Date_Creation,
        widget.announcement_model.Uploader,
        widget.announcement_model.Header,
        widget.announcement_model.Attachment);
    try {
      await archive.set(addarchive.toJson());
      // print("Move Announcement to Archive Sccess");
      await FirebaseFirestore.instance
          .collection("Announcement")
          .doc(widget.announcement_model.Id)
          .delete();
      // print("delete old announcement success");
    } on FirebaseException catch (e) {
      // print(e.toString());
    }
  }
}
