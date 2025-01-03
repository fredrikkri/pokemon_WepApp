import 'package:flutter/material.dart';
import 'package:pokemon_webapp/service/api/pokemon_region_service.dart';
import 'package:pokemon_webapp/service/db/user_service.dart';

class SelectRegionsSection extends StatefulWidget {
  const SelectRegionsSection({super.key});

  @override
  State<SelectRegionsSection> createState() => _SelectRegionsSectionState();
}

class _SelectRegionsSectionState extends State<SelectRegionsSection> {
  List<String> allRegions = [];
  List<bool> _checked = [];
  final List<String> _selectedRegions = [];
  UserService userService = UserService();
  PokemonRegionService pokemonAreaService = PokemonRegionService();

  @override
  void initState() {
    super.initState();
    getAllRegions();
  }

  Future<void> getAllRegions() async {
    List<String> regions = await pokemonAreaService.fetchAllPokemonRegions();

    setState(() {
      allRegions = regions;
      _checked = List<bool>.filled(allRegions.length, false);
    });
  }

  void _saveSelectedRegions() {
    _selectedRegions.clear();
    for (int i = 0; i < allRegions.length; i++) {
      if (_checked[i]) {
        _selectedRegions.add(allRegions[i]);
      }
    }
    userService.filterPokemonOnRegions(_selectedRegions);
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
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Text(
                        "Select regions",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: allRegions.length,
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
                                  allRegions[index],
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
                      onPressed: _saveSelectedRegions,
                      child: const Text('Filter Regions'),
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
