import 'dart:async';

import 'package:flutter_app_block_employee/Module/ClassicCounter/Models/Counter.dart';

class CounterBlock {
  final counter = Counter(counterValue: 0);

  final counterStreamController = StreamController<Counter>();
  final incrementStreamController = StreamController<Counter>();
  final decrementmentStreamController = StreamController<Counter>();

  Stream<Counter> get streamControllerStream => counterStreamController.stream;
  StreamSink<Counter> get streamControllerSink => counterStreamController.sink;

  Stream<Counter> get incrementStreamControllerStream =>
      incrementStreamController.stream;
  StreamSink<Counter> get incrementStreamControllerSink =>
      incrementStreamController.sink;

  Stream<Counter> get decrementStreamControllerStream =>
      decrementmentStreamController.stream;
  StreamSink<Counter> get decrementStreamControllerSink =>
      decrementmentStreamController.sink;

  void dispose() {
    counterStreamController.close();
    incrementStreamController.close();
    decrementmentStreamController.close();
  }

  void increment(Counter counter) {
    counter.counterValue = counter.counterValue + 1;
    streamControllerSink.add(counter);
  }

  void decrement(Counter counter) {
    counter.counterValue = counter.counterValue - 1;
    streamControllerSink.add(counter);
  }

  CounterBlock() {
    counterStreamController.add(counter);
    incrementStreamControllerStream.listen(increment);
    decrementStreamControllerStream.listen(decrement);
  }
}
