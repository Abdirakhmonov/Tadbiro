import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseService {
  final _currentUserCollection = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot> getUser() {
    return _currentUserCollection.snapshots();
  }

// Stream<QuerySnapshot> getUserInfo(String userID) {
//   return _currentUserCollection.doc()
//       .where('userId', isEqualTo: userID)
//       .snapshots();
// }
}
