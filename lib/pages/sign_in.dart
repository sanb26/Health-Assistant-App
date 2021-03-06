import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts
import 'package:flutter_signin_button/flutter_signin_button.dart'; //google sign in button
import 'package:form_field_validator/form_field_validator.dart'; //form validtaion
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/theme/light_color.dart';
// import 'package:health_assistant/theme/text_styles.dart';
// import 'package:health_assistant/theme/extention.dart';

import 'package:health_assistant/pages/homePagePatient.dart';
import 'package:health_assistant/pages/homePageDoctor.dart';
import 'package:health_assistant/pages/patientInfo.dart';
import '../controllers/authentication.dart';

class SignIn extends StatefulWidget {
  final mainColor = Color(0xff2470c7);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email, password;
  bool _securePass = true;
  //bool _isLoading = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() async {
    //validating
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      //calling signin with email and password function which returns user if sign in successful else null
      signin(email, password, context).then((value) async {
        if (value == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Invalid Credentials"),
                  backgroundColor: Colors.red[300],
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.red,
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } //passing doc id
        if (value != null) {
          var doctorData = await DatabaseManager().getDoctorDetails(value.uid);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorHomeScreen(
                    docId: value.uid,
                    name: doctorData['name']), // TODO: Route to Homepage
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [LightColor.purpleLight, LightColor.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: _title(),
                ),
                _loginContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  } //build

  Widget _title() {
    return RichText(
      //textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Health Assistant',
        style: GoogleFonts.portLligatSans(
          fontSize: MediaQuery.of(context).size.height / 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _loginContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(top: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formkey,
            child: Column(
              children: [
                _buildEmailRow(),
                _buildPasswordRow(),
                SizedBox(height: 10),
                _buildLoginButton(),
              ],
            ),
          ),
          SizedBox(height: 30),
          _buildOrRow(),
          SizedBox(height: 20),
          SignInButton(
            Buttons.Google,
            onPressed: () => googleSignIn().whenComplete(() async {
              User user = FirebaseAuth.instance.currentUser;
              bool val = await checkIfDocExists(user.uid);
              DocumentSnapshot userData = await getUserInfo(user.uid);
              if (val && userData.exists) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PatientHomeScreen(
                        uid: user.uid,
                        lname: userData.data()['lname'],
                        fname: userData.data()['fname'])));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => InfoForm(uid: user.uid)));
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: MultiValidator([
          RequiredValidator(errorText: "This field is required"),
          EmailValidator(errorText: "Invalid email address"),
        ]),
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: LightColor.purple,
          ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'E-mail',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: RequiredValidator(errorText: "This field is required"),
        obscureText: _securePass,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
              icon: Icon(
                _securePass ? Icons.visibility : Icons.visibility_off,
                color: LightColor.purple,
              ),
              onPressed: () {
                setState(() {
                  _securePass = !_securePass;
                });
              }),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Password',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return RaisedButton(
      onPressed: login,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        height: 1.4 * (MediaQuery.of(context).size.height / 20),
        width: 5 * (MediaQuery.of(context).size.width / 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [LightColor.purpleLight, LightColor.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Text(
          "Login",
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1.0,
            fontSize: MediaQuery.of(context).size.height / 40,
          ),
        ),
      ),
    );
  }

  Widget _buildOrRow() {
    return Row(
      children: [
        Expanded(
            child: Divider(
          thickness: 2,
        )),
        Text(' or ',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 50)),
        Expanded(
            child: Divider(
          thickness: 2,
        )),
      ],
    );
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
}
