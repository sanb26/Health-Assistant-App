import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/homepagePatient.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:nice_button/nice_button.dart';

class ConfirmationPage extends StatefulWidget {
  final String pID;
  final String docID;
  final String day;
  final String date;
  final String month;
  final String year;
  final String startTime;
  final String endTime;
  ConfirmationPage(this.pID, this.docID, this.day, this.date, this.month,
      this.year, this.startTime, this.endTime);
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState(
      pID, docID, day, date, month, year, startTime, endTime);
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  Future getPatientName(pID) async {
    var data =
        await FirebaseFirestore.instance.collection('patients').doc(pID).get();
    names.add(data.data()['fname']);
    names.add(data.data()['lname']);
    return data.data();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatientName(pID);
  }

  final String pID;
  final String docID;
  final String day;
  final String date;
  final String month;
  final String year;
  final String startTime;
  final String endTime;
  _ConfirmationPageState(this.pID, this.docID, this.day, this.date, this.month,
      this.year, this.startTime, this.endTime);
  List names = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: LightColor.purple,
          title: Text("Booking Confirmation"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              UserInfo(pID, docID, day, date, month, year, startTime, endTime,
                  names),
              //UserInfo(),
            ],
          ),
        ));
  }
}

class UserInfo extends StatelessWidget {
  Future<DocumentSnapshot> getDocDetails(docID) {
    var data =
        FirebaseFirestore.instance.collection('doctors').doc(docID).get();
    print(data);
    return data;
  }

  static Map<int, String> numToMonth = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  final String pID;
  final String docID;
  final String day;
  final String date;
  final String month;
  final String year;
  final String startTime;
  final String endTime;
  final List names;
  UserInfo(this.pID, this.docID, this.day, this.date, this.month, this.year,
      this.startTime, this.endTime, this.names);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: getDocDetails(docID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Your booking is confirmed!",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ...ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  leading: Icon(Icons.calendar_today),
                                  title: Text("Date"),
                                  subtitle: Text(
                                    numToMonth[int.parse(month)] +
                                        " " +
                                        date +
                                        ", " +
                                        year +
                                        " " +
                                        day,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.lock),
                                  title: Text("Time"),
                                  subtitle: Text(startTime + " to " + endTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                ListTile(
                                  leading: Icon(Icons.account_box),
                                  title: Text("Doctor's Name"),
                                  subtitle: Text(snapshot.data.data()['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Type"),
                                  subtitle: Text(snapshot.data.data()['type'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                NiceButton(
                  width: 255,
                  elevation: 8.0,
                  radius: 52.0,
                  text: "Back to Home",
                  background: LightColor.purple,
                  onPressed: () {
                    print(names[0]);
                    print(names[1]);
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PatientHomeScreen(
                    //             uid: pID,
                    //             lname: names[1],
                    //             fname: names[0],
                    //           )),
                    Navigator.pop(context);
                    // );
                  },
                ),
              ],
            ),
          );
        });
  }
}
