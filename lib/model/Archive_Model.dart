import 'package:manager/pages/announcement/announcement.dart';

class Archive_Model {
  String Id;
  String Categories;
  String Tittle;
  String Description;
  DateTime Date_Creation;
  String Uploader;
  String Header;
  List Attachment;

  Archive_Model(
    this.Id,
    this.Categories,
    this.Tittle,
    this.Description,
    this.Date_Creation,
    this.Uploader,
    this.Header,
    this.Attachment,
  );

  Map<String, dynamic> toJson() => {
        "Id": Id,
        "Categories": Categories,
        "Tittle": Tittle,
        "Description": Description,
        "Date_Creation": Date_Creation,
        "Uploader": Uploader,
        "Header": Header,
        "Attachment": Attachment,
      };

  Archive_Model.fromSnapshot(snapshot)
      : Id = snapshot.data()['Id'],
        Categories = snapshot.data()['Categories'],
        Tittle = snapshot.data()['Tittle'],
        Description = snapshot.data()['Description'],
        Date_Creation = snapshot.data()['Date_Creation'].toDate(),
        Uploader = snapshot.data()['Uploader'],
        Header = snapshot.data()['Header'],
        Attachment = snapshot.data()['Attachment'];
}
