import 'package:flutter/material.dart';
import 'package:flutter_app_block_employee/Module/ClassicCounter/BLoC/CounterBlock.dart';
import 'package:flutter_app_block_employee/Module/ClassicCounter/Models/Counter.dart';

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CounterBlock counterBlock;
  @override
  void initState() {
    super.initState();
    counterBlock = CounterBlock();
  }

  @override
  void dispose() {
    counterBlock.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSimpleCounterUsingBlocStreamController();
  }

  Container buildSimpleCounterUsingBlocStreamController() {
    return Container(
      color: Colors.yellow[50],
      child: Column(
        children: [
          Text(
            'Simple counter using bloc Pattern: It is a simple counter app using stream controller, sink and stream for understanding BLoC pattern',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          StreamBuilder(
            builder: (context, AsyncSnapshot<Counter> snapshot) {
              return Container(
                child: Row(
                  children: [
                    Text((snapshot != null &&
                            snapshot.data != null &&
                            snapshot.data.counterValue != null)
                        ? "Counter value is ${snapshot.data.counterValue}"
                        : 'iniliazing'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        counterBlock.incrementStreamControllerSink
                            .add(snapshot.data);
                      },
                      color: Colors.red,
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        counterBlock.decrementStreamControllerSink
                            .add(snapshot.data);
                      },
                      color: Colors.red,
                    )
                  ],
                ),
              );
            },
            stream: counterBlock.streamControllerStream,
          ),
        ],
      ),
    );
  }
}
