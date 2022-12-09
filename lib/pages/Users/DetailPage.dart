import 'package:flutter/material.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/User_Model.dart';
import 'package:intl/intl.dart';

class detailpage extends StatelessWidget {
  final user_model umodel;

  const detailpage({Key? key, required this.umodel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text(umodel.email),
      ),
      drawer: DrawerUser(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(umodel.email),
            // Text(umodel.password),
            Text(umodel.userId),
            Text(
                "${DateFormat('MM/dd/yyyy').format(umodel.created).toString()}"),
          ],
        ),
      ),
    );
  }
}
