import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/theme/light_color.dart';

class ViewAppointments extends StatefulWidget {
  final String uid;
  ViewAppointments(this.uid);
  @override
  _ViewAppointmentsState createState() => _ViewAppointmentsState(uid);
}

class _ViewAppointmentsState extends State<ViewAppointments> {
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
            itemCount: apptDetails.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(apptDetails[index]['start_time']),
                subtitle: Text(apptDetails[index]['end_time']),
              );
            },
          );
        },
      ),
    );
  }
}
