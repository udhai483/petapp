import 'dart:io';

import 'package:PetApp/configuration.dart';
import 'package:PetApp/widgets/pet_categories.dart';
import 'package:PetApp/widgets/pet_category_display.dart';
import 'package:PetApp/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool showDrawer = false;
  bool showPopup = false;
  File image;
  String name;
  List petsDetails = [];
  String selectedPet = 'Puppies';

  getPets(selected) async {
    print(selected);
    petsDetails = [];
    await FirebaseFirestore.instance
        .collection('Dogs')
        .doc(selected.toString().toLowerCase())
        .get()
        .then((element) {
      petsDetails = element['petsDetails'];
    }).catchError((e) {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (showDrawer) {
          setState(() {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
            showDrawer = false;
          });
        }
      },
      child: Stack(children: [
        AnimatedContainer(
          duration: Duration(
            milliseconds: 250,
          ),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(showDrawer ? -0.2 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: showDrawer
                ? BorderRadius.circular(40)
                : BorderRadius.circular(0),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: showDrawer
                              ? Icon(CupertinoIcons.chevron_left)
                              : Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              if (!showDrawer) {
                                xOffset = size.width * 0.6; //280;
                                yOffset = size.height / 5;
                                scaleFactor = 0.6;
                                showDrawer = true;
                              } else {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                showDrawer = false;
                              }
                            });
                          }),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: primaryGreen,
                                size: 16,
                              ),
                              // Text('Hello'),
                              RichText(
                                text: TextSpan(
                                    text: 'Colombo, ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: 'Sri Lanka',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('images/profile.jpg'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SearchBar(
                  func1: (String val, File img) {
                    setState(() {
                      image = img;
                      name = val;
                      showPopup = true;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                PetCategories(
                  func: (val) {
                    setState(() {
                      selectedPet = val;
                    });
                  },
                ),
                FutureBuilder(
                  future: getPets(selectedPet),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return PetCategoryDisplay(
                        petList: petsDetails,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Visibility(
            visible: showPopup,
            child: Container(
              color: Colors.black45,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Spacer(),
                    Material(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        width: MediaQuery.of(context).size.width * 0.8,
                        //height: MediaQuery.of(context).size.height * 0.8,
                        child: image == null
                            ? SizedBox()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                          // Appropriate logging or analytics, e.g.
                                          // myAnalytics.recordError(
                                          //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                          //   exception,
                                          //   stackTrace,
                                          // );
                                          return const Text('😢');
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        showPopup = false;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          backgroundColor: Colors.grey[200]),
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Spacer(),
                  ])),
            ))
      ]),
    );
  }
}
