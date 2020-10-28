import 'package:flutter/material.dart';
import 'package:flutter_app_block_employee/Module/Employee/BLoC/EmployeeBloC.dart';
import 'package:flutter_app_block_employee/Module/Employee/Models/Employee.dart';

class EmployeeListWidget extends StatefulWidget {
  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  EmployeeBloC employeeBlock;

  @override
  void initState() {
    super.initState();
    employeeBlock = EmployeeBloC();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    employeeBlock.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildEmployeeListSalaryCounterUsingBlocStreamController();
  }

  Container buildEmployeeListSalaryCounterUsingBlocStreamController() {
    return Container(
      color: Colors.pink[50],
      child: Column(
        children: [
          Text(
            'Another example using simple bloc pattern on array as data structure and ListView as user interface: This exemple also uses stream, sink philosophy.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          buildList(context),
        ],
      ),
    );
  }

  StreamBuilder<List<Employee>> buildList(BuildContext context) {
    return StreamBuilder<List<Employee>>(
      stream: employeeBlock.employeeListStream,
      builder: (context, AsyncSnapshot<List<Employee>> snapshot) {
        if (snapshot != null && snapshot.data != null) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.0,
                child: Row(
                  children: [
                    Text('id is ${snapshot.data[index].id}'),
                    Text('slary is ${snapshot.data[index].salary}'),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {
                        employeeBlock.incrementSalaryStreamSink
                            .add(snapshot.data[index]);
                      },
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      onPressed: () {
                        employeeBlock.decrementSalaryStreamSink
                            .add(snapshot.data[index]);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Text('Initializing');
        }
      },
    );
  }
}
