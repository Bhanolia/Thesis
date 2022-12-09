import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager/pages/home.dart';

class email_verification extends StatefulWidget {
  const email_verification({Key? key}) : super(key: key);

  @override
  State<email_verification> createState() => _email_verificationState();
}

class _email_verificationState extends State<email_verification> {
  bool _isemailVerified = false;
  Timer? timer;
  bool cansendemail = false;

  @override
  void initState() {
    super.initState();
    _isemailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isemailVerified) {
      SendVerification();

      timer = Timer.periodic(Duration(seconds: 5), (_) {
        CheckEmailVerification();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future SendVerification() async {
    try {
      final curentuser = FirebaseAuth.instance.currentUser!;
      await curentuser.sendEmailVerification();
      // print("Sending Email.....");

      setState(() {
        cansendemail = false;
      });
      await Future.delayed(Duration(seconds: 60));
      setState(() {
        cansendemail = true;
      });
    } on Exception catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }

  Future CheckEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isemailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isemailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => _isemailVerified
      ? Home()
      : Scaffold(
          backgroundColor: Colors.purple.shade400,
          body: Center(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ListView(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Check your email inbox or spam for verification your email aderess",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Text(
                      "Resend Email",
                      style: TextStyle(color: Colors.purple.shade400),
                    ),
                    onPressed: () {
                      // print("Resent Email Pressed");
                      if (cansendemail == true) {
                        SendVerification();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: AlertDialog(
                                  content: Text(
                                    "You Press To Fast, Pelase Wait A Minute",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.purple.shade400),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                  MaterialButton(
                      // color: Colors.white,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // print("Sign Out ....");
                        FirebaseAuth.instance.signOut();
                      }),
                ],
              ),
            ),
          ),
        );
}
