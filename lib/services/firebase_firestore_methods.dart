import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCurdMethods {
  // Reference to the Firestore "users" collection
  static final CollectionReference users = FirebaseFirestore.instance.collection("users");

  //! CREATE: Log new meeting details in the Firestore database under the "meetingsDetails" sub-collection of the current user.
  static Future<void> logMeetingDetails({
    String? imageURL,
    DateTime? joinTime,
    DateTime? leaveTime,
    Duration? totalMeetingDuration,
    bool? isMeetingCreated,
  }) {
    try {
      // Reference to the current user's document in the main "users" collection
      DocumentReference currentUserID = users.doc(FirebaseAuth.instance.currentUser!.uid.toString());

      // Reference to the "meetingsDetails" sub-collection within the current user's document
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

  //! READ: Retrieve meeting log details from the "meetingsDetails" sub-collection of the current user in Firestore.
  static Stream<QuerySnapshot> readMeetingDetails() {
    try {
      // Reference to the current user's document in the main "users" collection
      DocumentReference currentUserID = users.doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

      // Reference to the "meetingsDetails" sub-collection within the current user's document
      CollectionReference notes = currentUserID.collection('meetingsDetails');

      // Stream of notes ordered by "joinTime" in descending order
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
