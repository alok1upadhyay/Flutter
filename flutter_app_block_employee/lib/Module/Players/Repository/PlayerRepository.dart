import 'package:flutter_app_block_employee/Module/Players/Models/PlayerResponse.dart';
import 'package:flutter_app_block_employee/Module/Players/Service/ApiProvider.dart';

class PlayerRepository {
  PlayerApiProvider apiProvider = PlayerApiProvider();
  Future<List<Items>> fetchPlayersByCountry(String countryId) {
    return apiProvider.fetchPlayerByCountry(countryId);
  }
}
