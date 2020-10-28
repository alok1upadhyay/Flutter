import 'package:flutter_app_block_employee/Module/Players/Models/PlayerResponse.dart';

abstract class PlayerListingStates {}

class PlayerUninitializedState extends PlayerListingStates {}

class PlayerFetchingState extends PlayerListingStates {}

class PlayerFetchedState extends PlayerListingStates {
  final List<Items> players;

  PlayerFetchedState(this.players);
}

class PlayerErrorState extends PlayerListingStates {}

class PlayerEmptyState extends PlayerListingStates {}
