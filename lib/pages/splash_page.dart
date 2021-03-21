import 'package:flutter/material.dart';
import 'package:health_assistant/pages/sign_in.dart';
// import 'package:health_assistant/pages/homePagePatient.dart';
// import 'package:health_assistant/pages/homePageDoctor.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:health_assistant/theme/text_styles.dart';
import 'package:health_assistant/theme/extention.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SignIn()));
    });
    super.initState();
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
