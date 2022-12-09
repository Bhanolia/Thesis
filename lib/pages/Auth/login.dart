import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/pages/Auth/ForgotPassword.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  bool _secureText = true;
  late final FontWeight? fontWeight;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // @override
  // void dispose() {
  //   emailControler.dispose();
  //   passwordControler.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      // child: CircleAvatar(
      //   backgroundColor: Colors.transparent,
      //   radius: 48.0,
      child: Image.asset('assets/images/login crop.png'),
      // ),
    );
    final headline = Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
    final emaill = TextFormField(
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
    );
    final passwordd = TextFormField(
      controller: passwordControler,
      obscureText: _secureText,
      autovalidateMode: AutovalidateMode.always,
      onFieldSubmitted: (signin) {
        Signin();
      },
      validator: (password) {
        if (password == null || password.isEmpty) {
          // ignore: missing_return,
          return "Please insert password";
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
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
        suffixIcon: IconButton(
          onPressed: showHide,
          icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
    final loginButton = MaterialButton(
      color: Colors.purple.shade400,
      onPressed: Signin,
      child: Text("Sign In"),
      textColor: Colors.white,
    );
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                color: Colors.white,
                child: ListView(shrinkWrap: true, children: <Widget>[
                  // logo,
                  // SizedBox(height: 40.0),
                  headline,
                  emaill,
                  SizedBox(height: 8.0),
                  passwordd,
                  SizedBox(height: 24.0),
                  loginButton,
                  // forgotLabel
                  GestureDetector(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    onTap: () {
                      // print("Forgot Password Pressed");
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new forgotPassword()));
                    },
                  ),
                ]),
              ),
            )),
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            //show snackbar
            final snack = SnackBar(
              content: Text('Press Back button again to Exit'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return false;
          } else {
            return true;
          }
        });
  }

  Future Signin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailControler.text.trim(),
        password: passwordControler.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // // print('No user found for that email.');
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        // // print('Wrong password provided for that user.');
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
