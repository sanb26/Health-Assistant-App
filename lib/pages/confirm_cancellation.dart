// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/theme/light_color.dart';

class ConfirmCancel extends StatelessWidget {
  changeBookingStatus(doctorID, day, startTime, endTime) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorID)
        .collection('Schedule')
        .doc(day)
        .collection('Timeslots')
        .where('start_time', isEqualTo: startTime)
        .limit(1)
        .get();
    var slotID = data.docs[0].id;
    print("SLOT ID:");
    print(slotID);
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorID)
        .collection('Schedule')
        .doc(day)
        .collection('Timeslots')
        .doc(slotID)
        .update({'booked': false});
  }

  void cancelAppointment(bookingId) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
  }

  final String docID;
  final appointmentDetails;
  ConfirmCancel(this.appointmentDetails, this.docID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.purple,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              "Are you sure you want to cancel the appointment?",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: LightColor.purple,
                    ),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 85,
                            ),
                            Text(
                              "Doctor",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("Time", style: TextStyle(fontSize: 20)),
                            Text("Date", style: TextStyle(fontSize: 20))
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 85,
                            ),
                            Text(appointmentDetails['doctor_name'],
                                style: TextStyle(fontSize: 20)),
                            Text(
                                appointmentDetails['start_time'] +
                                    " to " +
                                    appointmentDetails['end_time'],
                                style: TextStyle(fontSize: 20)),
                            Text(
                                appointmentDetails['date'] +
                                    "/" +
                                    appointmentDetails['month'] +
                                    "/" +
                                    appointmentDetails['year'] +
                                    ", " +
                                    appointmentDetails['day'],
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                cancelAppointment(docID);
                changeBookingStatus(
                    appointmentDetails['docID'],
                    appointmentDetails['day'],
                    appointmentDetails['start_time'],
                    appointmentDetails['end_time']);
                Navigator.pop(context);
              },
              child: Text("Cancel Appointment"),
            )
          ],
        ),
      ),
    );
  }
}
