import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/pages/Users/DetailPage.dart';
import 'package:manager/pages/announcement/detail_announcement.dart';
import 'package:manager/services/permissons_and_folder.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class attachment_announcement_card extends StatefulWidget {
  final Announcement_Model announcement_model;
  final int index;

  attachment_announcement_card(
      {required this.announcement_model, required this.index});

  @override
  State<attachment_announcement_card> createState() =>
      _attachment_announcement_cardState();
}

class _attachment_announcement_cardState
    extends State<attachment_announcement_card> {
  ReceivePort _port = ReceivePort();
  late DownloadTaskStatus status;
  late String sizefile = "";
  late var icon = Icon(Icons.download_sharp);

  @override
  void initState() {
    getfilesize();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    isDownloaded();
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    final sum = widget.index + 1;
    final String Tittle;
    final String Final_Tittle;
    Tittle = widget.announcement_model.Attachment[widget.index]
        .toString()
        .split("2F")
        .last
        .split("?alt")
        .first
        .replaceAll("'", "")
        .replaceAll("%20", " ");

    final cutting = 32;
    if (Tittle.length > 19) {
      final Split_title_end = Tittle.substring(Tittle.length - 5);
      final Split_title_Start = Tittle.substring(0, 16);
      Final_Tittle = "${Split_title_Start}...${Split_title_end}";
    } else {
      Final_Tittle = Tittle;
    }
    // print(Tittle.length);
    // print(Final_Tittle.length);

    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,

        // margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.file_copy),
                ),
                // Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 5.0, left: 20.0),
                      child: Text(
                        "File Attachment - ${sum}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        // style: GoogleFonts.seymourOne(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                      child: Text(
                        Final_Tittle,
                        textWidthBasis: TextWidthBasis.parent,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 10.0, left: 20.0),
                      child: Text(
                        sizefile,
                        textWidthBasis: TextWidthBasis.parent,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: 50,
                  height: 50,
                  child: icon,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // permision();
        createFolderchild();
        Download_Attachmnet();
      },
    );
  }

  Future Download_Attachmnet() async {
    String Tittle;
    Tittle = widget.announcement_model.Attachment[widget.index]
        .toString()
        .split("2F")
        .last
        .split("?alt")
        .first
        .replaceAll("'", "");
    Tittle = Tittle.replaceAll("%20", " ");
    final url = widget.announcement_model.Attachment[widget.index];
    final httpsReference = FirebaseStorage.instance.refFromURL(url);
    final appDocDir = await getExternalStorageDirectory();
    final fath = await getApplicationDocumentsDirectory;
    final deirectory = "/storage/emulated/0/manager/files";
    final filePath = '${deirectory}/$Tittle';
    // final filePath = '${appDocDir?.path}/$Tittle';
    // print(fath);
    final file = File(filePath);
    try {
      if ((await file.exists())) {
        // print("File Already Exist");
        OpenFile.open(filePath);
      } else {
        // print("File Not Exist");
        // print("Downloading");
        final downloadTask = await FlutterDownloader.enqueue(
          url: url,
          savedDir: deirectory,
          showNotification: true,
          // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
      }
    } on FirebaseException catch (e) {
      // print(e);
    }
  }

  Future getfilesize() async {
    String Tittle;
    Tittle = widget.announcement_model.Attachment[widget.index]
        .toString()
        .split("2F")
        .last
        .split("?alt")
        .first
        .replaceAll("'", "");
    Tittle = Tittle.replaceAll("%20", " ");
    // print(Tittle);
    final path = "Attachment/${widget.announcement_model.Id}/$Tittle";
    final firebasestorage = await FirebaseStorage.instance.ref(path);
    final metadata = await firebasestorage.getMetadata();
    final file = metadata.size;
    if (file! <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(file) / log(1000)).floor();
    final conver = (file / pow(1000, i)).toString() + ' ' + suffixes[i];
    final cutsting = conver.substring(0, 5) + " " + suffixes[i];
    // print("Filesizeraw :$i");
    // print("Filesize :$cutsting");
    setState(() {
      sizefile = cutsting;
    });
  }

  Future isDownloaded() async {
    String Tittle;
    Tittle = widget.announcement_model.Attachment[widget.index]
        .toString()
        .split("2F")
        .last
        .split("?alt")
        .first
        .replaceAll("'", "");
    Tittle = Tittle.replaceAll("%20", " ");
    final deirectory = "/storage/emulated/0/manager/files";
    final filePath = '${deirectory}/$Tittle';
    final file = File(filePath);
    if ((await file.exists())) {
      // print("File Already Exist");
      setState(() {
        icon = Icon(
          Icons.open_in_new,
          color: Colors.green,
        );
      });
    } else {
      print("not downloaded");
    }
  }
}
