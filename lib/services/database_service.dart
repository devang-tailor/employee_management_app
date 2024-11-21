// /*
// import 'package:employee_management_app/models/employee_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   static Database? _database;
//
//   DatabaseService._internal();
//
//   factory DatabaseService() {
//     return _instance;
//   }
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'employee_database.db');
//     return await openDatabase(
//       path,
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, role TEXT, startDate TEXT, endDate TEXT)', // Add endDate column
//         );
//       },
//       version: 1,
//     );
//   }
//
//   Future<void> insertEmployee(Employee employee) async {
//     final db = await database;
//     await db.insert('employees', employee.toMap());
//   }
//
//   Future<List<Employee>> getEmployees() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('employees');
//     return List.generate(maps.length, (i) {
//       return Employee.fromMap(maps[i]);
//     });
//   }
//
//   Future<void> updateEmployee(Employee employee) async {
//     final db = await database;
//     await db.update('employees', employee.toMap(), where: 'id = ?', whereArgs: [employee.id]);
//   }
//
//   Future<void> deleteEmployee(int id) async {
//     final db = await database;
//     await db.delete('employees', where: 'id = ?', whereArgs: [id]);
//   }
// }
// */

import 'package:employee_management_app/models/employee_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Box<Employee>? employeeBox;
  static Box<int>? idBox; // To store the last used ID

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  // Future<void> init() async {
  //   final appDocumentDir = await getApplicationDocumentsDirectory();
  //   Hive.init(appDocumentDir.path);
  //   Hive.registerAdapter(EmployeeAdapter()); // Register the adapter
  //
  //   _employeeBox = await Hive.openBox<Employee>('employees');
  // }
  Future<void> init() async {
    if (kIsWeb) {
      // Initialize Hive for web (uses IndexedDB)
      await Hive.initFlutter();
    } else {
      // Initialize Hive for mobile (uses file system)
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      // await Hive.initFlutter();
    }

    // Register the adapter
    Hive.registerAdapter(EmployeeAdapter());

    // Open the box
    employeeBox = await Hive.openBox<Employee>('employees');
    idBox = await Hive.openBox<int>('idBox');
  }

  int _getNextId() {
    // If no ID exists in the box, initialize it
    if (idBox!.get('last_id') == null) {
      idBox!.put('last_id', 0);
    }

    // Get the next available ID and increment it
    int nextId = idBox!.get('last_id')! + 1;
    idBox!.put('last_id', nextId); // Save the incremented ID back
    return nextId;
  }

  Future<void> insertEmployee(Employee employee) async {
    int newEmployeeId = _getNextId(); // Get the next unique ID
    Employee newEmployee = Employee(
      id: newEmployeeId,  // Pass the new ID directly here
      name: employee.name,
      role: employee.role,
      startDate: employee.startDate,
      endDate: employee.endDate,
    );
    print('new id $newEmployeeId');
    print('new id ${newEmployee.name}');
    await employeeBox?.put(newEmployeeId, newEmployee);
    print("Employee inserted: $newEmployee");
  }

  Future<List<Employee>> getEmployees() async {
    return employeeBox!.values.toList();
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    await employeeBox?.putAt(index, employee);
  }

  Future<void> deleteEmployee(int id) async {
    print('deleted id : ${id}');
    await employeeBox?.delete(id);
    print("Employee box after deletion: ${employeeBox!.values.toList()}");
  }
}