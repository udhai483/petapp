import 'package:PetApp/screens/home_screen.dart';
import 'package:PetApp/screens/drawer_screen.dart';
import 'package:PetApp/screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(fontFamily: 'Circular'),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            DrawerScreen(),
            HomeScreen(),
          ],
        ),
      ),
    );
  }
}
