import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:manager/Widget/Card/Announcement_Card.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:manager/pages/Notification/Notification.dart';
import 'package:intl/intl.dart';

enum Categories { Academic, Non_Academic }

class UploadAnnouncement extends StatefulWidget {
  @override
  _UploadAnnouncement createState() => _UploadAnnouncement();
}

class _UploadAnnouncement extends State<UploadAnnouncement> {
  final TittleControler = TextEditingController();
  final DescriptionControler = TextEditingController();
  PlatformFile? pickedFile;
  List<File>? files;
  List sumfiles = [];
  List filesUrl = [];
  late String Uploader;
  late String Final_Tittle;
  late File singlefile = File("");
  late String headerurl = "";
  var previewbackground = Colors.purple.shade400;
  bool previewtextvisibile = true;
  late String categories_value = "Academic";
  int _categories = 1;
  bool isheaderadded = false;

  @override
  void initState() {
    getRole();
    // print(singlefile);
    super.initState();
  }

  Future SelectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = List.from(result.paths.map((path) => File(path!)).toList());
        files?.forEach((file) async {
          // print("Adding ${file}");
          sumfiles.add(file.absolute);
          // print("Length ${sumfiles.length}");
          // print("Values  sumfiles ${sumfiles}");
          // print("Values  files ${files}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        backgroundColor: Colors.purple,
        title: Text("Upload Announcement"),
      ),
      backgroundColor: Colors.purple.shade400,
      // drawer: DrawerUser(),
      body: Center(
        child: Container(
          margin:
              EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: height * 0.2,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: previewbackground,
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Visibility(
                        visible: previewtextvisibile,
                        child: Center(
                          child: Text(
                            "Preview Header Announcement",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !previewtextvisibile,
                        child: Image.file(singlefile),
                      ),
                      Container(
                        // height: 50,
                        // width: 50,
                        alignment: Alignment(1, 1),
                        // color: Colors.purple[50],
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.white,
                          child: IconButton(
                            color: Colors.purple,
                            hoverColor: Colors.black,
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30.0,
                            ),
                            onPressed: () {
                              // print("Add Picture Pressed");
                              selectImage();
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !previewtextvisibile,
                        child: Container(
                          // height: 50,
                          // width: 50,
                          alignment: Alignment(-1, 1),
                          // color: Colors.purple[50],
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.white,
                            child: IconButton(
                              color: Colors.purple,
                              hoverColor: Colors.black,
                              icon: Icon(
                                Icons.delete,
                                size: 30.0,
                              ),
                              onPressed: () {
                                // print("delete Picture Pressed");
                                deleteimage();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // color: previewbackground,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                              activeColor: previewbackground,
                              value: 1,
                              groupValue: _categories,
                              onChanged: (value) {
                                setState(() {
                                  _categories = int.parse(value.toString());
                                  categories_value = "Academic";
                                  // print(categories_value);
                                });
                              }),
                          Text(
                            "Academic",
                            style: TextStyle(color: previewbackground),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                              activeColor: previewbackground,
                              value: 2,
                              groupValue: _categories,
                              onChanged: (value) {
                                setState(() {
                                  _categories = int.parse(value.toString());
                                  categories_value = ("Non-Academic");
                                  // print(categories_value);
                                });
                              }),
                          Text(
                            "Non-Academic",
                            style: TextStyle(color: previewbackground),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: TittleControler,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Tittle",
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (tittle) {
                  if (tittle == null || tittle.isEmpty) {
                    // ignore: missing_return,

                    return "Please insert Tittle";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                controller: DescriptionControler,
                decoration: InputDecoration(
                  hintText: "Description",
                ),
              ),

              if (sumfiles.length != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: sumfiles.length,
                        itemBuilder: (context, index) {
                          final sum = index + 1;
                          final Tittle = sumfiles[index]
                              .toString()
                              .split("/")
                              .last
                              .replaceAll("'", "");

                          if (Tittle.length > 20) {
                            final Split_title_end =
                                Tittle.substring(Tittle.length - 5);
                            final Split_title_Start = Tittle.substring(0, 13);
                            Final_Tittle =
                                "${Split_title_Start}...${Split_title_end}";
                          } else {
                            Final_Tittle = Tittle;
                          }
                          // print(" tittle length = ${Tittle.length}");
                          // print("final tittle length = ${Final_Tittle.length}");
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 5.0,
                                                left: 20.0),
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
                                            padding: const EdgeInsets.only(
                                                top: 5.0,
                                                bottom: 10.0,
                                                left: 20.0),
                                            child: Text(
                                              Final_Tittle,
                                              textWidthBasis:
                                                  TextWidthBasis.parent,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        child: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              final remove = sumfiles.removeAt(index);
                              // print(sumfiles);
                              setState(() {
                                sumfiles.length;
                              });
                            },
                          );
                        }),
                  ],
                ),
              // Text(_fileText.split('/').last.replaceAll("']","")),
              MaterialButton(
                color: Colors.orange,
                onPressed: SelectFile,
                child: Text("Attachment"),
                textColor: Colors.white,
              ),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  // print(TittleControler.text.trim());
                  if (TittleControler.text.isNotEmpty ||
                      TittleControler.text != "") {
                    // Upload_Storage();
                    Upload();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Tittle Is Empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text("Upload"),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final temporaryfile = File(result.files.single.path.toString());
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: temporaryfile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.purple.shade400,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      // print("Hasil crop url ${croppedFile?.path.toString()}");
      setState(() {
        if (croppedFile != null) {
          singlefile = File(croppedFile.path.toString());
          isheaderadded = true;
          previewtextvisibile = false;
        } else {
          singlefile = File("");
          // previewbackground = Colors.purple.shade400;
          previewtextvisibile = true;
          // print("file not selected");
        }
        // previewbackground = Colors.transparent;
      });
      // print(singlefile);
    }
  }

  Future deleteimage() async {
    setState(() {
      singlefile = File("");
      // previewbackground = Colors.purple.shade400;
      previewtextvisibile = true;
    });
    // print(singlefile);
  }

  Future getRole() async {
    late String role;

    final auth = await FirebaseAuth.instance.currentUser?.uid;
    final Firestore = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: auth)
        .limit(1)
        .get();

    Firestore.docs.forEach((element) async {
      // print(element.id);
      Uploader = element.data()['name'];
      role = element.data()['role'];
    });

    if (Uploader == " ") {
      setState(() {
        Uploader = role;
      });
    }
    // print(Uploader);
  }

  Future Upload() async {
    // await Upload_Storage();
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    // print(filesUrl);
    var firestore =
        await FirebaseFirestore.instance.collection("Announcement").doc();
    var uid = await FirebaseAuth.instance.currentUser!;
    try {
      // if (filesUrl.isNotEmpty) {
      final announcement = Announcement_Model(
          firestore.id,
          categories_value,
          TittleControler.text.trim(),
          DescriptionControler.text.trim(),
          DateTime.now(),
          Uploader,
          "",
          await filesUrl);
      final jsonu = announcement.toJson();
      await firestore.set(jsonu);

      // // print(sumfiles);

      // Firebase Storage
      await Future.forEach(sumfiles, (element) async {
        // print("file item = $element");
        final path_split = element
            .toString()
            .split('/')
            .last
            .replaceAll("'", "")
            .replaceAll("]", "");
        final filepath = element
            .toString()
            .replaceAll("File:", "")
            .replaceAll("'", "")
            .trim();
        // print("File path = $filepath");
        final Folder = firestore.id;
        final path = 'Attachment/${Folder}/${path_split}';
        final file = File(filepath);
        final ref = FirebaseStorage.instance.ref().child(path);
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // print(taskSnapshot);
        final url = await taskSnapshot.ref.getDownloadURL();
        filesUrl.add(url);
      });

      final update = await FirebaseFirestore.instance
          .collection("Announcement")
          .doc(firestore.id);
      await update.update({"Attachment": filesUrl});
      // print(filesUrl);

      if (isheaderadded == true) {
        final extention_split =
            singlefile.toString().split('.').last.replaceAll("'", "");
        // print(extention_split);
        final imagename = "header.$extention_split";
        // print(imagename);
        final Folder = firestore.id;
        final path = 'Attachment/${Folder}/${imagename}';
        final ref = FirebaseStorage.instance.ref().child(path);
        final UploadTask uploadTask = ref.putFile(singlefile);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // print(taskSnapshot);
        final url = await taskSnapshot.ref.getDownloadURL();
        headerurl = url;
        // print(headerurl);
        setState(() {
          headerurl = url;
        });
        await update.update({"Header": headerurl});
        // print("Upload Header Succes");
      } else {
        // print("Header Image not set");
      }
      if (categories_value == "Academic") {
        await Send_Announcement();
      } else {
        await Send_Archive();
      }

      Fluttertoast.showToast(
          msg: "Uploading Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        TittleControler.clear();
        DescriptionControler.clear();
        sumfiles.clear();
        filesUrl.clear();
        singlefile = File("");
        headerurl = "";
      });
      Navigator.pop(context);
      Navigator.pop(context);

      // }

    } catch (e) {
      // print(e);
    }
  }
}
