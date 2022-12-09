import 'package:cloud_firestore/cloud_firestore.dart';

class user_model {
  String userId;
  String DocID;
  String role;
  DateTime created;
  DateTime lastlogin;
  String nidn;
  String email;

  // String password;
  String name;
  String gender;
  String Pob;
  DateTime Dob;
  String address;
  String telephone;
  String imageUrl;

  user_model(
    this.userId,
    this.DocID,
    this.role,
    this.created,
    this.lastlogin,
    this.nidn,
    this.email,
    // this.password,
    this.name,
    this.gender,
    this.Pob,
    this.Dob,
    this.address,
    this.telephone,
    this.imageUrl,
  );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "DocID": DocID,
        "role": role,
        "created": created,
        "lastlogin": lastlogin,
        "nidn": nidn,
        "email": email,
        // "password": password,
        "name": name,
        "gender": gender,
        "Pob": Pob,
        "Dob": Dob,
        "address": address,
        "telephone": telephone,
        "imageUrl": imageUrl,
      };

  static user_model fromJson(Map<String, dynamic> json) => user_model(
        json['userId'],
        json['DocID'],
        json['role'],
        json['created'].json['created'].toDate(),
        json['lastlogin'].json['created'].toDate(),
        json['nidn'],
        json['email'],
        // "password": password,
        json['name'],
        json['gender'],
        json['Pob'],
        json['Dob'],
        json['address'],
        json['telephone'],
        json['imageUrl'],
      );

  user_model.fromSnapshot(snapshot)
      : userId = snapshot.data()['userId'],
        DocID = snapshot.data()['DocID'],
        role = snapshot.data()['role'],
        created = snapshot.data()['created'].toDate(),
        lastlogin = snapshot.data()['lastlogin'].toDate(),
        nidn = snapshot.data()['nidn'],
        email = snapshot.data()['email'],
        // password = snapshot['password'],
        name = snapshot.data()['name'],
        gender = snapshot.data()['gender'],
        Pob = snapshot.data()['Pob'],
        Dob = snapshot.data()['Dob'].toDate(),
        address = snapshot.data()['address'],
        telephone = snapshot.data()['telephone'],
        imageUrl = snapshot.data()['imageUrl'];
}
