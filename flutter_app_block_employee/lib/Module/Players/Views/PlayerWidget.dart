import 'package:flutter/material.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingBloc.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingEvent.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerWidget extends StatefulWidget {
  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return buildPlayerListingWithFlutterBlockAndCubit(context);
  }

  Container buildPlayerListingWithFlutterBlockAndCubit(BuildContext context) {
    return Container(
      color: Colors.orange[300],
      child: Column(
        children: [
          Text(
            "For me personally below is the best use case of BLoC pattern, State, Event, Repository & service. There are still lot of optimization possible for exaple unit test cases, UITestcases, generic api class which take input params, url & <T> generic responses",
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.lightBlue[900]),
          ),
          BlocBuilder(
            cubit: BlocProvider.of<PlayerListingBloc>(context),
            builder: (context, state) {
              if (state is PlayerUninitializedState) {
                return Text(
                  "Please select a country flag to fetch players from",
                );
              } else if (state is PlayerEmptyState) {
                return Text(
                  "No Players found",
                );
              } else if (state is PlayerErrorState) {
                return Text(
                  "Something went wrong",
                );
              } else if (state is PlayerFetchingState) {
                return Text(
                  "Loading...........",
                );
              } else {
                final stateAsPlayerFetchedState = state as PlayerFetchedState;
                final players = stateAsPlayerFetchedState.players;
                return Text(
                  "first player is ${players.first.name}",
                );
              }
            },
          ),
          FlatButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              BlocProvider.of<PlayerListingBloc>(context)
                  .add(CountrySelectedEvent('52'));
            },
            child: Text(
              "click me to call player api",
            ),
          ),
        ],
      ),
    );
  }
}
