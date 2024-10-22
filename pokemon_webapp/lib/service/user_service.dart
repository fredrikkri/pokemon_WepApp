import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsersStream() {
    final usersStream = users.orderBy('email', descending: true).snapshots();
    return usersStream;
  }

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

  Future<List<String>> fetchUserTypes() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (userDoc.exists) {
          List<String> types = List<String>.from(userDoc['pokemonTypes']);
          return types;
        } else {
          //print('Document does not exist');
          return [];
        }
      } else {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently logged in.',
        );
      }
    } catch (e) {
      //print('Error fetching pokemontypes from user: $e');
      return [];
    }
  }

  Future<void> likePokemon(String pokemonName, String joke) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        Map<String, dynamic> hashData = {
          pokemonName: joke,
        };
        await documentRef.update({
          'likedPokemon': FieldValue.arrayUnion([hashData]),
        });

        print('Pokemon liked');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error adding pokemon to list of liked pokemon: $e');
    }
  }

  Future<void> dislikePokemon(String pokemonName) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        String dislikedPokemon = pokemonName;

        await documentRef.update({
          'dislikedPokemon': FieldValue.arrayUnion([dislikedPokemon]),
        });

        print('Pokemon disliked');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error adding pokemon to list of disliked pokemon: $e');
    }
  }
}
