import 'package:intl/intl.dart';

class Employee {
  final int? id;
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime? endDate; // Optional end date

  Employee({this.id, required this.name, required this.role, required this.startDate, this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(), // Handle optional end date
    };
  }

  static Employee fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null, // Handle optional end date
    );
  }

  String getFormattedStartDate() {
    return DateFormat('d MMM, y').format(startDate);
  }

  String? getFormattedEndDate() {
    return endDate != null ? DateFormat('d MMM, y').format(endDate!) : null;
  }
}