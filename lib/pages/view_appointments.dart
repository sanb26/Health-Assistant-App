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
        .orderBy('datetime', descending: true)
        // .orderBy('date' + 'month' + 'year')
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
          return apptDetails.length == 0
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        Image.asset("assets/8.png"),
                        Text(
                          "No appointments to display :/",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                  itemCount: apptDetails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(4, 4),
                            blurRadius: 10,
                            color: LightColor.grey.withOpacity(.2),
                          ),
                          BoxShadow(
                            offset: Offset(-3, 0),
                            blurRadius: 15,
                            color: LightColor.grey.withOpacity(.1),
                          )
                        ],
                        color: DateTime.now().isBefore(DateTime.parse(
                                    apptDetails[index]['year'] +
                                        apptDetails[index]['month'] +
                                        apptDetails[index]['date'])
                                .subtract(const Duration(days: 0)))
                            ? Colors.white
                            : Colors.grey[350],
                      ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DateTime.now().isBefore(DateTime.parse(
                                            apptDetails[index]['year'] +
                                                apptDetails[index]['month'] +
                                                apptDetails[index]['date'])
                                        .subtract(const Duration(hours: 1)))
                                    ? ButtonTheme(
                                        height: 45,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Colors.red[400],
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConfirmCancel(
                                                            apptDetails[index],
                                                            apptDetails[index]
                                                                .id)));
                                          },
                                          child: Text(
                                            "Cancel Appointment",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Text("No Actions Available"),
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
