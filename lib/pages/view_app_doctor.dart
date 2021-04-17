import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_assistant/DatabaseManager/DatabaseManager.dart';
import 'package:health_assistant/pages/viewPatientProfile.dart';
import 'package:health_assistant/theme/light_color.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/globals.dart' as globals;

class ViewAppDoc extends StatefulWidget {
  final String docId;
  ViewAppDoc({Key key, @required this.docId}) : super(key: key);
  @override
  _ViewAppDocState createState() => _ViewAppDocState(docId);
}

class _ViewAppDocState extends State<ViewAppDoc> {
  final String docId;
  _ViewAppDocState(this.docId);

  fetchAppointments() async {
    var resultant = await DatabaseManager().getSelectedDateAppointment(
        docId, selectedDate, selectedMonth, selectedYear);
    if (resultant == null) {
      print('Unable to retrieve todays appointments');
    } else {
      //todaysAppoint = resultant;
      //print("doctor home page todays appointments");
      //print(resultant);
      return resultant;
    }
    return resultant;
  }

  CalendarController _controller;
  var formatter = new DateFormat('EEEE');
  var dateGetter = new DateFormat('dd');
  var monthGetter = new DateFormat('MM');
  var yearGetter = new DateFormat('yyyy');

  //String tdate =  DateTime.now().toString();
  String selectedDay;
  String selectedDate = DateTime.now().toString().substring(8, 10);
  String selectedMonth = DateTime.now().toString().substring(5, 7);
  String selectedYear = DateTime.now().toString().substring(0, 4);

  changeBookingStatus(doctorID, day, startTime, endTime) async {
    var data = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorID)
        .collection('Schedule')
        .doc(day)
        .collection('Timeslots')
        .where('start_time', isEqualTo: startTime)
        .limit(1)
        .get();
    var slotID = data.docs[0].id;
    print(slotID);
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorID)
        .collection('Schedule')
        .doc(day)
        .collection('Timeslots')
        .doc(slotID)
        .update({'booked': false});
  }

  void cancelAppointment(bookingId) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
    print("Cancelled appointment");
    print(bookingId);
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Scheduled Appointments'),
        backgroundColor: LightColor.purple,
      ),
      body: FutureBuilder(
          future: fetchAppointments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            var selectedDateAppoint = snapshot.data;
            // print(selectedDateAppoint[0].id);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    calendarController: _controller,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                      todayColor: Colors.amber,
                      selectedColor: LightColor.purple,
                      todayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    startDay: DateTime.now(),
                    endDay: DateTime.now().add(Duration(days: 7)),
                    weekendDays: [DateTime.sunday],
                    onDaySelected: (date, events, _) async {
                      setState(() {
                        selectedDay = formatter.format(date);
                        selectedDate = dateGetter.format(date);
                        selectedMonth = monthGetter.format(date);
                        selectedYear = yearGetter.format(date);
                        print("hollaaa");
                        print(selectedMonth);
                        print(selectedDate);
                        print(selectedYear);
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: LightColor.purple,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Appointments",
                        style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height / 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.sort),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  selectedDateAppoint.isEmpty
                      ? Center(
                          child: Text(
                              "No appointments for " +
                                  selectedDate +
                                  "/" +
                                  selectedMonth +
                                  "/" +
                                  selectedYear,
                              style: GoogleFonts.lato(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 42)))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: selectedDateAppoint.length,
                            itemBuilder: (context, index) {
                              // print(selectedDateAppoint[index].id);
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
                                  title: Text(selectedDateAppoint[index]
                                      ['patient_name']),
                                  subtitle: Text(selectedDateAppoint[index]
                                          ['start_time'] +
                                      " " +
                                      selectedDateAppoint[index]['end_time']),
                                  trailing: FlatButton.icon(
                                    onPressed: () {
                                      // print("------Booking ID is-----");
                                      // print(globals.bookingIDs[index]);
                                      // cancelAppointment(
                                      //     selectedDateAppoint[index]);
                                      changeBookingStatus(
                                          selectedDateAppoint[index]['docID'],
                                          selectedDateAppoint[index]['day'],
                                          selectedDateAppoint[index]
                                              ['start_time'],
                                          selectedDateAppoint[index]
                                              ['end_time']);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.redAccent,
                                    ),
                                    label: Text("Cancel \nAppointment"),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewPatientProfile(
                                                  selectedDateAppoint[index]
                                                      ['pID'])),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
