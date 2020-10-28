import 'dart:convert';

import 'package:flutter_app_block_employee/Module/Players/Models/PlayerResponse.dart';
import 'package:http/http.dart' as http;

class PlayerApiProvider {
  String baseUrl = "https://www.easports.com/fifa/ultimate-team/api/fut/item?";

  Future<List<Items>> fetchPlayerByCountry(String countryId) async {
    final response = await http.get(baseUrl + 'country=$countryId');
    final jd = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final model = PlayerResponse.fromJson(jd);
      return model.items;
    } else {
      throw Exception('Failed response');
    }
  }
}
