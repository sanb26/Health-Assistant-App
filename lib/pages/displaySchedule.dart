import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorSchedule extends StatefulWidget {
  final String docID;
  DoctorSchedule(this.docID);
  @override
  _DoctorScheduleState createState() => _DoctorScheduleState(docID);
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  final String docID;
  var formatter = new DateFormat('EEEE, d MMM, yyyy');
  _DoctorScheduleState(this.docID);

  Future<List<QueryDocumentSnapshot>> getDoctorDetails(docId) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)
        .collection('Schedule')
        .get();
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getDoctorDetails(docID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var scheduleData = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Today is:"),
                  Text(formatter
                      .format(DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day))
                      .toString()),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: scheduleData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(scheduleData[index].data()['day']),
                      subtitle: Text("In time: " +
                          scheduleData[index].data()['intime'] +
                          "\n" +
                          "Out time: " +
                          scheduleData[index].data()['outtime']),
                      onTap: () {},
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
