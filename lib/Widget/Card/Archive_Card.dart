import 'package:flutter/material.dart';
import 'package:manager/model/Archive_Model.dart';
import 'package:manager/pages/archive/detail_archive.dart';
import 'package:intl/intl.dart';

class archive_card extends StatelessWidget {
  final Archive_Model archive_Model;
  archive_card({required this.archive_Model});
  String tittle = "";
  @override
  Widget build(BuildContext context) {
    if (archive_Model.Tittle.length > 30) {
      tittle = archive_Model.Tittle.substring(0, 29);
      tittle = "$tittle...";
    } else {
      tittle = archive_Model.Tittle;
    }
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
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
                          top: 10.0, bottom: 5.0, left: 20.0),
                      child: Text(
                        tittle,
                        // style: GoogleFonts.seymourOne(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 10.0, left: 20.0),
                      child: Text(
                          "${DateFormat('dd/MM/yyyy').format(archive_Model.Date_Creation).toString()}"),
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
                builder: (context) =>
                    DetailPageArchive(Archive_model: archive_Model)));
      },
    );
  }
}
