import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PokemonService {
  final CollectionReference pokemons =
      FirebaseFirestore.instance.collection('pokemons');
}
