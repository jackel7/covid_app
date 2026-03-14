import 'dart:convert';

import 'package:covid_app/Model/countries_list_model.dart';
import 'package:covid_app/Model/world_states_model.dart';
import 'package:covid_app/services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception("Error");
    }
  }

  Future<List<CountriesListModel>> countriesList() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CountriesListModel.fromJson(item)).toList();
    } else {
      throw Exception("Error");
    }
  }
}
