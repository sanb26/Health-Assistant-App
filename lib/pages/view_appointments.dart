import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/confirm_cancellation.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:intl/intl.dart';

class ViewAppointments extends StatefulWidget {
  final String uid;
  ViewAppointments(this.uid);
  @override
  _ViewAppointmentsState createState() => _ViewAppointmentsState(uid);
}

class _ViewAppointmentsState extends State<ViewAppointments> {
  final df = DateFormat('dd MM yyyy');
  final String uid;
  _ViewAppointmentsState(this.uid);

  Future<List<QueryDocumentSnapshot>> getAllAppointments(uid) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('bookings')
        .where('pID', isEqualTo: uid)
        .get();
    return qs.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Your Appointments"),
        backgroundColor: LightColor.purple,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getAllAppointments(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var apptDetails = snapshot.data;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
            itemCount: apptDetails.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: DateTime.now().isBefore(DateTime.parse(
                            apptDetails[index]['year'] +
                                apptDetails[index]['month'] +
                                apptDetails[index]['date']))
                        ? Colors.greenAccent[200]
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  // tileColor: DateTime.now().isBefore(DateTime.parse(
                  //         apptDetails[index]['year'] +
                  //             apptDetails[index]['month'] +
                  //             apptDetails[index]['date']))
                  //     ? Colors.greenAccent[200]
                  //     : Colors.grey,
                  title: Text(
                    apptDetails[index]['doctor_name'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Time: " +
                              apptDetails[index]['start_time'] +
                              " to " +
                              apptDetails[index]['end_time'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Date: " +
                              apptDetails[index]['date'] +
                              "/" +
                              apptDetails[index]['month'] +
                              "/" +
                              apptDetails[index]['year'] +
                              ", " +
                              apptDetails[index]['day'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DateTime.now().isBefore(DateTime.parse(
                                  apptDetails[index]['year'] +
                                      apptDetails[index]['month'] +
                                      apptDetails[index]['date']))
                              ? ButtonTheme(
                                  height: 45,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmCancel(apptDetails[index], apptDetails[index].id)));
                                    },
                                    child: Text(
                                      "Cancel Appointment",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text("Appointment already done"),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
