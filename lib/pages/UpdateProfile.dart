import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/pages/PatientProfile.dart';
import 'package:health_assistant/theme/light_color.dart';

class UpdateUserProfile extends StatefulWidget {
  final String pID;
  UpdateUserProfile(this.pID);
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  String fname, lname, phoneNo, address, dob, height, weight, age, gender;
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  get value => null;

  Future<bool> updatePatient(pID) async {
    try {
      FirebaseFirestore.instance.collection('patients').doc(pID).update({
        'fname': fname,
        'lname': lname,
        'address': address,
        'phoneNo': phoneNo,
        'dob': dob,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender
      });
      print("Patient data updted");
      return true;
    } catch (error) {
      print("Failed to add user: $error");
      return false;
    }
  }

  Future<DocumentSnapshot> getPatient(pID) async {
    var data =
        await FirebaseFirestore.instance.collection('patients').doc(pID).get();
    return data;
  }

  void dispose() {
    // Clean up the controller when the widget is disxposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.purple,
        title: Text('Update Your Profile'),
      ),
      body: FutureBuilder(
        future: getPatient(widget.pID),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var patientData = snapshot.data;
          print(patientData);
          fname = patientData['fname'];
          lname = patientData['lname'];
          address = patientData['address'];
          age = patientData['age'];
          dob = patientData['dob'];
          gender = patientData['gender'];
          height = patientData['height'];
          weight = patientData['weight'];
          phoneNo = patientData['phoneNo'];
          SizedBox(
            height: 100,
          );
          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue:
                            patientData['fname'] + " " + patientData['lname'],
                        onChanged: (value) {
                          fname = value.split(" ").first;
                          lname = value.split(" ").last;
                          //lname=value[1];
                        },
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your name',
                          //labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: patientData['phoneNo'],
                        onChanged: (value) {
                          phoneNo = value;
                          print(phoneNo);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.phone),
                          //hintText: patientData['fname'],
                          labelText: 'Phone',
                        ),
                      ),
                      TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(),
                        initialValue: patientData['dob'],
                        onChanged: (value) {
                          dob = value;
                          print(dob);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Enter your date of birth',
                          labelText: 'Date Of Birth',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: patientData['height'],
                        onChanged: (value) {
                          height = value;
                          //print(phoneNo);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your height',
                          labelText: 'Height',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: patientData['weight'],
                        onChanged: (value) {
                          weight = value;
                          //print(phoneNo);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.line_weight),
                          hintText: 'Enter your weight',
                          labelText: 'Weight',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: patientData['age'],
                        onChanged: (value) {
                          age = value;
                          //print(phoneNo);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.web_asset),
                          hintText: 'Enter your age',
                          labelText: 'Age',
                        ),
                      ),
                      TextFormField(
                        initialValue: patientData['address'],
                        onChanged: (value) {
                          address = value;
                          print(phoneNo);
                        },
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.add_location),
                          hintText: 'Enter your address',
                          labelText: 'Address',
                        ),
                      ),
                      new Container(
                          padding:
                              const EdgeInsets.only(left: 150.0, top: 40.0),
                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: LightColor.purple,
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              updatePatient(widget.pID);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PatientProfile(widget.pID),
                                  ));
                              // Navigator.pop(context);
                              // );
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
