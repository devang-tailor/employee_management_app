// import 'package:bloc/bloc.dart';
// import 'package:employee_management_app/models/employee_model.dart';
// import 'package:employee_management_app/services/database_service.dart';
// import 'package:employee_management_app/viewmodels/employee_state.dart';
//
//
// class EmployeeCubit extends Cubit<EmployeeState> {
//   final DatabaseService _databaseService;
//
//   EmployeeCubit(this._databaseService) : super(EmployeeInitial());
//
//   Future<void> fetchEmployees() async {
//     emit(EmployeeLoading());
//     try {
//       final employees = await _databaseService.getEmployees();
//       emit(EmployeeLoaded(employees));
//     } catch (e) {
//       emit(EmployeeError("Failed to fetch employees"));
//     }
//   }
//
//   Future<void> addEmployee(Employee employee) async {
//     await _databaseService.insertEmployee(employee);
//     fetchEmployees();
//   }
//
//   Future<void> updateEmployee(Employee employee) async {
//     await _databaseService.updateEmployee(employee);
//     fetchEmployees();
//   }
//
//   Future<void> deleteEmployee(int id) async {
//     await _databaseService.deleteEmployee(id);
//     fetchEmployees();
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:employee_management_app/models/employee_adapter.dart';

import 'package:employee_management_app/services/database_service.dart';
import 'package:employee_management_app/viewmodels/employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final DatabaseService _databaseService;

  EmployeeCubit(this._databaseService) : super(EmployeeInitial());

  Future<void> fetchEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = await _databaseService.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError("Failed to fetch employees"));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _databaseService.insertEmployee(employee);
      fetchEmployees(); // Refresh the employee list
    } catch (e) {
      emit(EmployeeError("Failed to add employee"));
    }
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    try {
      await _databaseService.updateEmployee(index, employee);
      fetchEmployees(); // Refresh the employee list
    } catch (e) {
      print(e.toString());
      emit(EmployeeError("Failed to update employee"));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _databaseService.deleteEmployee(id);
      fetchEmployees();
      // final employees = await _databaseService.getEmployees();
      // print('updated Employee list: ${employees.length} ');
      // emit(EmployeeLoaded(employees)); // Refresh the employee list
    } catch (e) {
      print(e.toString());
      emit(EmployeeError("Failed to delete employee ${e.toString()}"));
    }
  }
}