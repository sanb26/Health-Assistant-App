import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/chatbot/home.dart';
import 'package:health_assistant/controllers/authentication.dart';
import 'package:health_assistant/pages/PatientProfile.dart';
import 'package:health_assistant/pages/departmentPage.dart';
import 'package:health_assistant/pages/department_list.dart';
import 'package:health_assistant/pages/view_appointments.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'sign_in.dart';
import 'package:google_fonts/google_fonts.dart'; //google fonts

class PatientHomeScreen extends StatefulWidget {
  final String uid;
  final String fname;
  final String lname;
  PatientHomeScreen({Key key, @required this.uid, this.lname, this.fname})
      : super(key: key);

  @override
  _PatientHomeScreenState createState() =>
      _PatientHomeScreenState(uid, fname, lname);
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final String fname;
  final String lname;
  final String uid;

  _PatientHomeScreenState(this.uid, this.fname, this.lname);
  DocumentSnapshot userData;

  @override
  void initState() {
    print(fname);
    print(lname);
    super.initState();
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
                text: "\n$fname $lname\n\n",
                style: GoogleFonts.lato(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w700))
          ],
        ),
      ),
      // title: Text(
      //   "Hello, " + fname + " " + lname,
      //   style: TextStyle(color: Colors.black),
      // ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: LightColor.purple,
            size: MediaQuery.of(context).size.height / 22,
          ),
          onPressed: () => showSearch(context: context, delegate: DataSearch())
              .then((searchResult) async {
            if (searchResult != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => departmentDoctors(
                        departmentName: searchResult, pID: uid),
                  ));
            }
          }),
        ),
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

  Widget _servicesButton(String title, String subtitle,
      {Color color, Color lightColor}) {
    return InkWell(
      onTap: () {
        print("tapped");
        if (subtitle == "chatbot") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatHome(uid)),
          );
        } else if (subtitle == "book_appt") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DepartmentList(uid)),
          );
        } else if (subtitle == "view_appt") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewAppointments(uid)),
          );
        } else if (subtitle == "profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientProfile(uid)),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.89,
        height: (MediaQuery.of(context).size.width * 0.89) / 4.5,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 25),
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
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Center(
                  child: Text(title,
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height / 40,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // PreferredSize(
          //     preferredSize:
          //         Size.fromHeight(MediaQuery.of(context).size.height / 15),
          _appBar(),
      backgroundColor: Color(0xFFFFFFFF),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                _servicesButton("Get Help From Our Chatbot", "chatbot",
                    color: LightColor.green, lightColor: LightColor.lightGreen),
                _servicesButton("View Appointments", "view_appt",
                    color: LightColor.skyBlue,
                    lightColor: LightColor.lightBlue),
                _servicesButton("Schedule a New Appointment", "book_appt",
                    color: LightColor.orange,
                    lightColor: LightColor.lightOrange),
                _servicesButton("Profile & Settings", "profile",
                    color: LightColor.green, lightColor: LightColor.lightGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List departments = [
    "pulmonologist",
    "physician",
    "dermatologist",
    "neurologist",
    "orthopedist",
    "general surgery"
  ];

  final recentDepartmentSearch = [
    "pulmonologist",
    "physician",
    "dermatologist",
    "neurologist",
    "orthopedist",
    "general surgery"
  ];

  final searchFieldLabel = "Search by department";

  String result;

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for search bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the search bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some result based on suggestion
    final searchedList =
        departments.where((x) => x.startsWith(query.toLowerCase())).toList();
    return searchedList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No Results Found...",
              style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.height / 45,
                  color: Colors.black),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                result = searchedList[index];
                close(context, result);
              },
              leading: Transform.rotate(
                  angle: 120 * math.pi / 180, child: Icon(Icons.arrow_back)),
              title: RichText(
                text: TextSpan(
                  text: searchedList[index].substring(0, query.length),
                  style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height / 45,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: searchedList[index].substring(query.length),
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height / 45,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: searchedList.length,
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final userInputList = query.isEmpty
        ? recentDepartmentSearch
        : departments.where((x) => x.startsWith(query.toLowerCase())).toList();

    return userInputList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No Results Found...",
              style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.height / 45,
                  color: Colors.black),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = userInputList[index];
                showResults(context);
              },
              leading: Transform.rotate(
                  angle: 120 * math.pi / 180, child: Icon(Icons.arrow_back)),
              title: RichText(
                text: TextSpan(
                  text: userInputList[index].substring(0, query.length),
                  style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height / 45,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: userInputList[index].substring(query.length),
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height / 45,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: userInputList.length,
          );
  }
}
