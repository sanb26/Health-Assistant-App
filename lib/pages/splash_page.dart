import 'package:flutter/material.dart';
import 'package:health_assistant/pages/sign_in.dart';
// import 'package:health_assistant/pages/homePagePatient.dart';
// import 'package:health_assistant/pages/homePageDoctor.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:health_assistant/theme/text_styles.dart';
import 'package:health_assistant/theme/extention.dart';

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Text(
                "Virtual Health Assistant",
                style: TextStyles.h1Style.white,
              ),
              SizedBox(height: 20),
              Text(
                "Springfield Hospital",
                style: TextStyles.h1Style.white,
              ),
              Text(
                "Ghatkopar, Mumbai",
                style: TextStyles.h1Style.white,
              ),
              Expanded(
                flex: 7,
                child: SizedBox(),
              ),
            ],
          ).alignTopCenter,
        ],
      ),
    );
  }
}
