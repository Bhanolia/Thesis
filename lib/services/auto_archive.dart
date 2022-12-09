import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/model/Archive_Model.dart';

Future autoarchive(String Roles) async {
  DateTime limit;
  DateTime start;
  // final datetimecompare;

  if (Roles == "Admin") {
    final Announcement =
        await FirebaseFirestore.instance.collection("Announcement").get();

    Announcement.docs.forEach((element) async {
      start = (element.data()['Date_Creation'] as Timestamp).toDate();
      limit = start.add(Duration(days: 30));
      final datetimecompare = limit.isBefore(DateTime.now());
      // print("Compare Value $datetimecompare");
      // print("Date Start $start");
      // print("Date Limit $limit");
      if (datetimecompare == true) {
        final anouncement = Announcement_Model.fromSnapshot(element);
        final archive = await FirebaseFirestore.instance
            .collection("Archive")
            .doc(anouncement.Id);
        final addarchive = Archive_Model(
            anouncement.Id,
            anouncement.Categories,
            anouncement.Tittle,
            anouncement.Description,
            anouncement.Date_Creation,
            anouncement.Uploader,
            anouncement.Header,
            anouncement.Attachment);
        try {
          await archive.set(addarchive.toJson());
          // print("Move Announcement to Archive Sccess");
          await FirebaseFirestore.instance
              .collection("Announcement")
              .doc(anouncement.Id)
              .delete();
          // print("delete old announcement success");
        } on FirebaseException catch (e) {
          // print(e.toString());
        }
      }
    });
    // print(Roles);
  } else {
    // print(Roles);
    // print("Not Authorized");
  }
}
