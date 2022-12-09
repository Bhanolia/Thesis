import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/User_Model.dart';
import 'package:intl/intl.dart';

class Update_profil extends StatefulWidget {
  final user_model umodel;

  Update_profil({required this.umodel});

  @override
  _Update_profil createState() => _Update_profil();
}

class _Update_profil extends State<Update_profil> {
  final NameControler = TextEditingController();
  final RoleControler = TextEditingController();
  final LastLoginControler = TextEditingController();
  final NidnControler = TextEditingController();
  final EmailControler = TextEditingController();
  final GenderControler = TextEditingController();
  final PobControler = TextEditingController();
  final Dobtextview = TextEditingController();
  var DobControler;
  final AddressControler = TextEditingController();
  final TelephoneControler = TextEditingController();

  late File singlefile = File("");
  late String fileUrl = "";
  late String _valueGender = "Male";
  int _gender = 1;

  // late final user_model umodel;
  late String imageUrl;
  bool previewtextvisibile = true;
  bool isheaderfilled = true;
  bool showheaderurl = true;
  bool showheaderlocal = false;
  bool isheaderupdated = false;
  bool deleteattachmentindb = false;
  late String showimage = "";
  late String finalheaderurl = "";
  var previewbackground = Colors.purple;

  @override
  void initState() {
    // getUserData();
    sync_Controller();
    setprofilepic();
    super.initState();
  }

  void _showdatepicer() {
    // print("Value DOB Adalah $DobControler");
    showDatePicker(
            context: context,
            initialDate: DobControler,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100))
        .then((value) {
      if (value != null) {
        DobControler = value;
        // print(DobControler);
        Dobtextview.text =
            "${DateFormat('dd/MM/yyyy').format(DobControler).toString()}";
        // print("Date Of Birth Changed");
      } else {
        // print("Date Of Birth Not Change");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      // drawer: DrawerUser(),
      backgroundColor: Colors.purple.shade400,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          color: Colors.white,
          child:
              // Column(
              //   children: <Widget>[
              ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: 5.0, bottom: 50.0, left: 20.0, right: 20.0),
            children: <Widget>[
              Container(
                height: height * 0.2,
                margin: EdgeInsets.only(top: 10.0, bottom: 50.0),
                // decoration: BoxDecoration(
                //   color: Colors.purple.shade400,
                //   shape: BoxShape.circle,
                // ),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Visibility(
                        visible: previewtextvisibile,
                        child: Center(
                          child: Text(
                            "Preview\nPhoto Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.purple.shade400),
                          ),
                        ),
                      ),
                      Visibility(visible: showheaderurl, child: profileurl()),
                      Visibility(
                          visible: showheaderlocal, child: profilelocal()),
                      Container(
                        // height: 50,
                        // width: 50,
                        alignment: Alignment(0.5, 1),
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
                          alignment: Alignment(-0.5, 1),
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
                                // print("Delete Picture Pressed");
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
                          alignment: Alignment(-0.5, 1),
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
                                // print("Delete Picture Pressed");
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
              Divider(
                color: Colors.transparent,
              ),
              TextField(
                enabled: true,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  labelText: 'Nidn',
                  labelStyle: TextStyle(color: Colors.purple),
                ),
                enableInteractiveSelection: false,
                controller: NidnControler,
                keyboardType: TextInputType.number,
              ),
              Divider(
                color: Colors.transparent,
              ),
              TextField(
                enabled: true,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple.shade400)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width * 0.45),
                        // height: 70,
                        // color: Colors.purple,
                        width: width * 0.45,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Radio(
                                activeColor: previewbackground,
                                value: 1,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = int.parse(value.toString());
                                    _valueGender = "Male";
                                    // print(_valueGender);
                                  });
                                }),
                            Text(
                              "Male",
                              // style: TextStyle(color: previewbackground),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _gender = 1;
                          _valueGender = "Male";
                        });
                        // print(_valueGender);
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width * 0.45),
                        // height: 70,
                        // color: Colors.purple,
                        width: width * 0.45,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Radio(
                                activeColor: previewbackground,
                                value: 2,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = int.parse(value.toString());
                                    _valueGender = ("Female");
                                    // print(_valueGender);
                                  });
                                }),
                            Text(
                              "Female",
                              // style: TextStyle(color: previewbackground),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _gender = 2;
                          _valueGender = ("Female");
                        });
                        // print(_valueGender);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              TextField(
                enabled: true,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
              GestureDetector(
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.blue.shade100,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.purple),
                    ),
                    labelText: 'Date Of Birth',
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                  enableInteractiveSelection: false,
                  controller: Dobtextview,
                ),
                onTap: _showdatepicer,
              ),
              Divider(
                color: Colors.transparent,
              ),
              TextField(
                enabled: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
                enabled: true,
                // autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  labelText: 'Telephone',
                  labelStyle: TextStyle(color: Colors.purple),
                ),
                enableInteractiveSelection: false,
                controller: TelephoneControler,
                keyboardType: TextInputType.number,
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
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
                    borderSide: BorderSide(width: 1, color: Colors.purple),
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
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  // Upload_Storage();
                  Update_Profile();
                },
                child: Text("Update"),
                textColor: Colors.white,
              ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future sync_Controller() async {
    setState(() {
      NameControler.text = widget.umodel.name;
      EmailControler.text = widget.umodel.email;
      RoleControler.text = widget.umodel.role;
      LastLoginControler.text =
          "${DateFormat('dd/MM/yyyy').format(widget.umodel.lastlogin).toString()}";
      NidnControler.text = widget.umodel.nidn;
      PobControler.text = widget.umodel.Pob;
      DobControler = widget.umodel.Dob;
      Dobtextview.text =
          "${DateFormat('dd/MM/yyyy').format(DobControler).toString()}";
      AddressControler.text = widget.umodel.address;
      TelephoneControler.text = widget.umodel.telephone;

      if (widget.umodel.gender == "Male") {
        _gender = 1;
      } else {
        _gender = 2;
      }
    });
  }

  Future setprofilepic() async {
    if (widget.umodel.imageUrl != "") {
      imageUrl = widget.umodel.imageUrl;
      setState(() {
        imageUrl = widget.umodel.imageUrl;
      });
    } else {
      setState(() {
        imageUrl = "https://source.unsplash.com/random/?face";
      });
    }

    // print(imageUrl);
  }

  Future selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final temporaryfile = File(result.files.single.path.toString());
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: temporaryfile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.purple.shade400,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
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

  Widget profileurl() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.transparent,
    );
  }

  Widget profilelocal() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.transparent,
      child: Image.file(singlefile),
    );
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
      fileUrl = widget.umodel.imageUrl;
      // previewtextvisibile = true;
      isheaderfilled = true;
      showheaderlocal = false;
      showheaderurl = true;
    });

    // print(finalheaderurl);
  }

  Future synccategoryheader() async {
    if (widget.umodel.imageUrl != "") {
      setState(() {
        isheaderfilled = true;
        fileUrl = widget.umodel.imageUrl;
        showimage = widget.umodel.imageUrl;
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

  Future Upload_ProfilePic() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (singlefile != "") {
        final extention_split =
            singlefile.toString().split('.').last.replaceAll("'", "");
        // print(extention_split);
        final imagename = "profilePicture.$extention_split";
        // print(imagename);

        //   final filepath =
        //   singlefile.toString().replaceAll("File:", "").replaceAll("'","").trim();
        // final file = File(filepath);
        //   // print("File path = $filepath");
        final Folder = "${widget.umodel.userId}";
        final path = 'Profile/${Folder}/${imagename}';
        final ref = FirebaseStorage.instance.ref().child(path);
        final UploadTask uploadTask = ref.putFile(singlefile);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // print(taskSnapshot);
        final url = await taskSnapshot.ref.getDownloadURL();
        fileUrl = url;
        // print(fileUrl);

        setState(() {
          fileUrl = url;
        });
      } else {
        setState(() {
          fileUrl = "";
        });
      }
      // return filesUrl;
    } catch (e) {
      // print(e);
    }
  }

  Future Update_Profile() async {
    await Upload_ProfilePic();

    final firestore =
        FirebaseFirestore.instance.collection('users').doc(widget.umodel.DocID);

    try {
      final user = user_model(
          widget.umodel.userId,
          widget.umodel.DocID,
          widget.umodel.role,
          widget.umodel.created,
          widget.umodel.lastlogin,
          NidnControler.text,
          widget.umodel.email,
          NameControler.text,
          _valueGender,
          PobControler.text,
          DobControler,
          AddressControler.text,
          TelephoneControler.text,
          fileUrl);
      final jsonu = user.toJson();
      await firestore.update(jsonu);
      setState(() {
        NameControler.clear();
        EmailControler.clear();
        RoleControler.clear();
        // LastLoginControler.clear();
        NidnControler.clear();
        GenderControler.clear();
        PobControler.clear();
        // DobControler.clear();
        AddressControler.clear();
        TelephoneControler.clear();
      });

      Navigator.pop(context);
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "Update Profile Succes",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on FirebaseException catch (e) {
      // print(e);
    }
  }
}
