import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/pages/appointment.dart';
import 'package:health_assistant/theme/light_color.dart';
// import 'package:http/http.dart';

// ignore: camel_case_types
class doctorDetail extends StatefulWidget {
  final String pID;
  final String doctorId;
  doctorDetail({Key key, @required this.doctorId, @required this.pID})
      : super(key: key);
  @override
  _doctorDetailState createState() => _doctorDetailState(doctorId, pID);
}

// ignore: camel_case_types
class _doctorDetailState extends State<doctorDetail> {
  String doctorId;
  String pID;
  Map<String, dynamic> docDetails;

  _doctorDetailState(this.doctorId, this.pID);

  fetchDocDetails() async {
    var resultant = await DatabaseManager().getDoctorDetails(doctorId);
    if (resultant == null) {
      print('Unable to retrieve the doctors list');
    } else {
      // setState(() {
      //   docDetails = resultant;
      // });
      return resultant;
    }
  }

  Future<List<QueryDocumentSnapshot>> getScheduleInfo(docId) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)
        .collection('Schedule')
        .get();

    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: fetchDocDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        var docDetails = snapshot.data;
        print(docDetails['name']);
        print(docDetails['degree']);
        print(docDetails['experience']);
        print(docDetails['consultationFee']);
        print(docDetails['description']);

        return FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getScheduleInfo(doctorId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            var scheduleDetails = snapshot.data;
            print(scheduleDetails[0].data());
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: LightColor.purple,
                title: Text(docDetails['type']),
              ),
              body: SafeArea(
                  child: Stack(
                children: [
                  Image.network(docDetails['profile_image'],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain),
                  DraggableScrollableSheet(
                      maxChildSize: .8,
                      initialChildSize: .5,
                      minChildSize: .5,
                      builder: (context, scrollController) {
                        return Container(
                          height: MediaQuery.of(context).size.height * .5,
                          padding:
                              EdgeInsets.only(left: 19, right: 19, top: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(docDetails['name'],
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        fontWeight: FontWeight.bold)),
                                Text(docDetails['degree'],
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                42,
                                        color: LightColor.subTitleTextColor)),
                                Text(
                                    docDetails['experience'].toString() +
                                        " years of experience\n",
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                42,
                                        color: LightColor.subTitleTextColor)),
                                Text("About",
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        fontWeight: FontWeight.bold)),
                                Text(docDetails['description'],
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                42,
                                        color: LightColor.lightblack)),
                                SizedBox(height: 20),
                                Text("Consultation Fee",
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "??? " +
                                        docDetails['consultationFee']
                                            .toString(),
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                42,
                                        color: LightColor.lightblack)),
                                SizedBox(height: 20),
                                Text("Schedule",
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        fontWeight: FontWeight.bold)),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: scheduleDetails.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: ListTile(
                                        title: Text(
                                          scheduleDetails[index].data()['day'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                42,
                                          ),
                                        ),
                                        subtitle: Text(
                                            scheduleDetails[index]
                                                    .data()['in_time'] +
                                                " to " +
                                                scheduleDetails[index]
                                                    .data()['out_time'],
                                            style: GoogleFonts.lato(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    42,
                                                color: LightColor
                                                    .subTitleTextColor)),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: ButtonTheme(
                                    height: 45,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: LightColor.purple,
                                        child: Text("Book Appointment",
                                            style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppointmentPage(
                                                          doctorId, pID)));
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             DoctorSchedule(doctorId)));
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              )),
            );
          },
        );
      },
    );
  }
}
