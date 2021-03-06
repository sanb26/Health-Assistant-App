import 'package:flutter/material.dart';
import 'package:health_assistant/pages/UpdateProfile.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:health_assistant/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';

class PatientProfile extends StatefulWidget {
  final String pID;
  PatientProfile(this.pID);
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  Future<DocumentSnapshot> getPatient(pID) async {
    var data =
        await FirebaseFirestore.instance.collection('patients').doc(pID).get();
    return data;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  void initState() {
    super.initState();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPatient(widget.pID),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var patientData = snapshot.data;
          print(patientData);

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [LightColor.purple, LightColor.purpleLight],
                        ),
                      ),
                      child: Column(children: [
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              Navigator.pop(context);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateUserProfile(widget.pID)),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        CircleAvatar(
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(user.photoURL),
                          ))),
                          radius: 65.0,
                          // backgroundImage: NetworkImage(),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(patientData['fname'] + ' ' + patientData['lname'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        )
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(
                          child: Card(
                              margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                              child: Container(
                                  width: 310.0,
                                  height: 290.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Information",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey[300],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: LightColor.purple,
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Gender",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  patientData['gender'],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: LightColor.purple,
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Contact Number",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  patientData['phoneNo'],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.home,
                                              color: LightColor.purple,
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Address",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  patientData['address'],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: LightColor.purple,
                                              size: 35,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Date Of Birth",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  patientData['dob'],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))),
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.45,
                  left: 20.0,
                  right: 20.0,
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            Text(
                              'Height',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              patientData['height'],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        )),
                        Container(
                          child: Column(children: [
                            Text(
                              'Weight',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              patientData['weight'],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )
                          ]),
                        ),
                        Container(
                            child: Column(
                          children: [
                            Text(
                              'Age',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              patientData['age'],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  )))
            ],
          );
        },
      ),
    );
  }
}
