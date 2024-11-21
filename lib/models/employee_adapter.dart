import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'employee_adapter.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime? endDate;

  Employee({this.id, required this.name, required this.role, required this.startDate, this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
  String getFormattedStartDate() {
    return DateFormat('d MMM, y').format(startDate);
  }

  String? getFormattedEndDate() {
    return endDate != null ? DateFormat('d MMM, y').format(endDate!) : null;
  }
}