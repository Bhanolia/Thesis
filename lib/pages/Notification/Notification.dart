import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:manager/model/Token_Model.dart';

// String? _token;
final String Main_Token =
    "AAAAWogtzIc:APA91bHLsWaXIK0gmjoaY3WKK19AHTooW3NvZ0lJGYvFVIfZP_LqLzzrOcSZeKmx9xO8m9V_rvepq35D1ultua4ANNN7grNkzMyoNmCM3XEQPqV-xiQ_ypA4zv3tQecGLn37WnsKQSm7";

List _token = [];
late String Uploader;
//Firebase
Future getToken() async {
  final firestore =
      await FirebaseFirestore.instance.collection("Fcm_Token").get();
  _token =
      List.from(firestore.docs.map((e) => token_model.fromSnapshot(e).token))
          .toList();
  // print(_token);
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

  if (Uploader == "") {
    Uploader = role;
  }
  // print(Uploader);
}

Future Send_Announcement() async {
  await getToken();
  await getRole();
  if (_token.length == null || _token.isEmpty) {
    // print("List Empty");
  }
  String constructFCMPayload() {
    Map data = {
      "registration_ids": _token,
      "notification": {
        "body": "Uploaded By $Uploader",
        "title": "New Announcement Academic"
      }
    };
    // print(jsonEncode(data));
    return jsonEncode(data);
  }

  if (_token == null) {
    // print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    // print('FCM trying');

    var sentt = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $Main_Token",
      },
      body: constructFCMPayload(),
    );
    // print(sentt.statusCode);
    // print(sentt.reasonPhrase);
    // print('FCM request for device sent!');
  } catch (e) {
    // print(e);
  }
}

Future Send_Archive() async {
  await getToken();
  await getRole();
  if (_token.length == null || _token.isEmpty) {
    // print("List Empty");
  }
  String constructFCMPayload() {
    Map data = {
      "registration_ids": _token,
      "notification": {
        "body": "Uploaded By $Uploader",
        "title": "New Announcement Non-Academic"
      }
    };
    // print(jsonEncode(data));
    return jsonEncode(data);
  }

  if (_token == null) {
    // print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    // print('FCM trying');

    var sentt = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $Main_Token",
      },
      body: constructFCMPayload(),
    );
    // print(sentt.statusCode);
    // print(sentt.reasonPhrase);
    // print('FCM request for device sent!');
  } catch (e) {
    // print(e);
  }
}
