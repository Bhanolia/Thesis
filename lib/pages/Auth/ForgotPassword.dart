import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final emailControler = TextEditingController();

  Future resetpassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailControler.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Reset Password Link Sent! Check Your Email",
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            );
          });

      setState(() {
        emailControler.clear();
      });
    } on FirebaseAuthException catch (e) {
      // print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Reset Password"),
      ),
      backgroundColor: Colors.purple.shade400,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: emailControler,
                // keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    // ignore: missing_return,
                    return "Please insert email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.purple),
                  isDense: true,
                  fillColor: Colors.blue.shade100,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.purple),
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              MaterialButton(
                  color: Colors.purple.shade400,
                  textColor: Colors.white,
                  child: Text("Reset Password"),
                  onPressed: () {
                    resetpassword();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
