import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';                        //google fonts

class PatientScreen extends StatefulWidget {
  @override

  final String uid;
  PatientScreen({Key key, @required this.uid}) : super(key: key);

  _PatientScreenState createState() => _PatientScreenState(uid);
}

class _PatientScreenState extends State<PatientScreen> {

  final String uid;
  _PatientScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Welcome patient !!")),
    );
  }
}

