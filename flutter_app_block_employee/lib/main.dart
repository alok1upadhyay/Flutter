import 'package:flutter/material.dart';
import 'package:flutter_app_block_employee/Module/Album/Views/AlbumWidget.dart';
import 'package:flutter_app_block_employee/Module/ClassicCounter/Views/CounterWidget.dart';
import 'package:flutter_app_block_employee/Module/Employee/Views/EmployeeListWidget.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingBloc.dart';
import 'package:flutter_app_block_employee/Module/Players/BLoC/PlayerListingStates.dart';
import 'package:flutter_app_block_employee/Module/Players/Views/PlayerWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Module/ClassicCounter/BLoC/CounterBlock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (contect) => PlayerListingBloc(PlayerUninitializedState()),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CounterBlock counterBlock;
  @override
  void initState() {
    super.initState();
    counterBlock = CounterBlock();
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Various BLoC Implementations'),
      ),
      body: Container(
        child: Column(
          children: [
            buildSimpleCounterUsingBlocStreamController(),
            buildEmployeeListSalaryCounterUsingBlocStreamController(),
            buildAlbumWithApiCallUsingBlocWithStreamController(),
            buildPlayerListingWithFlutterBlockAndCubit(context),
          ],
        ),
      ),
    );
  }

//thinking about moving ahead with this direction (Player Module)
  Widget buildPlayerListingWithFlutterBlockAndCubit(BuildContext context) {
    return PlayerWidget();
  }

  Widget buildAlbumWithApiCallUsingBlocWithStreamController() {
    return AlbumWidget();
  }

  Widget buildEmployeeListSalaryCounterUsingBlocStreamController() {
    return EmployeeListWidget();
  }

  Widget buildSimpleCounterUsingBlocStreamController() {
    return CounterWidget();
  }
}
