import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_assistant/pages/doctorDetailPage.dart';

class DatabaseManager {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to get list of doctors in a Department
  Future getDepartDoctorsList(String departmentName) async {

    List  departDocList = [];

    try{
      await firestore.collection('doctors').where("type", isEqualTo: departmentName).get().then((querySnapshot){
        querySnapshot.docs.forEach((element) {
          departDocList.add(element.data());
        });
      });
      return departDocList;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future getDoctorDetails(String docId) async{
      var docDetails =await firestore.collection('doctors').doc(docId).get();
      if (docDetails.exists) {
        return docDetails.data();
      } 
      else {
        return null;
      }

  }





}