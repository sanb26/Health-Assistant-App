import 'package:flutter/material.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'departmentPage.dart';

class DepartmentList extends StatelessWidget {
  final String uid;
  DepartmentList(this.uid);
  static List departmentNames = [
    "Pulmonologist",
    "Physician",
    "Dermatologist",
    "Neurologist",
    "Orthopedist",
    "Surgeon"
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
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(departmentNames[index]),
            onTap: () {
              Navigator.pushReplacement(
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
