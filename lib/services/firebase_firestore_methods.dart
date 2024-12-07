import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCurdMethods {
  // Getting FireStore Collection
  static final CollectionReference users = FirebaseFirestore.instance.collection("users");

  //! CREATE: Create a new "Meeting Log details" in FireStore Database inside "users" sub collection named meetingsDetails.
  static Future<void> logMeetingDetails({
    String? imageURL,
    DateTime? joinTime,
    DateTime? leaveTime,
    Duration? totalMeetingDuration,
    bool? isMeetingCreated,
  }) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Creating reference to notes sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('meetingsDetails');

      return notes.add(
        {
          "imageURL": imageURL,
          "joinTime": joinTime,
          "leaveTime": leaveTime,
          "totalDuration": totalMeetingDuration!.inSeconds,
          "meetingType": isMeetingCreated! ? "MeetingCreated" : "MeetingJoined",
        },
      );
    } catch (error) {
      throw error.toString();
    }
  }

  //! READ: Get "Meeting Log details" from FireStore form inside "users" sub collection named meetingsDetails.
  static Stream<QuerySnapshot> readMeetingDetails() {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to notes sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('meetingsDetails');

      // Sorting Notes by "timestamp"
      final notesStream = notes.orderBy("joinTime", descending: true).snapshots();
      return notesStream;
    } catch (error) {
      throw error.toString();
    }
  }

  //! DELETE: Delete "Note" from FireStore
  static Future<void> deleteMeetingDetails({String? docID}) {
    try {
      // Reference to the current user's document in the main collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Creating reference to notes sub-collection inside current user's document
      CollectionReference notes = currentUserID.collection('meetingsDetails');

      return notes.doc(docID).delete();
    } catch (error) {
      throw error.toString();
    }
  }
}
