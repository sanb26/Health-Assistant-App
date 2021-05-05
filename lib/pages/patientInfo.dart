import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:health_assistant/theme/light_color.dart';
// import 'package:health_assistant/theme/text_styles.dart';
// import 'package:health_assistant/theme/theme.dart';

import 'package:health_assistant/pages/homePagePatient.dart';

class InfoForm extends StatefulWidget {
  @override
  final String uid;
  InfoForm({Key key, @required this.uid}) : super(key: key);

  _InfoFormState createState() => _InfoFormState(uid);
}

class _InfoFormState extends State<InfoForm> {
  final String uid;
  _InfoFormState(this.uid);
  String fname, lname, phoneNo, address, dob, height, weight, age, gender;
  String dropdownValue = "";
  TextEditingController intialdateval = TextEditingController();
  GlobalKey<FormState> pformkey = GlobalKey<FormState>();

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'This field is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  String validateAge(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is required";
    } else if (int.parse(value) <= 18)
      return "Age should be greater than 18";
    else if (!regExp.hasMatch(value)) {
      return "Age cannot contain characters other than numbers.";
    }
    return null;
  }

  String validateHeight(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is required";
    } else if (int.parse(value) > 300 || int.parse(value) <= 0)
      return "Height must be between 0 and 300 cms";
    else if (!regExp.hasMatch(value)) {
      return "Height should be a whole number.";
    }
    return null;
  }

  String validateWeight(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is required";
    } else if (int.parse(value) > 200 || int.parse(value) <= 0)
      return "Weight must be between 1 and 200 kgs";
    else if (!regExp.hasMatch(value)) {
      return "Weight should be a whole number.";
    }
    return null;
  }

  RegExp regExp = new RegExp(
    r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$",
    caseSensitive: true,
    multiLine: false,
  );

//method to calculate age on Today (in years)
  int ageCalculate(String input) {
    if (regExp.hasMatch(input)) {
      DateTime _dateTime = DateTime(
        int.parse(input.substring(6)),
        int.parse(input.substring(3, 5)),
        int.parse(input.substring(0, 2)),
      );
      return DateTime.fromMillisecondsSinceEpoch(
                  DateTime.now().difference(_dateTime).inMilliseconds)
              .year -
          1970;
    } else {
      return -1;
    }
  }

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
                    colors: [LightColor.purpleLight, LightColor.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: _title(),
                  ),
                  _patientInfoFormContainer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } //build

  Widget _title() {
    return RichText(
      //textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Enter your details',
        style: GoogleFonts.portLligatSans(
          fontSize: MediaQuery.of(context).size.height / 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  } //_title widget

  Widget _patientInfoFormContainer() {
    return Container(
      //height: MediaQuery.of(context).size.height * 1.1,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(top: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: pformkey,
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildFnameRow(),
                _buildLnameRow(),
                _buildAddressRow(),
                _buildPhoneNoRow(validateMobile),
                _buildDOBRow(),
                _buildHeight(validateHeight),
                _buildWeight(validateWeight),
                _buildAge(validateAge),
                _buildGender(),
                _buildSubmitButton(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  } //_ _patientInfoFormContainer

  Widget _buildFnameRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: RequiredValidator(errorText: "This field is required"),
        onChanged: (value) {
          setState(() {
            fname = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
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
        validator: RequiredValidator(errorText: "This field is required"),
        onChanged: (value) {
          setState(() {
            lname = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
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
          MaxLengthValidator(50, errorText: "Max length 50"),
        ]),
        onChanged: (value) {
          setState(() {
            address = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Address',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPhoneNoRow(String Function(String) validator) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: validator,
        onChanged: (value) {
          setState(() {
            phoneNo = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
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
        controller: intialdateval,
        onTap: () async {
          DateTime date = DateTime(1900);
          final f = new DateFormat('dd-MM-yyyy');
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          intialdateval.text = f.format(date).toString();
          setState(() {
            dob = f.format(date).toString();
            print("hey the date is");
            print(dob);
            int age = ageCalculate(dob);
            print("Calculated age is" + age.toString());
          });
        },
        //validator:RequiredValidator(errorText: "This field is required"),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Date of birth',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildHeight(String Function(String) validator) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: validator,
        onChanged: (value) {
          setState(() {
            height = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Height (cm)',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildWeight(String Function(String) validator) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: validator,
        onChanged: (value) {
          setState(() {
            weight = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Weight (kg)',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildAge(String Function(String) validator) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: validator,
        onChanged: (value) {
          setState(() {
            age = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Age',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGender() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColor.purple)),
          labelText: 'Gender',
          labelStyle: GoogleFonts.lato(color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            // itemHeight: 75,
            value: gender,
            onChanged: (String newValue) {
              setState(() {
                gender = newValue;
              });
            },
            items: <String>['Male', 'Female', 'Prefer not to say']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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
            colors: [LightColor.purpleLight, LightColor.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
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
      addPatient().then((value) {
        if (value == true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientHomeScreen(uid: uid, lname: lname, fname: fname),
              ));
        }
      });
    }
  }

  CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');

  Future<bool> addPatient() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    try {
      patients.doc(uid).set({
        'fname': fname,
        'lname': lname,
        'address': address,
        'phoneNo': phoneNo,
        'dob': dob,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'photo_url': user.photoURL,
      });
      print("Patient Added");
      return true;
    } catch (error) {
      print("Failed to add user: $error");
      return false;
    }
  }
}
