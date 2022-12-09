import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Future permision() async {
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var release = androidInfo.version.release;
  var sdkInt = androidInfo.version.sdkInt;
  var manufacturer = androidInfo.manufacturer;
  var model = androidInfo.model;
  // print('Android $release (SDK $sdkInt), $manufacturer $model');
  var status = await Permission.storage.status;
  var manage = await Permission.manageExternalStorage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  } else if (status.isDenied) {
    SystemNavigator.pop();
  } else {
    // print("Permisision granted");
  }
  if (sdkInt! >= 29) {
    if (!manage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  } else if (manage.isDenied) {
    SystemNavigator.pop();
  } else {
    // print("Permisision granted");
  }
}

Future<String> createFolderParent() async {
  await permision();
  final folderName = "Files";
  final FolderParent = "manager";
  final PathPaternt = Directory("storage/emulated/0/$FolderParent");
  final PathFolder = Directory("storage/emulated/0/$FolderParent/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await PathPaternt.exists())) {
    // print("$PathPaternt Already Exists");

    return PathPaternt.path;
  } else {
    // print("Creating $PathPaternt");
    PathPaternt.create();
    return PathPaternt.path;
  }
}

Future<String> createFolderchild() async {
  await createFolderParent();

  final folderName = "Files";
  final FolderParent = "manager";
  final PathPaternt = Directory("storage/emulated/0/$FolderParent");
  final PathFolder = Directory("storage/emulated/0/$FolderParent/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await PathFolder.exists())) {
    // print("$PathFolder Already Exists");

    return PathFolder.path;
  } else {
    // print("Creating $PathFolder");
    await createFolderParent();
    PathFolder.create();
    return PathFolder.path;
  }
}
