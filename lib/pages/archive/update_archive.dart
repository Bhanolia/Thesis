import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:manager/Widget/Card/Archive_Card.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Archive_Model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:manager/pages/Notification/Notification.dart';
import 'package:intl/intl.dart';

class Update_Archive extends StatefulWidget {
  final Archive_Model Archive_model;

  Update_Archive({required this.Archive_model});

  @override
  _Update_Archive createState() => _Update_Archive();
}

class _Update_Archive extends State<Update_Archive> {
  final TittleControler = TextEditingController();
  final DescriptionControler = TextEditingController();
  PlatformFile? pickedFile;
  List<File>? files;
  List sumfiles = [];
  List sumfiles_local = [];
  List filesUrl = [];
  late String Uploader;
  late File singlefile = File("");
  late String headerurl = "";
  var previewbackground = Colors.purple.shade400;

  late String categories_value = "Academic";
  int _categories = 1;
  bool previewtextvisibile = true;
  bool isheaderfilled = true;
  bool showheaderurl = true;
  bool showheaderlocal = false;
  bool isheaderupdated = false;
  bool deleteattachmentindb = false;
  late String showimage = "";
  late String finalheaderurl = "";
  List DraftDeletedArchive = [];

  @override
  void initState() {
    getRole();
    synccategoryheader();
    sync_attachment();
    sync_Controller();
    synccategoryheader();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        backgroundColor: Colors.purple,
        title: Text("Update Archive"),
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
                            "Preview Header Archive",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showheaderurl,
                        child: _headerUrl(showimage),
                      ),
                      Visibility(
                        visible: showheaderlocal,
                        child: _headerLocal(singlefile),
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
                        visible: showheaderurl,
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
                      Visibility(
                        visible: showheaderlocal,
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
                                deleteimageupdated();
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

                          final String Final_Tittle;
                          final Tittle = sumfiles[index]
                              .toString()
                              .split("2F")
                              .last
                              .split("?alt")
                              .first
                              .replaceAll("'", "")
                              .replaceAll("%20", " ");

                          final cutting = 32;
                          if (Tittle.length > 19) {
                            final Split_title_end =
                                Tittle.substring(Tittle.length - 5);
                            final Split_title_Start = Tittle.substring(0, 16);
                            Final_Tittle =
                                "${Split_title_Start}...${Split_title_end}";
                          } else {
                            Final_Tittle = Tittle;
                          }
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
                              sumfiles.removeAt(index);
                              // print(filesUrl);
                              if (filesUrl.isNotEmpty &&
                                  index < filesUrl.length) {
                                // print(filesUrl);
                                DraftDeletedArchive.add(filesUrl[index]);
                                deleteattachmentindb = true;
                                filesUrl.removeAt(index);
                                // print("filesUrl Affter Delete ..");
                                // print(filesUrl);
                              }
                              final delete_index = index - filesUrl.length;
                              if (sumfiles_local.isNotEmpty &&
                                  delete_index < sumfiles_local.length) {
                                // print(sumfiles_local.length);
                                // print("index that will get deleted is $delete_index");
                                sumfiles_local.removeAt(delete_index);
                                // print("sumfiles_local Affter Delete ..");
                                // print(sumfiles_local);
                                // print(sumfiles_local.length);
                              }

                              // print(sumfiles);
                              // print(filesUrl);
                              setState(() {
                                sumfiles.length;
                                filesUrl.length;
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
                child: Text("Update"),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
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
          isheaderupdated = true;
          previewtextvisibile = false;
          showheaderlocal = true;
          showheaderurl = false;
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
      finalheaderurl = "";
      previewtextvisibile = true;
      isheaderfilled = true;
      showheaderlocal = false;
      showheaderurl = false;
    });

    // print(finalheaderurl);
  }

  Future deleteimageupdated() async {
    setState(() {
      finalheaderurl = widget.Archive_model.Header;
      // previewtextvisibile = true;
      isheaderfilled = true;
      showheaderlocal = false;
      showheaderurl = true;
    });

    // print(finalheaderurl);
  }

  Future synccategoryheader() async {
    if (widget.Archive_model.Categories == "Academic") {
      setState(() {
        _categories = 1;
      });
    } else {
      setState(() {
        _categories = 2;
      });
    }
    if (widget.Archive_model.Header != "") {
      setState(() {
        isheaderfilled = true;
        finalheaderurl = widget.Archive_model.Header;
        showimage = widget.Archive_model.Header;
      });
    } else {
      setState(() {
        isheaderfilled = false;
        // showimage = "https://firebasestorage.googleapis.com/v0/b/manager-7236b.appspot.com/o/Assets%2FImage%2FTranparant.png?alt=media&token=5b330781-c04a-4a1b-8237-e60a44542fa6";
      });
    }
    if (isheaderfilled == true) {
      previewtextvisibile = false;
      showheaderurl = true;
      showheaderlocal = false;
    } else {
      previewtextvisibile = true;
      showheaderurl = false;
      showheaderlocal = false;
    }
  }

  Widget _headerLocal(File src) {
    return Image.file(src);
  }

  Widget _headerUrl(String src) {
    return Image.network(src);
  }

  Future SelectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = List.from(result.paths.map((path) => File(path!)).toList());
        files?.forEach((file) async {
          // print("Adding ${file}");
          sumfiles_local.add(file.absolute);
          // print("Length ${sumfiles_local.length}");
          // print("Values  sumfiles local ${sumfiles_local}");
          final Tittle = file.toString().split("/").last.replaceAll("'", "");
          sumfiles.add(Tittle);
          // print("Values  sumfiles local ${sumfiles}");
        });
        sumfiles_local.length;
        sumfiles.length;
      });
    }
  }

  Future sync_attachment() async {
    await Future.forEach(widget.Archive_model.Attachment, (element) async {
      sumfiles.add(element);
      filesUrl.add(element);
      // print("Adding $element to List ...");
    });

    setState(() {
      sumfiles.length;
      filesUrl.length;
    });
    // return sumfiles;
  }

  Future sync_Controller() async {
    TittleControler.text = widget.Archive_model.Tittle;
    DescriptionControler.text = widget.Archive_model.Description;
  }

  Future Upload_Storage() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // print(sumfiles_local);
      await Future.forEach(sumfiles_local, (element) async {
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
        final Folder = widget.Archive_model.Id;
        final path = 'Attachment/${Folder}/${path_split}';
        final file = File(filepath);
        final ref = FirebaseStorage.instance.ref().child(path);
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // print(taskSnapshot);
        final url = await taskSnapshot.ref.getDownloadURL();
        filesUrl.add(url);
      });
      // print(filesUrl);

      // return filesUrl;
    } catch (e) {
      // print(e);
    }
  }

  Future Upload() async {
    await Upload_Storage();

    // print(filesUrl);
    var firestore = await FirebaseFirestore.instance
        .collection("Announcement")
        .doc(widget.Archive_model.Id);
    var uid = await FirebaseAuth.instance.currentUser!;
    try {
      // if (filesUrl.isNotEmpty) {
      final Archive = Archive_Model(
          firestore.id,
          categories_value,
          TittleControler.text.trim(),
          DescriptionControler.text.trim(),
          DateTime.now(),
          Uploader,
          finalheaderurl,
          await filesUrl);
      final jsonu = Archive.toJson();
      await firestore.set(jsonu);

      // Firebase Storage Header
      if (isheaderupdated == true) {
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
        finalheaderurl = headerurl;
        // print(finalheaderurl);
        setState(() {
          finalheaderurl = headerurl;
        });
        await firestore.update({"Header": finalheaderurl});
        // print("Upload Header Succes");
      } else {
        // print("Header Not Updated");
      }

      if (deleteattachmentindb == true) {
        await deleteAtachmentonline();
        // print("Attachment Deleted");
      } else {
        // print("No Attachment Change");
      }

      // await Send_Archive();
      Fluttertoast.showToast(
          msg: "Update Success",
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
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      // }

    } catch (e) {
      // print(e);
    }
  }

  Future deleteAtachmentonline() async {
    // print("List Url Will Deleted $DraftDeletedArchive");
    try {
      await Future.forEach(DraftDeletedArchive, (element) async {
        final Tittle = element
            .toString()
            .split("2F")
            .last
            .split("?alt")
            .first
            .replaceAll("'", "")
            .replaceAll("%20", " ");
        final path = "Attachment/${widget.Archive_model.Id}/$Tittle";
        // print(path);
        await FirebaseStorage.instance.ref().child(path).delete();
      });
    } on FirebaseException catch (e) {
      // print(e.toString());
    }
  }
}
