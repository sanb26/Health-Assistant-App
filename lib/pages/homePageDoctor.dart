import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/controllers/authentication.dart';
import 'package:health_assistant/pages/sign_in.dart';
import 'package:health_assistant/pages/view_app_doctor.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:intl/intl.dart';

class DoctorHomeScreen extends StatefulWidget {
  final String docId;
  final String name;
  DoctorHomeScreen({Key key, @required this.docId, @required this.name}): super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState(docId, name);
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final String docId;
  final String name;
  //List todaysAppoint = [];

  _DoctorHomeScreenState(this.docId, this.name);


  fetchTodaysAppointments() async {
    var resultant = await DatabaseManager().getTodaysAppointment(docId);
    if (resultant == null) {
      print('Unable to retrieve todays appointments');
    } else {
      //todaysAppoint = resultant;
      //print("doctor home page todays appointments");
      //print(resultant);
      return resultant;
    }
  }
  
  Widget _servicesButton(String title,String subtitle,{Color color, Color lightColor}){
    return InkWell(
      onTap: () {
        print("helloooooooo");
        if(subtitle == "view_appt"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewAppDoc(docId: docId,)),
          );
        }
      },
      child: Container(
        width:MediaQuery.of(context).size.width*0.89,
        height: (MediaQuery.of(context).size.width*0.89)/4.5,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(backgroundColor: lightColor,radius: 60,),
                ),
                Center(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(fontSize:MediaQuery.of(context).size.height / 40, color: Colors.white)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      //shadowColor:LightColor.purple,
      title: RichText(
        text: TextSpan(
          text: '\n\nHello,',
          style: GoogleFonts.lato(
              fontSize: 22, color: LightColor.subTitleTextColor),
          children: [
            TextSpan(
                text: "\n$name\n\n",
                style: GoogleFonts.lato(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w700))
          ],
        ),
      ),

      actions: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.redAccent,
            size: MediaQuery.of(context).size.height / 22,
          ),
          onPressed: () async {
            if (await signOutUser()) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SignIn()));
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: fetchTodaysAppointments(),
      builder:(context, snapshot){
        if(!snapshot.hasData){
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        var todaysAppoint = snapshot.data;
        return Scaffold(
          appBar: _appBar(),
          backgroundColor: Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height:20),
                _servicesButton("View Appointments","view_appt",color: LightColor.green, lightColor: LightColor.lightGreen),
                _servicesButton("View Profile","profile", color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
                SizedBox(height:40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Appointments",
                      style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/30,fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.sort),
                  ],
                ),
                SizedBox(height: 20),
                todaysAppoint.isEmpty?
                Center(child: Text("No appointments today.",  style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/40))):
                Expanded(
                  child: ListView.builder(
                    itemCount: todaysAppoint.length,
                    itemBuilder: (context, index){
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        ),
                        child: ListTile(
                          title: Text(todaysAppoint[index]['patient_name']),
                          subtitle: Text(todaysAppoint[index]['start_time']+" "+todaysAppoint[index]['end_time']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      } 
    ); //FutureBuilder
  }
}