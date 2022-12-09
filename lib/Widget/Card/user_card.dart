import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/Users/DetailPage.dart';
import 'package:intl/intl.dart';

class userCard extends StatefulWidget {
  final user_model umodel;

  userCard({required this.umodel});

  @override
  State<userCard> createState() => _userCardState();
}

class _userCardState extends State<userCard> {
  late String imageurl;

  @override
  void didChangeDependencies() {
    setimage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: new Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  backgroundImage: NetworkImage(imageurl),
                ),
                // Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: .0, left: 20.0),
                      child: Text(
                        widget.umodel.email,
                        // style: GoogleFonts.seymourOne(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 20.0),
                      child: Text(
                        widget.umodel.role.toLowerCase(),
                        // style: GoogleFonts.seymourOne(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 20.0),
                      child: Text(
                          "${DateFormat('dd/MM/yyyy').format(widget.umodel.lastlogin).toString()}"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => detailpage(umodel: umodel)));
      },
    );
  }

  Future setimage() async {
    if (widget.umodel.imageUrl != "") {
      setState(() {
        imageurl = widget.umodel.imageUrl;
      });
    } else {
      setState(() {
        imageurl = "https://source.unsplash.com/random/?face";
      });
    }
  }
}
