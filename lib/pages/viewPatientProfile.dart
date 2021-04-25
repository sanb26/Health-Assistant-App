import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/globals.dart' as globals;

class ViewPatientProfile extends StatefulWidget {
  final String pID;
  final String docId;
  ViewPatientProfile(this.pID, this.docId);
  @override
  _ViewPatientProfileState createState() => _ViewPatientProfileState(docId, pID);
}

class _ViewPatientProfileState extends State<ViewPatientProfile> {

  final String docId;
  final String pID;
  _ViewPatientProfileState(this.docId, this.pID);
  Future<DocumentSnapshot> getPatient(pID) async {
    var data =
        await FirebaseFirestore.instance.collection('patients').doc(pID).get();
    return data;
  }

  fetchChatBotResults() async {
    var resultant = await DatabaseManager().getChatBotResult(docId, pID);
    if (resultant == null) {
      print('Unable to retrieve chat Results');
    } else {
      return resultant;
    }
    return resultant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.grey[200],
      body: FutureBuilder(
        future: getPatient(widget.pID),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var patientData = snapshot.data;
          //print(patientData);
          return FutureBuilder(
            future: fetchChatBotResults(),
            builder:(context, snapshot){
              if(snapshot.data == null){
                return Center(child: CircularProgressIndicator());
              }
              var chatBotResult = snapshot.data;
            return SafeArea(
              child:SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [LightColor.purple, LightColor.purpleLight],
                          ),
                        ),
                        child: Column(children: [
                        SizedBox(height: 40),
                        CircleAvatar(
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(globals.userProfileImage),
                          ))),
                          radius: 65.0,
                          // backgroundImage: NetworkImage(),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(patientData['fname'] + ' ' + patientData['lname'],
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize:MediaQuery.of(context).size.height/35,
                            )),
                        SizedBox(height: 20),
                      ]),
                      ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text("Information", 
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.height/40 ,
                                fontWeight: FontWeight.w800,),),
                                Divider(color: Colors.grey[300],),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.people,color: LightColor.purple,size: MediaQuery.of(context).size.height/30),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Gender", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/50 ,),),
                                        Text(patientData['gender'], 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/55 ,
                                          color: Colors.grey[400]),),                                     
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.line_weight,color: LightColor.purple,size: MediaQuery.of(context).size.height/30),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Height", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/50 ,),),
                                        Text(patientData['height'], 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/55 ,
                                          color: Colors.grey[400]),),                                     
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.linear_scale,color: LightColor.purple,size: MediaQuery.of(context).size.height/30),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Weight", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/50 ,),),
                                        Text(patientData['weight']+" kg", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/55 ,
                                          color: Colors.grey[400]),),                                     
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.calendar_today,color: LightColor.purple,size: MediaQuery.of(context).size.height/30),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Date Of Birth", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/50 ,),),
                                        Text(patientData['dob'], 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/55 ,
                                          color: Colors.grey[400]),),                                     
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.phone,color: LightColor.purple,size: MediaQuery.of(context).size.height/30),
                                    SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Contact Number", 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/50 ,),),
                                        Text(patientData['phoneNo'], 
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.height/55 ,
                                          color: Colors.grey[400]),),                                     
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        //height: 14,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children:[
                              Text("Predictions", 
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.height/40 ,
                                    fontWeight: FontWeight.w800,),),
                                    Divider(color: Colors.grey[300],),
                              chatBotResult.isEmpty?
                              Center(
                                child: Text("No interactions.",
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height / 40))):
                              Container(
                                height: 200,
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //color: Colors.grey[200],
                                //padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                  itemCount:chatBotResult.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        //borderRadius:BorderRadius.all(Radius.circular(10)),
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
                                      ),                           
                                      child: ListTile(
                                        title: Text(
                                          "Result: "+chatBotResult[index]['result'],
                                          style: GoogleFonts.lato(
                                            fontSize: MediaQuery.of(context).size.height/50
                                          ),
                                        ),
                                        subtitle: Text(
                                          "\nSymptoms: "+chatBotResult[index]['s1']+", "+chatBotResult[index]['s3']+", "
                                          +chatBotResult[index]['s3']+", "+chatBotResult[index]['s4']+", "
                                          +chatBotResult[index]['s5']+
                                          "\n\nDate: "+chatBotResult[index]['time'].toDate().toString().substring(0,11),
                                          style: GoogleFonts.lato(
                                            fontSize: MediaQuery.of(context).size.height/50
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            );
            });
        },
      ),
    );
  }
}




     