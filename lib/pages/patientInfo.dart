import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';                        //google fonts
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:health_assistant/pages/homepagePatient.dart';



class InfoForm extends StatefulWidget {
  @override
  final String uid;
  InfoForm({Key key, @required this.uid}) : super(key: key);

  _InfoFormState createState() => _InfoFormState(uid);
}

class _InfoFormState extends State<InfoForm> {

  final String uid;
  _InfoFormState(this.uid);

  String fname, lname, phoneNo, address, dob;
  TextEditingController intialdateval = TextEditingController();
  GlobalKey<FormState> pformkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff2f3f7),
        body: SingleChildScrollView(
              child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:[Color(0xFF33D9B2), Color(0xFF218C74)],
                    begin:Alignment.topLeft,
                    end:Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(70),bottomRight: const Radius.circular(70)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:40),
                  Center(child: _title(),),
                  _patientInfoFormContainer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }//build

  Widget _title(){
    return RichText(
      //textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Enter your details',
        style: GoogleFonts.portLligatSans(
          fontSize: MediaQuery.of(context).size.height / 20,
          fontWeight: FontWeight.w700,
          color: Colors.grey[850],
          
        ),
      ),
    );
  }  //_title widget

  Widget _patientInfoFormContainer(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
            key: pformkey,
            child: Column(
              children: [
                _buildFnameRow(),
                _buildLnameRow(),
                _buildAddressRow(),
                _buildPhoneNoRow(),
                _buildDOBRow(),
                _buildSubmitButton()
              ],
            ),
          ),
        ],
      ),
    );
  } //_ _patientInfoFormContainer


  Widget _buildFnameRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator:RequiredValidator(errorText: "This field is required"),
        onChanged: (value) {
          setState(() {
            fname = value;
          });
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
            labelText: 'First name',
            labelStyle: GoogleFonts.lato(color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildLnameRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator:RequiredValidator(errorText: "This field is required"),
        onChanged: (value) {
          setState(() {
            lname = value;
          });
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
            labelText: 'Last name',
            labelStyle: GoogleFonts.lato(color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildAddressRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: MultiValidator([
          RequiredValidator(errorText: "This field is required"),
          MaxLengthValidator(25, errorText: "Max length 25"),
        ]),
        onChanged: (value) {
          setState(() {
            address = value;
          });
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
            labelText: 'Address',
            labelStyle: GoogleFonts.lato(color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildPhoneNoRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: MultiValidator([
          RequiredValidator(errorText: "This field is required"),
          MinLengthValidator(10, errorText: "Invalid number"),
          MaxLengthValidator(10, errorText: "Invalid number"),
        ]),
        onChanged: (value) {
          setState(() {
            phoneNo = value;
          });
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
            labelText: 'Phone Number',
            labelStyle: GoogleFonts.lato(color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildDOBRow() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        readOnly: true,
        onTap: (){
          showDatePicker(
            context: context, 
            initialDate: DateTime.now(), 
            firstDate:  DateTime(1900), 
            lastDate: DateTime(2022)
            ).then((value) {
              setState(() {
                intialdateval.text = value.toString();
                dob = value.toString().substring(0, 10);
                print("hey the date is");
                print(dob);
              });
            });
        },

        //validator:RequiredValidator(errorText: "This field is required"),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: Color(0xFF33D9B2) )),
            labelText: 'Date of birth',
            labelStyle: GoogleFonts.lato(color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: submit,
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
          "Submit",
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1.0,
            fontSize: MediaQuery.of(context).size.height / 40,
            ),
          ),
        ),
      );
    }

  void submit() {
    //validating
    if (pformkey.currentState.validate()) {
      pformkey.currentState.save();
      print(fname);
      print(lname);
      print(address);
      print(phoneNo);
      print(dob);
      addPatient().then((value){
        if (value == true){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PatientScreen(uid: uid),
              ));         
        }
      });
    }

    
  }

  CollectionReference patients = FirebaseFirestore.instance.collection('patients');


  Future<bool> addPatient() async {
    try {
      patients
      .doc(uid)
      .set({
        'fname': fname,
        'lname': lname,
        'address': address,
        'phoneNo': phoneNo,
        'dob':dob
      });
      print("Patient Added");
      return true;
    } 
    catch (error) {
      print("Failed to add user: $error");
      return false;
    }
}

}