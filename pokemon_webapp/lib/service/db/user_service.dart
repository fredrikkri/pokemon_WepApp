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

  Future<List<String>> fetchUserRegions() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (userDoc.exists) {
          List<String> regions = List<String>.from(userDoc['regions']);
          return regions;
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

  Future<void> likePokemon(
    int id,
    String humanName,
    String name,
    String joke,
    int height,
    int weight,
    int baseExperience,
    List<String> types,
    String img,
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        Map<String, dynamic> likedPokemon = {
          'id': id,
          'humanName': humanName,
          'name': name,
          'joke': joke,
          'height': height,
          'weight': weight,
          'baseExperience': baseExperience,
          'types': types,
          'img': img,
        };
        await documentRef.update({
          'likedPokemon': FieldValue.arrayUnion([likedPokemon]),
        });

        print('Pokemon liked');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error adding pokemon to list of liked pokemon: $e');
    }
  }

  Future<void> dislikePokemon(
    int id,
    String humanName,
    String name,
    String joke,
    int height,
    int weight,
    int baseExperience,
    List<String> types,
    String img,
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        Map<String, dynamic> dislikedPokemon = {
          'id': id,
          'humanName': humanName,
          'name': name,
          'joke': joke,
          'height': height,
          'weight': weight,
          'baseExperience': baseExperience,
          'types': types,
          'img': img,
        };

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

  Future<List<Map<String, dynamic>>> fetchLikedPokemons(
      String documentId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (documentSnapshot.exists) {
          List<dynamic> likedPokemonField =
              documentSnapshot['likedPokemon'] as List<dynamic>;

          List<Map<String, dynamic>> pokemonDataMap =
              likedPokemonField.map((item) {
            return item as Map<String, dynamic>;
          }).toList();

          return pokemonDataMap;
        } else {
          print('Liked pokemon does not exist for user.');
          return [];
        }
      } else {
        print('No user is currently signed in.');
        return [];
      }
    } catch (e) {
      print('Error fetching liked Pokemon: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDislikedPokemons(
      String documentId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (documentSnapshot.exists) {
          List<dynamic> likedPokemonField =
              documentSnapshot['dislikedPokemon'] as List<dynamic>;

          List<Map<String, dynamic>> pokemonDataMap =
              likedPokemonField.map((item) {
            return item as Map<String, dynamic>;
          }).toList();

          return pokemonDataMap;
        } else {
          print('Liked pokemon does not exist for user.');
          return [];
        }
      } else {
        print('No user is currently signed in.');
        return [];
      }
    } catch (e) {
      print('Error fetching liked Pokemon: $e');
      return [];
    }
  }

  Future<List<String>> fetchDislikedPokemonNames() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (documentSnapshot.exists) {
          List<dynamic> likedPokemonField =
              documentSnapshot['dislikedPokemon'] as List<dynamic>;

          List<String> pokemonNamesList = likedPokemonField.map((item) {
            return item['name'] as String;
          }).toList();

          return pokemonNamesList;
        } else {
          print('Liked pokemon does not exist for user.');
          return [];
        }
      } else {
        print('No user is currently signed in.');
        return [];
      }
    } catch (e) {
      print('Error fetching liked Pokemon: $e');
      return [];
    }
  }

  Future<void> filterPokemonOnTypes(List<String> selectedTypes) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        await documentRef.update({
          'pokemonTypes': selectedTypes,
        });

        print('Filter pokemon on pokemon type is sucess');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error adding pokemon type to filter: $e');
    }
  }

  Future<void> filterPokemonOnRegions(List<String> selectedRegions) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        await documentRef.update({
          'regions': selectedRegions,
        });

        print('Filter pokemon on region is sucess');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error adding region to filter: $e');
    }
  }

  Future<void> clearPokemontypes() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        await documentRef.update({
          'pokemonTypes': [],
        });

        print('Pokemontypes for current user is cleared');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error clearing pokemontypes for current user: $e');
    }
  }

  Future<void> clearRegions() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        await documentRef.update({
          'regions': [],
        });

        print('Regions for current user is cleared');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error clearing regions for current user: $e');
    }
  }
}
