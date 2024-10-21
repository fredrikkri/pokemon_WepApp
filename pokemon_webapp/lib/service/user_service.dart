import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsersStream() {
    final usersStream = users.orderBy('email', descending: true).snapshots();
    return usersStream;
  }

//   Future<void> registrerUser() {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     return users.add({
//       'id': currentUser?.uid.toString(),
//       'email': currentUser?.email.toString(),
//       'likedPokemon': [],
//       'dislikedPokemon': [],
//       'pokemonTypes': [],
//       'regions': [],
//       'timestamp': Timestamp.now(),
//     });
//   }
// }

  Future<void> registrerUser(String username) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'id': currentUser.uid,
        'email': currentUser.email,
        'username': username,
        'likedPokemon': [],
        'dislikedPokemon': [],
        'pokemonTypes': [],
        'regions': [],
        'timestamp': Timestamp.now(),
      });
    } else {
      throw Exception('No user is currently logged in.');
    }
  }
}
