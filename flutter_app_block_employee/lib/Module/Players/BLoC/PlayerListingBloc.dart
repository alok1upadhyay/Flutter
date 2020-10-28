import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingEvent.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingStates.dart';
import 'package:flutter_app_block_employee/Module/Players/Repository/PlayerRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerListingBloc extends Bloc<PlayerListingEvent, PlayerListingStates> {
  PlayerListingBloc(PlayerListingStates initialState) : super(initialState);

  PlayerRepository playerRepository;

  @override
  Stream<PlayerListingStates> mapEventToState(PlayerListingEvent event) async* {
    if (event is CountrySelectedEvent) {
      yield PlayerFetchingState();
      try {
        if (playerRepository == null) {
          playerRepository = PlayerRepository();
        }
        final players =
            (await playerRepository.fetchPlayersByCountry(event.countryId));
        if (players.length == 0) {
          yield PlayerEmptyState();
        } else {
          yield PlayerFetchedState(players);
        }
      } catch (_) {
        yield PlayerErrorState();
      }
    }
  }
}
