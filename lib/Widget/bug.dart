import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';

class Bug extends StatefulWidget {
  const Bug({Key? key}) : super(key: key);

  @override
  State<Bug> createState() => _BugState();
}

class _BugState extends State<Bug> {
  var _NameControler = TextEditingController();
  var _NimControler = TextEditingController();

  void launchTelegram() async {
    String url = "https://t.me/bhanolia";
    // print("launchingUrl: $url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    _NameControler.text = "Paras Taufani";
    _NimControler.text = "18.11.0028";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Bug Report"),
          ),
          drawer: DrawerUser(),
          body: Center(
            child: Container(
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage: NetworkImage(
                        "https://source.unsplash.com/random/?snow"),
                    backgroundColor: Colors.transparent,
                  ),
                  Divider(
                    color: Colors.transparent,
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
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    enableInteractiveSelection: false,
                    controller: _NameControler,
                    style: TextStyle(color: Colors.white),
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
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      labelText: 'Nim',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    enableInteractiveSelection: false,
                    controller: _NimControler,
                    style: TextStyle(color: Colors.white),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Text(
                    "Send message about bug via telegram",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              launchTelegram();
            },
            child: const Icon(
              Icons.send,
              color: Colors.black,
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
          return true;
        });
  }
}
