import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/departmentPage.dart';

class ChatHome extends StatefulWidget {
  final String uid;
  ChatHome(this.uid);
  @override
  _ChatHomeState createState() => _ChatHomeState(uid);
}

class _ChatHomeState extends State<ChatHome> {
  TextEditingController symptomController = new TextEditingController();
  final List<String> symptomlist = <String>[
    'Itching',
    'Skin Rash',
    'Nodal Skin Eruptions',
    'Continuous Sneezing',
    'Shivering',
    'Chills',
    'Joint Pain',
    'Stomach Pain',
    'Acidity',
    'Ulcers on Tongue',
    'Muscle Wasting',
    'Vomiting',
    'Burning Micturition',
    'Spotting Urination',
    'Fatigue',
    'Weight Gain',
    'Anxiety',
    'Cold hands and feet',
    'Mood Swings',
    'Weight Loss',
    'Restlessness',
    'Lethargy',
    'Patches in Throat',
    'Irregular sugar level',
    'Cough',
    'Sunken eyes',
    'Breathlessness',
    'Sweating',
    'Dehydration',
    'Indigestion',
    'Headache',
    'Yellowish skin',
    'Dark urine',
    'Nausea',
    'Loss of appetite',
    'Pain behind the eyes',
    'Back pain',
    'Constipation',
    'Abdominal pain',
    'Diarrhoea',
    'Mild fever',
    'Yellow urine',
    'Yellowing of eyes',
    'Fluid Overload',
    'Swelling of Stomach',
    'Swelled lymph nodes',
    'Malaise',
    'Blurred and distorted vision',
    'Phlegm',
    'Throat Irritation',
    'Redness of eyes',
    'Sinus pressure',
    'Runny nose',
    'Congestion',
    'Chest pain',
    'Weakness in Limbs',
    'Fast heart rate',
    'Pain during bowel movements',
    'Pain in anal region',
    'Bloody stool',
    'Irritation in anus',
    'Neck pain',
    'Dizziness',
    'Cramps',
    'Bruising',
    'Obesity',
    'Swollen legs',
    'Puffy face and eyes',
    'Enlarged thyroid',
    'Brittle nails',
    'Swollen extremeties',
    'Excessive hunger',
    'Drying and tingling lips',
    'Slurred speech',
    'Knee pain',
    'Hip joint pain',
    'Muscle Weakness',
    'Stiff neck',
    'Swelling joints',
    'Movement stiffness',
    'Spinning Movements',
    'Loss of Balance',
    'Unsteadiness',
    'Weakness of one body side',
    'Loss of smell',
    'Bladder discomfort',
    'Foul smell of urine',
    'Continuous feel of urine',
    'Passage of gases',
    'Internal itching',
    'Depression',
    'Irritability',
    'Muscle pain',
    'Red spots over body',
    'Abnormal menstruation',
    'Dischromic patches',
    'Watering from eyes',
    'Increased appetite',
    'Family History',
    'Mucoid sputum',
    'Rusty sputum',
    'Lack of concentration',
    'Visual disturbances',
    'Receiving blood transfusion',
    'Receiving unsterile injections',
    'Distention of Abdomen',
    'History of alcohol consumption',
    'Fluid overload',
    'Blood in sputum',
    'Prominent veins on calf',
    'Palpitations',
    'Painful walking',
    'Pus filled pimples',
    'Blackheads',
    'Scurring',
    'Skin peeling',
    'Silver like dusting',
    'Small dents in nails',
    'Inflammatory nails',
    'Blister',
    'Red sore around nose',
    'Yellow crust ooze'
  ]..sort();
  final String uid;
  _ChatHomeState(this.uid);
  String symptom1, symptom2, symptom3, symptom4, symptom5;
  String output;
  List<String> symptoms = [];
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: LightColor.purple,
        title: Text("Self Diagnosis"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  // SingleChildScrollView(
                  //   // fit: FlexFit.loose,
                  //   reverse: true,
                  ListView.builder(
                    reverse: true,
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Today',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Bubble(
                              message:
                                  "Hi! I'm Aeon, your very own personal diagnoser",
                              isMe: false,
                            ),
                            Bubble(
                              message:
                                  'I will help guide you to the doctor based on the symptoms you might be feeling right now.',
                              isMe: false,
                            ),
                            Bubble(
                              message:
                                  'Disclaimer: I might not be always accurate, for more information please contact your doctor as soon as possible',
                              isMe: false,
                            ),
                            Bubble(
                              message:
                                  'Please Enter 5 symptoms, for better diagnosis and accurate predictions',
                              isMe: false,
                            ),
                            for (var i in symptoms)
                              Bubble(
                                isMe: true,
                                message: i,
                              )
                          ],
                        ),
                      );
                    },
                  ),
                  // ),
                ],
              ),
            ),
            symptoms.length == 5
                ? Padding(
                    padding: EdgeInsets.fromLTRB(150, 600, 0, 0),
                    child: Container(
                        height: 50,
                        width: 100,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: LightColor.purple,
                          onPressed: () async {
                            setState(() {
                              pressed = true;
                            });
                            String s1 =
                                symptom1.replaceAll(" ", "_").toLowerCase();
                            String s2 =
                                symptom2.replaceAll(" ", "_").toLowerCase();
                            String s3 =
                                symptom3.replaceAll(" ", "_").toLowerCase();
                            String s4 =
                                symptom4.replaceAll(" ", "_").toLowerCase();
                            String s5 =
                                symptom5.replaceAll(" ", "_").toLowerCase();
                            String url =
                                "https://disease-detector.herokuapp.com/predict/" +
                                    "$s1/$s2/$s3/$s4/$s5";
                            print(url);
                            var response = await http.get(url);
                            setState(() {
                              output = response.body;
                              print(output);
                            });
                            selfDiagnosisData();
                            print("Added data to database");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => departmentDoctors(
                                          departmentName: output,
                                          pID: uid,
                                        )));
                          },
                          child: pressed
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.yellow,
                                )
                              : Text(
                                  "Predict",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                        )),
                  )
                : Positioned(
                    bottom: 90,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, 0),
                          blurRadius: 5,
                        ),
                      ]),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: symptomController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Enter Symptom',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              print("Tapped");
                              if (symptomController.text != "") {
                                setState(() {
                                  symptoms.add(symptomController.text);
                                });
                                symptomController.clear();
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              print(symptoms.length);
                              if (symptoms.length == 5) {
                                setState(() {
                                  symptom1 = symptoms[0];
                                  symptom2 = symptoms[1];
                                  symptom3 = symptoms[2];
                                  symptom4 = symptoms[3];
                                  symptom5 = symptoms[4];
                                });
                              }
                            },
                            icon: Icon(Icons.send, color: Colors.indigoAccent),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void selfDiagnosisData() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('patients').doc(widget.uid).collection('self_diagnois').add({
      "s1": symptom1,
      "s2": symptom2,
      "s3": symptom3,
      "s4": symptom4,
      "s5": symptom5,
      "result": output,
      "time": DateTime.now()
    });
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isMe ? Colors.indigoAccent : Colors.yellow,
                  // gradient: isMe
                  //     ? LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         stops: [
                  //             0.1,
                  //             1
                  //           ],
                  //         colors: [
                  //             Color(0xFFF6D365),
                  //             Color(0xFFFDA085),
                  //           ])
                  //     : LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         stops: [
                  //             0.1,
                  //             1
                  //           ],
                  //         colors: [
                  //             Color(0xFFEBF5FC),
                  //             Color(0xFFEBF5FC),
                  //           ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                        ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Column(
// mainAxisAlignment: MainAxisAlignment.center,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         Text(
//           "Disclaimer\nThis feature might not be always accurate, for more information please contact your doctor as soon as possible",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//     Padding(
//       padding: EdgeInsets.fromLTRB(25, 30, 10, 10),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: LightColor.purple)),
//           labelText: 'Symptom 1',
//           labelStyle: GoogleFonts.lato(color: Colors.grey),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             isDense: true,
//             value: symptom1,
//             onChanged: (String newValue) {
//               setState(() {
//                 symptom1 = newValue;
//               });
//             },
//             items:
//                 symptomlist.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.fromLTRB(25, 5, 10, 5),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: LightColor.purple)),
//           labelText: 'Symptom 2',
//           labelStyle: GoogleFonts.lato(color: Colors.grey),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             isDense: true,
//             value: symptom2,
//             onChanged: (String newValue) {
//               setState(() {
//                 symptom2 = newValue;
//               });
//             },
//             items:
//                 symptomlist.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.fromLTRB(25, 5, 10, 10),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: LightColor.purple)),
//           labelText: 'Symptom 3',
//           labelStyle: GoogleFonts.lato(color: Colors.grey),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             isDense: true,
//             value: symptom3,
//             onChanged: (String newValue) {
//               setState(() {
//                 symptom3 = newValue;
//               });
//             },
//             items:
//                 symptomlist.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.fromLTRB(25, 5, 10, 5),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: LightColor.purple)),
//           labelText: 'Symptom 3',
//           labelStyle: GoogleFonts.lato(color: Colors.grey),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             isDense: true,
//             value: symptom4,
//             onChanged: (String newValue) {
//               setState(() {
//                 symptom4 = newValue;
//               });
//             },
//             items:
//                 symptomlist.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.fromLTRB(25, 5, 10, 5),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: LightColor.purple)),
//           labelText: 'Symptom 5',
//           labelStyle: GoogleFonts.lato(color: Colors.grey),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             isDense: true,
//             value: symptom5,
//             onChanged: (String newValue) {
//               setState(() {
//                 symptom5 = newValue;
//               });
//             },
//             items:
//                 symptomlist.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//     RaisedButton(
//       onPressed: () async {
//         String s1 = symptom1.replaceAll(" ", "_").toLowerCase();
//         String s2 = symptom2.replaceAll(" ", "_").toLowerCase();
//         String s3 = symptom3.replaceAll(" ", "_").toLowerCase();
//         String s4 = symptom4.replaceAll(" ", "_").toLowerCase();
//         String s5 = symptom5.replaceAll(" ", "_").toLowerCase();
//         String url = "https://disease-detector.herokuapp.com/predict/" +
//             "$s1/$s2/$s3/$s4/$s5";
//         print(url);
//         var response = await http.get(url);
//         setState(() {
//           output = response.body;
//           print(output);
//         });
//         selfDiagnosisData();
//         print("Added data to database");
//       },
//       child: Text("Predict"),
//     )
//   ],
// ),
