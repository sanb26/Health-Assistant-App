import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/pages/doctorDetailPage.dart';
import 'package:health_assistant/theme/light_color.dart';

// ignore: camel_case_types
class departmentDoctors extends StatefulWidget {
  final String departmentName;
  final String pID;
  departmentDoctors(
      {Key key, @required this.departmentName, @required this.pID})
      : super(key: key);
  @override
  _departmentDoctorsState createState() =>
      _departmentDoctorsState(departmentName, pID);
}

// ignore: camel_case_types
class _departmentDoctorsState extends State<departmentDoctors> {
  String departmentName;
  String pID;
  _departmentDoctorsState(this.departmentName, this.pID);

  List departDocList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDepartmentDocList();
  }

  fetchDepartmentDocList() async {
    dynamic resultant =
        await DatabaseManager().getDepartDoctorsList(departmentName);

    if (resultant == null) {
      print('Unable to retrieve the doctors list');
    } else {
      setState(() {
        departDocList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.purple,
        title: Text("Department: " +
            departmentName[0].toUpperCase() +
            departmentName.substring(1)),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: departDocList.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.94,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.white70,
                  elevation: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          child: Container(
                            height: MediaQuery.of(context).size.width / 5,
                            width: MediaQuery.of(context).size.width / 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: LightColor.grey,
                            ),
                            child: Image.network(
                              departDocList[index]['profile_image'],
                              height: 50,
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                departDocList[index]['name'],
                                style: GoogleFonts.lato(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                departDocList[index]['degree'],
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            50),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => doctorDetail(
                                            doctorId: departDocList[index]
                                                ['id'],
                                            pID: pID,
                                          ))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
