import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'viewPatientProfile.dart';

class PastAppointments extends StatelessWidget {
  final String doctorId;
  PastAppointments({this.doctorId});

  Future<List<QueryDocumentSnapshot>> getPastAppointments(doctorId) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('bookings')
        .where('docID', isEqualTo: doctorId)
        .orderBy('datetime', descending: true)
        .get();
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("All Appointments"),
        backgroundColor: LightColor.purple,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getPastAppointments(doctorId),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPatientProfile(
                                    apptDetails[index]['pID'], doctorId)));
                      },
                      child: Container(
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
                            apptDetails[index]['patient_name'],
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
                            ],
                          ),
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
