// import 'dart:js_util';
import 'package:health_assistant/theme/light_color.dart';
import 'package:nice_button/nice_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    print("This is the booking ID");
    print(bookingId);
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
  }

  Future<List<String>> sendCancelNotificationToDoctor(docID) async {
    List<String> fetchedTokens = [];
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docID)
        .collection('tokens')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        fetchedTokens.add(element.data()['FCM_token']);
      });
    });
    return fetchedTokens;
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      List<String> userToken,
      String patientName,
      String day,
      String date,
      String month,
      String year,
      String startTime,
      String endTime) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": tokens,
      "collapse_key": "type_a",
      "notification": {
        "title": 'Appointment is Cancelled',
        "body":
            "$patientName has cancelled the appointment scheduled for $date/$month/$year, $day from $startTime to $endTime",
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': globals.serverKey // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  List<String> tokens = [];
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
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 20.0),
              alignment: Alignment.center,
              child: Text(
                "Appointment Details",
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
                              leading: Icon(Icons.account_box),
                              title: Text("Doctor"),
                              subtitle: Text(
                                appointmentDetails['doctor_name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.timer),
                              title: Text("Time"),
                              subtitle: Text(
                                  appointmentDetails['start_time'] +
                                      " to " +
                                      appointmentDetails['end_time'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text("Date"),
                              subtitle: Text(
                                  appointmentDetails['date'] +
                                      "/" +
                                      appointmentDetails['month'] +
                                      "/" +
                                      appointmentDetails['year'] +
                                      ", " +
                                      appointmentDetails['day'],
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
              text: "Confirm Cancellation",
              background: Colors.red,
              onPressed: () async {
                cancelAppointment(docID);
                changeBookingStatus(
                    appointmentDetails['docID'],
                    appointmentDetails['day'],
                    appointmentDetails['start_time'],
                    appointmentDetails['end_time']);
                print(appointmentDetails['docID']);
                tokens = await sendCancelNotificationToDoctor(
                    appointmentDetails['docID']);
                print("Fetched Doctor FCM tokens");
                print(tokens);
                callOnFcmApiSendPushNotifications(
                  tokens,
                  appointmentDetails['patient_name'],
                  appointmentDetails['day'],
                  appointmentDetails['date'],
                  appointmentDetails['month'],
                  appointmentDetails['year'],
                  appointmentDetails['start_time'],
                  appointmentDetails['end_time'],
                );
                print("Made http request to send notification");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // body: Container(
      //   child: Column(
      //     children: [
      //       Text(
      //         "Are you sure you want to cancel the appointment?",
      //         style: TextStyle(fontSize: 22),
      //         textAlign: TextAlign.center,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 20),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(20),
      //                 color: LightColor.purple,
      //               ),
      //               height: MediaQuery.of(context).size.height / 3,
      //               width: MediaQuery.of(context).size.width / 1.25,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Column(
      //                     children: [
      //                       SizedBox(
      //                         height: 85,
      //                       ),
      //                       Text(
      //                         "Doctor",
      //                         style: TextStyle(fontSize: 20),
      //                       ),
      //                       Text("Time", style: TextStyle(fontSize: 20)),
      //                       Text("Date", style: TextStyle(fontSize: 20))
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     width: 10,
      //                   ),
      //                   Column(
      //                     children: [
      //                       SizedBox(
      //                         height: 85,
      //                       ),
      //                       Text(appointmentDetails['doctor_name'],
      //                           style: TextStyle(fontSize: 20)),
      //                       Text(
      //                           appointmentDetails['start_time'] +
      //                               " to " +
      //                               appointmentDetails['end_time'],
      //                           style: TextStyle(fontSize: 20)),
      //                       Text(
      //                           appointmentDetails['date'] +
      //                               "/" +
      //                               appointmentDetails['month'] +
      //                               "/" +
      //                               appointmentDetails['year'] +
      //                               ", " +
      //                               appointmentDetails['day'],
      //                           style: TextStyle(fontSize: 20)),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       RaisedButton(
      //
      //         child: Text("Cancel Appointment"),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
