import 'package:cloud_firestore/cloud_firestore.dart';

 class FirebaseDBHelper
 {
   FirebaseDBHelper._();
   static final FirebaseDBHelper firebaseDBHelper = FirebaseDBHelper._();

   static final FirebaseFirestore db = FirebaseFirestore.instance;

   Future<void> insertNote({required Map<String, dynamic> data}) async {
     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
     await db.collection("counter").doc("count").get();

     int count = documentSnapshot.data()!['total'];
     int id = documentSnapshot.data()!['id'];

     await db.collection("keep").doc("${++id}").set(data);

     await db.collection("counter").doc("count").update({"id": id});

     await db
         .collection("counter")
         .doc("count")
         .update({"total": ++count});
   }

   Future<void> deleteNote({required String id}) async {
     await db.collection("keep").doc(id).delete();

     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
     await db.collection("counter").doc("count").get();

     int count = documentSnapshot.data()!['total'];

     await db
         .collection("counter")
         .doc("count")
         .update({"total": --count});
   }

   Future<void> updateNote({
     required String id,
     required Map<String, dynamic> data,
   }) async {
     await db.collection("keep").doc(id).update(data);
   }
 }