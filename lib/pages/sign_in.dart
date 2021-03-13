import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';                        //google fonts
import 'package:flutter_signin_button/flutter_signin_button.dart';      //google sign in button
import 'package:form_field_validator/form_field_validator.dart';        //form validtaion
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:health_assistant/pages/homepagePatient.dart';
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



  void login() {
    //validating
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      //calling signin with email and password function which returns user if sign in successful else null
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PatientScreen(uid: value.uid),
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
          children:[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:[Color(0xFF33D9B2), Color(0xFF218C74)],
                  begin:Alignment.topLeft,
                  end:Alignment.bottomRight, 
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
                  Center(child: _title(),),
                  _loginContainer(),                  
              ],
            ),
         ],
        ),
      ),
    );
  } //build


  Widget _title(){
    return RichText(
      //textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Health Assistant',
        style: GoogleFonts.portLligatSans(
          fontSize: MediaQuery.of(context).size.height / 20,
          fontWeight: FontWeight.w700,
          color: Colors.grey[850],
          
        ),
      ),
    );
  }

  Widget _loginContainer(){
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
                SizedBox(height:10),
                 _buildLoginButton(),
              ],
            ),
          ),
                             
          SizedBox(height:30),
          _buildOrRow(),
          SizedBox(height:20),
          SignInButton(
            Buttons.Google,
            onPressed:() => googleSignIn().whenComplete(() async{
              User user =  FirebaseAuth.instance.currentUser;
              bool val = await checkIfDocExists(user.uid);
              if(val){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PatientScreen(uid: user.uid)));
              }
              else{
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InfoForm(uid: user.uid)));
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
              color: Color(0xFF33D9B2),
            ),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
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
              _securePass? Icons.visibility: Icons.visibility_off,
              color: Color(0xFF33D9B2),
            ),
            onPressed:(){
              setState(() {
                _securePass = !_securePass;
              });
            }),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
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
                  colors:[Color(0xFF33D9B2), Color(0xFF218C74)],
                  begin:Alignment.centerLeft,
                  end:Alignment.centerRight, 
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

  Widget _buildOrRow(){
    return Row(
      children: [
        Expanded(
            child: Divider(
          thickness: 2,
        )),
        Text(' or ', style: GoogleFonts.lato(fontSize:MediaQuery.of(context).size.height / 50 )),
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
      var collectionRef =  FirebaseFirestore.instance.collection('patients');
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } 
    catch (e) {
      return false;
    }
}


}
