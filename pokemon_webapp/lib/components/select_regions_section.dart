import 'package:flutter/material.dart';
import 'package:pokemon_webapp/api/pokemon_area_service.dart';

class SelectRegionsSection extends StatefulWidget {
  const SelectRegionsSection({super.key});

  @override
  State<SelectRegionsSection> createState() => _SelectRegionsSectionState();
}

class _SelectRegionsSectionState extends State<SelectRegionsSection> {
  List<String> allRegions = [];

  @override
  void initState() {
    super.initState();
    getAllRegions();
  }

  Future<void> getAllRegions() async {
    PokemonAreaService pokemonAreaService = PokemonAreaService();
    List<String> regions = await pokemonAreaService.fetchAllPokemonAreas();

    setState(() {
      allRegions = regions;
    });
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
                      child: Text("Select regions"),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: allRegions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              allRegions[index],
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
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
