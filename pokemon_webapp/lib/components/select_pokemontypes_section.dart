import 'package:flutter/material.dart';
import 'package:pokemon_webapp/api/pokemon_type_service.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class SelectPokemontypesSection extends StatefulWidget {
  const SelectPokemontypesSection({super.key});

  @override
  State<SelectPokemontypesSection> createState() =>
      _SelectPokemontypesSectionState();
}

class _SelectPokemontypesSectionState extends State<SelectPokemontypesSection> {
  List<String> allPokemontypes = [];
  List<bool> _checked = [];
  final List<String> _selectedTypes = [];
  UserService userService = UserService();
  PokemonTypeService pokemonTypeService = PokemonTypeService();

  @override
  void initState() {
    super.initState();
    getAllPokemontypes();
  }

  Future<void> getAllPokemontypes() async {
    List<String> pokeTypes = await pokemonTypeService.fetchAllPokemonTypes();

    setState(() {
      allPokemontypes = pokeTypes;
      _checked = List<bool>.filled(allPokemontypes.length, false);
    });
  }

  void _saveSelectedTypes() {
    _selectedTypes.clear();
    for (int i = 0; i < allPokemontypes.length; i++) {
      if (_checked[i]) {
        _selectedTypes.add(allPokemontypes[i]);
      }
    }
    userService.filterPokemonOnTypes(_selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 325,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.yellow[300],
                    ),
                    child: const Center(
                      child: Text(
                        "Select Pokemontypes",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: allPokemontypes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Checkbox(
                              value: _checked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked[index] = value!;
                                });
                              },
                            ),
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  allPokemontypes[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _saveSelectedTypes,
                      child: const Text('Filter Pokemontypes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
