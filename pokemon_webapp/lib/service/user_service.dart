import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsersStream() {
    final usersStream = users.orderBy('email', descending: true).snapshots();
    return usersStream;
  }

  Future<void> registrerUser() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return users.add({
      'email': currentUser?.email.toString(),
      'following': [],
      'followers': [],
      'timestamp': Timestamp.now(),
    });
  }
}
