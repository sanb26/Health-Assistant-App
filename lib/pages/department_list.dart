import 'package:flutter/material.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'departmentPage.dart';

class DepartmentList extends StatelessWidget {
  final String uid;
  DepartmentList(this.uid);
  static List departmentNames = [
    "pulmonologist",
    "physician",
    "dermatologist",
    "neurologist",
    "orthopedist",
    "general surgery"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Departments"),
        backgroundColor: LightColor.purple,
      ),
      body: Container(
          child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(departmentNames[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => departmentDoctors(
                        departmentName: departmentNames[index], pID: uid),
                  ));
            },
          );
        },
      )),
    );
  }
}
