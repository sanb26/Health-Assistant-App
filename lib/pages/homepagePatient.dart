import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/chatbot/home.dart';
import 'package:health_assistant/controllers/authentication.dart';
import 'package:health_assistant/model/dactor_model.dart';
import 'package:health_assistant/model/data.dart';
import 'package:health_assistant/pages/departmentPage.dart';
import 'package:health_assistant/theme/extention.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:health_assistant/theme/text_styles.dart';
import 'package:health_assistant/theme/theme.dart';
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
  List<DoctorModel> doctorDataList;
  DocumentSnapshot userData;

  @override
  void initState() {
    print(fname);
    print(lname);
    doctorDataList = doctorMapList.map((x) => DoctorModel.fromJson(x)).toList();
    super.initState();
  }


  Widget _appBar(){
    return AppBar(
      backgroundColor: Colors.white ,
      //shadowColor:LightColor.purple,
      title: RichText(
        text: TextSpan(
          text: '\n\nHello,',style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/50,color:LightColor.subTitleTextColor),
          children: [

            TextSpan(text:"\n$fname $lname\n\n", 
            style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/25,color: Colors.black, fontWeight: FontWeight.w700))],
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search, color: LightColor.purple, size:MediaQuery.of(context).size.height/22,), 
        onPressed: () => showSearch(context: context, delegate: DataSearch()).then((searchResult) async{
          if (searchResult != null){
            Navigator.push(context,MaterialPageRoute(builder: (context) => departmentDoctors(departmentName: searchResult),));
          }
        }),
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.redAccent, size:MediaQuery.of(context).size.height/22,), 
          onPressed: () async {
            if (await signOutUser()) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
            }
          },),
      ],
    );
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Categories", style: TextStyles.title.bold),
              /*Text(
                "See All",
                style: TextStyles.titleNormal
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8).ripple(() {}) */
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context),
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _categoryCard("Get Help From Our Chatbot", "chatbot",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _categoryCard("View Appointments", "view_appt",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _categoryCard("Schedule a New Appointment", "book_appt",
                  color: LightColor.orange, lightColor: LightColor.lightOrange),
              _categoryCard("Profile & Settings", "profile",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    //  TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      //  subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return InkWell(
      onTap: () {
        print("tapped");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatHome(uid)),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 5,
        child: Container(
          height: 280,
          width: AppTheme.fullWidth(context) * .3,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
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
                children: <Widget>[
                  Positioned(
                    top: -20,
                    left: -20,
                    child: CircleAvatar(
                      backgroundColor: lightColor,
                      radius: 60,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Text(title, style: titleStyle).hP8,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Flexible(
                      //   child: Text(
                      //     subtitle,
                      //     style: subtitleStyle,
                      //   ).hP8,
                      // ),
                    ],
                  ).p16
                ],
              ),
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/10),
        child: _appBar()
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                _category(),
              ],
            ),
          ),
          //_doctorsList()
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  List departments = ["pulmonary", "physician", "dermatologist",
  "neurologist", "orthopedic", "surgeon"];
 
  final recentDepartmentSearch = ["pulmonary", "physician"];

  final searchFieldLabel="Search by department";

  String result;

  @override
  List<Widget> buildActions(BuildContext context) {
      //actions for search bar
      return[
        IconButton(icon: Icon(Icons.clear), onPressed: (){
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
        onPressed: (){
          close(context, null);
        });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      //show some result based on suggestion
      final searchedList = departments.where((x) => x.startsWith(query.toLowerCase())).toList();
      return searchedList.isEmpty ? 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No Results Found...", style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.black),),
      ) : 
      ListView.builder(
        itemBuilder: (context, index)=>ListTile(
          onTap: (){        
            result = searchedList[index];
            close(context, result);
          },
          leading: Transform.rotate(
            angle: 120*math.pi/180,
            child: Icon(Icons.arrow_back)),
          title: RichText(
            text: TextSpan(
              text: searchedList[index].substring(0, query.length),
              style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: searchedList[index].substring(query.length),
                  style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.grey),
                ),],
            ),
          ),
        ),
        itemCount: searchedList.length,
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final userInputList = query.isEmpty ? 
                          recentDepartmentSearch : 
                          departments.where((x) => x.startsWith(query.toLowerCase())).toList();
    
    return userInputList.isEmpty ? 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("No Results Found...", style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.black),),
    ) : 
    ListView.builder(
      itemBuilder: (context, index)=>ListTile(
        onTap: (){        
          query = userInputList[index];
          showResults(context);
        },
        leading: Transform.rotate(
          angle: 120*math.pi/180,
          child: Icon(Icons.arrow_back)),
        title: RichText(
          text: TextSpan(
            text: userInputList[index].substring(0, query.length),
            style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: userInputList[index].substring(query.length),
                style: GoogleFonts.lato(fontSize: MediaQuery.of(context).size.height/45, color: Colors.grey),
              ),],
          ),
        ),
      ),
      itemCount: userInputList.length,
    );
  }

}