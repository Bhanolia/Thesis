import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager/main.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/Notification/Notification.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  bool _secureText = true;

  late String _valueRole = "User";
  int _Role = 2;
  var previewbackground = Colors.purple;

  @override
  void initState() {
    sync();
    super.initState();
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 55;
    final headline = Text(
      "Sign Up",
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
        } else if (email != null && !EmailValidator.validate(email)) {
          return "Enter Valid Email";
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
      onFieldSubmitted: (signUp) {
        SignUp();
      },
      validator: (password) {
        if (password == null || password.isEmpty) {
          // ignore: missing_return,
          return "Please insert password";
        } else if (password != null && password.length < 6) {
          // ignore: missing_return,
          return "Enter min. 6 characters";
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

    final role = Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.purple.shade400)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.45),
              // height: 70,
              // color: Colors.purple,
              width: width * 0.45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                      activeColor: previewbackground,
                      value: 1,
                      groupValue: _Role,
                      onChanged: (value) {
                        setState(() {
                          _Role = int.parse(value.toString());
                          _valueRole = "Admin";
                          // print(_valueRole);
                        });
                      }),
                  Text(
                    "Admin",
                    // style: TextStyle(color: previewbackground),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _Role = 1;
                _valueRole = ("Admin");
                // print(_valueRole);
              });
            },
          ),
          GestureDetector(
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.45),
              // height: 70,
              // color: Colors.purple,
              width: width * 0.45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                      activeColor: previewbackground,
                      value: 2,
                      groupValue: _Role,
                      onChanged: (value) {
                        setState(() {
                          _Role = int.parse(value.toString());
                          _valueRole = ("User");
                          // print(_valueRole);
                        });
                      }),
                  Text(
                    "User",
                    // style: TextStyle(color: previewbackground),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _Role = 2;
                _valueRole = ("User");
                // print(_valueRole);
              });
            },
          ),
        ],
      ),
    );

    final loginButton = MaterialButton(
      color: Colors.purple.shade400,
      onPressed: SignUp,
      child: Text("Sign Up"),
      textColor: Colors.white,
    );
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
                child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              color: Colors.white,
              child: ListView(shrinkWrap: true,
                  // padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    // logo,
                    // SizedBox(height: 40.0),
                    headline,
                    Divider(color: Colors.transparent),
                    emaill,
                    Divider(color: Colors.transparent),
                    role,
                    Divider(color: Colors.transparent),
                    passwordd,
                    Divider(color: Colors.transparent),
                    SizedBox(height: 24.0),
                    loginButton,
                    // forgotLabel
                  ]),
            ))),
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

  Future SignUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    if (_valueRole == "Role") {
      _valueRole = "User";
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailControler.text.trim(),
        password: passwordControler.text.trim(),
      );
      final firestore = FirebaseFirestore.instance.collection('users').doc();
      final user = user_model(
          "",
          firestore.id,
          _valueRole,
          DateTime.now(),
          DateTime.now(),
          "",
          emailControler.text.trim(),
          "",
          "",
          "",
          DateTime.now(),
          "",
          "",
          "");
      final jsonu = user.toJson();
      await firestore.set(jsonu);
      setState(() {
        emailControler.clear();
        passwordControler.clear();
      });

      Fluttertoast.showToast(
          msg: "Adding User Succes",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        Fluttertoast.showToast(
            msg: "The password provided is too weak ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        // // print('The account already exists for that email.');
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future sync() async {
    setState(() {
      passwordControler.text = "amikom123";
    });
  }
}
