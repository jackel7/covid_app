import 'package:covid_app/Model/countries_list_model.dart';
import 'package:covid_app/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchController = TextEditingController();

  final StatesServices _services = StatesServices();
  late Future<List<CountriesListModel>> countriesFuture;

  @override
  void initState() {
    super.initState();

    countriesFuture = _services.countriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  // Triggers a rebuild to filter the list as you type
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Search Country",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: countriesFuture,
                builder: (context, AsyncSnapshot<List<CountriesListModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => buildShimmerItems(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Data Available"));
                  }

                  // --- OPTIMIZATION: FILTERING DATA HERE ---
                  // Instead of checking inside the ListView, we filter the list first.
                  // This prevents the "Lag" because ListView only handles matching items.
                  List<CountriesListModel> filteredList = snapshot.data!.where((
                    element,
                  ) {
                    String countryName = element.country!.toLowerCase();
                    String searchText = searchController.text.toLowerCase();
                    return countryName.contains(searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredList.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      var country = filteredList[index];

                      return Column(
                        children: [
                          ListTile(
                            leading: Image.network(
                              country.countryInfo!.flag!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.flag_circle),
                            ),
                            title: Text(
                              country.country!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Total Cases: ${country.cases}"),
                            onTap: () {
                              // Add navigation to Detail Screen here if needed
                            },
                          ),
                          const Divider(height: 1, thickness: 0.5),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerItems() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        leading: Container(height: 40, width: 40, color: Colors.white),
        title: Container(
          height: 10,
          width: double.infinity,
          color: Colors.white,
        ),
        subtitle: Container(height: 10, width: 100, color: Colors.white),
      ),
    );
  }
}
