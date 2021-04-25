import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_assistant/pages/sign_in.dart';
// import 'package:health_assistant/pages/homePagePatient.dart';
// import 'package:health_assistant/pages/homePageDoctor.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:health_assistant/theme/text_styles.dart';
import 'package:health_assistant/theme/extention.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_assistant/pages/homepagePatient.dart';
import 'package:health_assistant/pages/sign_in.dart';
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

/*Future.delayed(Duration(seconds: 2)).then((_) {
Navigator.pushReplacement(
context, MaterialPageRoute(builder: (_) => SignIn()));
}); */

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  static Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('patients');
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Function to return User Information
  Future<DocumentSnapshot> getUserInfo(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var qs = await firestore.collection('patients').doc(uid).get();
    if (qs.exists) {
      return qs;
    } else {
      return null;
    }
  }
  void startTimer() {
    Timer(Duration(seconds: 1), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  void navigateUser() async{
    if (FirebaseAuth.instance.currentUser != null) {
      User user = FirebaseAuth.instance.currentUser;
      print("Logged in!!");
      bool val = await checkIfDocExists(user.uid);
      DocumentSnapshot userData = await getUserInfo(user.uid);
      if (val && userData.exists) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PatientHomeScreen(
                uid: user.uid,
                lname: userData.data()['lname'],
                fname: userData.data()['fname'])));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                //image: DecorationImage(
                //image: AssetImage("assets/doctor_face.jpg"),
                //fit: BoxFit.fill,
                ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: .6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [LightColor.purpleExtraLight, LightColor.purple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Image.asset(
                  "assets/heartbeat.png",
                  color: Colors.white,
                  height: 100,
                ),
                Center(
                  child: Text(
                    "Virtual Health Assistant",
                    style: GoogleFonts.portLligatSans(
                      fontSize: MediaQuery.of(context).size.height / 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                       
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Springfield Hospital",
                  style: GoogleFonts.portLligatSans(
                    fontSize: MediaQuery.of(context).size.height / 20,
                    fontWeight: FontWeight.w700,
                     color: Colors.white,
                  ),
                ),
                Text(
                  "Ghatkopar, Mumbai",
                  style: GoogleFonts.portLligatSans(
                    fontSize: MediaQuery.of(context).size.height / 20,
                    fontWeight: FontWeight.w700,
                     color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: SizedBox(),
                ),
              ],
            ).alignTopCenter,
          ),
        ],
      ),
    );
  }
}
