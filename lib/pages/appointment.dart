import 'package:flutter/material.dart';
import 'package:health_assistant/pages/confirmation.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatefulWidget {
  final String docId;
  final String pID;
  AppointmentPage(this.docId, this.pID);
  @override
  _AppointmentPageState createState() => _AppointmentPageState(docId, pID);
}

class _AppointmentPageState extends State<AppointmentPage> {
  final String docId;
  final String pID;
  List<String> availableDays = [];
  _AppointmentPageState(this.docId, this.pID);

  void getDocName(docId) async {
    var qs =
        await FirebaseFirestore.instance.collection('doctors').doc(docId).get();
    print("Doctor name" + qs.data()['name']);
    dName = qs.data()['name'];
  }

  void getPatientName(pId) async {
    var qs =
        await FirebaseFirestore.instance.collection('patients').doc(pId).get();
    print("hey patient name found");
    print("Patient name foundddd " + qs.data()['fname']);
    pName = qs.data()['fname'] + " " + qs.data()['lname'];
  }

  void setBookedstatus(startTime, endTime, documentId) async {
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)
        .collection('Schedule')
        .doc(selectedDay)
        .collection('Timeslots')
        .doc(documentID)
        .update({'booked': true}).then((value) => print("Status updated"));
  }

  void bookAppointment(startTime, endTime, docId, day, date, month, year,
      patientID, dName, pName, dateTime) {
    FirebaseFirestore.instance.collection('bookings').add({
      'doctor_name': dName,
      'patient_name': pName,
      'pID': patientID,
      'docID': docId,
      'date': date,
      'month': month,
      'year': year,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'datetime': dateTime
    });
  }

  Future<List<QueryDocumentSnapshot>> getDoctorDetails(docId) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)
        .collection('Schedule')
        .get();
    return data.docs;
  }

  Future<List<QueryDocumentSnapshot>> getScheduleSlots(docId) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)
        .collection('Schedule')
        .doc(selectedDay)
        .collection('Timeslots')
        .orderBy('start_time')
        .where('booked', isEqualTo: false)
        .get();
    return data.docs;
  }

  CalendarController _controller;
  var formatter = new DateFormat('EEEE');
  var dateGetter = new DateFormat('dd');
  var monthGetter = new DateFormat('MM');
  var yearGetter = new DateFormat('yyyy');
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    getDocName(docId);
    getPatientName(pID);
    // print("Doctor name is " + dName);
  }

  String selectedDay;
  String selectedDate;
  String selectedMonth;
  String selectedYear;
  int _value = 1;
  String startTime;
  String endTime;
  String documentID;
  String dName;
  String pName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Book Your Appointment'),
          backgroundColor: LightColor.purple,
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: getDoctorDetails(docId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              getDocName(docId);
              var scheduleData = snapshot.data;
              for (var i in scheduleData) {
                availableDays.add(i.data()['day']);
              }
              return FutureBuilder<List<QueryDocumentSnapshot>>(
                  future: getScheduleSlots(docId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // print(dName);
                    var slotData = snapshot.data;
                    print(
                        "---------------------SlotData Length-------------------");
                    print(slotData.length);
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TableCalendar(
                            initialCalendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                                todayColor: Colors.amber,
                                selectedColor: LightColor.purple,
                                todayStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    color: Colors.white)),
                            headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              formatButtonTextStyle:
                                  TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            startDay: DateTime.now(),
                            endDay: DateTime.now().add(Duration(days: 6)),
                            weekendDays: [DateTime.sunday],
                            onDaySelected: (date, events, _) async {
                              setState(() {
                                selectedDay = formatter.format(date);
                                selectedDate = dateGetter.format(date);
                                selectedMonth = monthGetter.format(date);
                                selectedYear = yearGetter.format(date);
                                print("validating DATEFORMAT");
                                print(DateTime.parse(selectedYear +
                                        "-" +
                                        selectedMonth +
                                        "-" +
                                        selectedDate)
                                    .toString());
                              });
                            },
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: LightColor.purple,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                              todayDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                            calendarController: _controller,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          availableDays.contains(selectedDay) &&
                                  slotData.length > 0
                              ? Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      'Please select a time slot',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    Center(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          value: _value,
                                          items: [
                                            for (int i = 0;
                                                i < slotData.length;
                                                i++)
                                              DropdownMenuItem(
                                                  child: Center(
                                                    child: Text(
                                                        slotData[i].data()[
                                                                'start_time'] +
                                                            " to " +
                                                            slotData[i].data()[
                                                                'end_time']),
                                                  ),
                                                  value: i + 1),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                              startTime = slotData[value - 1]
                                                  .data()['start_time'];
                                              endTime = slotData[value - 1]
                                                  .data()['end_time'];
                                              documentID =
                                                  slotData[value - 1].id;
                                            });
                                          }),
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: RaisedButton(
                                        onPressed: () {
                                          setBookedstatus(
                                              startTime, endTime, documentID);
                                          bookAppointment(
                                            startTime,
                                            endTime,
                                            docId,
                                            selectedDay,
                                            selectedDate,
                                            selectedMonth,
                                            selectedYear,
                                            pID,
                                            dName,
                                            pName,
                                            DateTime.parse(selectedYear +
                                                selectedMonth +
                                                selectedDate),
                                          );
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmationPage(
                                                          pID,
                                                          docId,
                                                          selectedDay,
                                                          selectedDate,
                                                          selectedMonth,
                                                          selectedYear,
                                                          startTime,
                                                          endTime)));
                                        },
                                        color: LightColor.purple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text("Book Appointment",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            )),
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        child:
                                            Text("No appointments available!"),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ),
                    );
                  });
            }));
  }
}
