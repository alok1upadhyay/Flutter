import 'dart:async';

import 'package:flutter_app_block_employee/Module/Employee/Models/Employee.dart';

class EmployeeBloC {
  final arrEmployee = List<Employee>();

  //stream controllers
  final employeeListStreamController = StreamController<List<Employee>>();
  final incrementSalaryStreamController = StreamController<Employee>();
  final decrementSalaryStreamController = StreamController<Employee>();

  //streams set up
  Stream<List<Employee>> get employeeListStream =>
      employeeListStreamController.stream;
  Stream<Employee> get incrementSalaryStream =>
      incrementSalaryStreamController.stream;
  Stream<Employee> get decrementSalaryStream =>
      decrementSalaryStreamController.stream;

  //streamSink set up
  StreamSink<List<Employee>> get employeeListStreamSink =>
      employeeListStreamController.sink;
  StreamSink<Employee> get incrementSalaryStreamSink =>
      incrementSalaryStreamController.sink;
  StreamSink<Employee> get decrementSalaryStreamSink =>
      decrementSalaryStreamController.sink;

  EmployeeBloC() {
    //hardcode should not be there
    arrEmployee.add(Employee(id: 1, salary: 10));
    arrEmployee.add(Employee(id: 2, salary: 20));
    arrEmployee.add(Employee(id: 3, salary: 30));
    //hardcode should not be there

    employeeListStreamController.add(arrEmployee);
    incrementSalaryStream.listen(incrementSalary);
    decrementSalaryStream.listen(decrementSalary);
  }

  void incrementSalary(Employee employee) {
    double salary = employee.salary;
    double incrementedSalary = salary + 20;
    employee.salary = incrementedSalary;
    employeeListStreamSink.add(arrEmployee);
  }

  void decrementSalary(Employee employee) {
    double salary = employee.salary;
    double decreasedSalary = salary - 20;
    employee.salary = decreasedSalary;
    employeeListStreamSink.add(arrEmployee);
  }

  void dispose() {
    incrementSalaryStreamController.close();
    decrementSalaryStreamController.close();
  }
}
