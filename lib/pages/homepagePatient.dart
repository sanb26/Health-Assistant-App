import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/chatbot/home.dart';
import 'package:health_assistant/model/dactor_model.dart';
import 'package:health_assistant/model/data.dart';
//import 'package:health_assistant/pages/AppointmentPage.dart';
import 'package:health_assistant/theme/extention.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:health_assistant/theme/text_styles.dart';
import 'package:health_assistant/theme/theme.dart';

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

/*
  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      /*leading: Icon(
        Icons.short_text,
        size: 30,
        color: Colors.black,
      ), */
      actions: <Widget>[
        /*Icon(
          Icons.notifications_none,
          size: 30,
          color: LightColor.grey,
        ), */
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Container(
            // height: 40,
            // width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Image.asset("assets/user.png", fit: BoxFit.fill),
          ),
        ).p(8),
      ],
    );
  }
*/
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("$fname $lname", style: TextStyles.h1Style),
      ],
    ).p16;
  }

  Widget _searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.8),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(Icons.search, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {}, borderRadius: BorderRadius.circular(13))),
        ),
      ),
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
        // getData();
        // print(userData.data());
        if (subtitle == "chatbot") {
          // AppointmentPage();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatHome()),
          );
        }
      },
      // behavior: HitTestBehavior.translucent,
      // onTap: () {
      //   print(subtitle);
      //   print("tapped");
      // },
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

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20),
                _header(),
                _searchField(),
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
