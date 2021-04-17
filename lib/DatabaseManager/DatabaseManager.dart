import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/globals.dart' as globals;

class DatabaseManager {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to get list of doctors in a Department
  Future getDepartDoctorsList(String departmentName) async {
    List departDocList = [];

    try {
      await firestore
          .collection('doctors')
          .where("type", isEqualTo: departmentName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          departDocList.add(element.data());
        });
      });
      return departDocList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Function to return Doctor Information
  Future getDoctorDetails(String docId) async {
    var docDetails = await firestore.collection('doctors').doc(docId).get();
    if (docDetails.exists) {
      return docDetails.data();
    } else {
      return null;
    }
  }

  Future getTodaysAppointment(String docId) async {
    List todaysappointments = [];
    String tdate = DateTime.now().toString();
    String year = tdate.substring(0, 4);
    String month = tdate.substring(5, 7);
    String date = tdate.substring(8, 10);

    try {
      await firestore
          .collection('bookings')
          .where("docID", isEqualTo: docId)
          .where("year", isEqualTo: year)
          .where("month", isEqualTo: month)
          .where("date", isEqualTo: date)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          todaysappointments.add(element.data());
        });
      });
      print("appointments foundddd");
      return todaysappointments;
    } catch (e) {
      print("appointments not foundddd");
      print(e.toString());
      return null;
    }
  }

  Future getSelectedDateAppointment(
      String docId, String date, String month, String year) async {
    List selectedDateAppt = [];
    Map<Map<String, dynamic>, String> apptData;
    try {
      await firestore
          .collection('bookings')
          .where("docID", isEqualTo: docId)
          .where("year", isEqualTo: year)
          .where("month", isEqualTo: month)
          .where("date", isEqualTo: date)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          selectedDateAppt.add(element.data());
          apptData[element.data()] = element.id;
          // globals.bookingIDs.add(element.id);
        });
      });
      print("Selected date appointments foundddd");
      return selectedDateAppt;
    } catch (e) {
      print("Select date appointments not foundddd");
      print(e.toString());
      return null;
    }
  }
}
