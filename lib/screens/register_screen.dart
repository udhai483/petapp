import 'dart:ui' show FontWeight, Radius;
import 'package:flutter/material.dart';
import 'package:PetApp/colors.dart';
import 'package:PetApp/screens/home_screen.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(heigth);
    print(width);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        bgRegister,
                        height: heigth * 0.40,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        height: heigth * 0.40,
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              stops: [0.3, 0.9],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.white]),
                        ),
                        //  color: Colors.lightBlueAccent.withOpacity(0.3),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                appName,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                              ),
                              Text(slogan, style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20),
                    child: Container(
                      child: Text(
                        "  $registerString",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.2),
                              Colors.transparent
                            ],
                          ),
                          border: Border(
                              left: BorderSide(color: primaryColor, width: 5))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (email) {
                        if (email.isEmpty)
                          return "please Enter Email";
                        else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)) return "Invalid Emailaddress";
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          prefixIcon: Icon(Icons.email, color: primaryColor),
                          labelText: "EMAIL ADDRESS",
                          labelStyle:
                              TextStyle(color: primaryColor, fontSize: 16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: TextFormField(
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (password) {
                        if (password.isEmpty)
                          return "please Enter Password";
                        else if (password.length < 8 || password.length > 15)
                          return "Password length is incorrect";
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          prefixIcon:
                              Icon(Icons.lock_open, color: primaryColor),
                          labelText: "PASSWORD",
                          labelStyle:
                              TextStyle(color: primaryColor, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: SizedBox(
                          height: heigth * 0.08,
                          width: width - 30,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: primaryColor,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                if (_email == "test@gmail.com" &&
                                    _password == "root@123") {
                                  FocusScope.of(context).unfocus();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                } else {
                                  print("Invalid login Details");
                                }
                              }
                            },
                            child: Text(
                              "Register Account",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login Account",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 16)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
