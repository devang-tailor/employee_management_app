import 'package:employee_management_app/constants/string_constants.dart';
import 'package:employee_management_app/models/employee_model.dart';
import 'package:employee_management_app/viewmodels/employee_cubit.dart';
import 'package:employee_management_app/views/widegt/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEditEmployeeView extends StatefulWidget {
  final Employee? employee;

  AddEditEmployeeView({this.employee});

  @override
  _AddEditEmployeeViewState createState() => _AddEditEmployeeViewState();
}

class _AddEditEmployeeViewState extends State<AddEditEmployeeView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime? _endDate; // Optional end date

  final List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _roleController.text = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee!.endDate; // Handle end date
    }
  }

  Future<void> _selectRole(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: roles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(roles[index]),
              )),
              onTap: () {
                _roleController.text = roles[index];
                Navigator.pop(context);
                setState(() {}); // Update the state
              },
            );
          },
        );
      },
    );
  }

  // Future<void> _selectStartDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //
  //     initialDate: _startDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != _startDate) {
  //     setState(() {
  //       _startDate = picked;
  //
  //       // Reset end date if it's before the new start date
  //       if (_endDate != null && _endDate!.isBefore(_startDate)) {
  //         _endDate = null; // Clear end date if it's invalid
  //       }
  //     });
  //   }
  // }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return const CustomDatePicker(isEndDatePicker: false,);
      },
    );

    if (picked != null && picked != _startDate) {

      setState(() {
        print(picked);
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return const CustomDatePicker(isEndDatePicker: true,);
      },
    );

    if (picked != null && picked != _endDate) {

      setState(() {
        print(picked);
        _endDate = picked;
      });
    }
  }

  // Future<void> _selectEndDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _endDate ?? _startDate, // Start with current end date or start date
  //     firstDate: _startDate, // End date should be after start date
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _endDate = picked; // Update end date
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? StringConstants.addEmployeeDetails : StringConstants.editEmployeeDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: StringConstants.employeeName,
                  labelStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                  prefixIcon: const Icon(Icons.person, color:Colors.blueAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),

                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all( width: 1.0,color: Colors.black.withOpacity(.2)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.cases_rounded,color: Colors.blueAccent,),
                  title: Text(_roleController.text.isNotEmpty ? _roleController.text : StringConstants.selectRole,
                   style: TextStyle(color: Colors.grey.withOpacity(.8),),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                  onTap: () => _selectRole(context),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Start Date Picker
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all( width: 1.0,color: Colors.black.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(" ${_startDate.isToday() ? StringConstants.today : DateFormat('dd MMM yyyy').format(_startDate!.toLocal())}"),
                        leading: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_today,color: Colors.blueAccent,),
                        ),
                        /*     onTap: () => CustomDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      onDateChanged: (newDate) {
                        setState(() {
                          _startDate = newDate;
                          // Reset end date if it's before the new start date
                          if (_endDate != null && _endDate!.isBefore(_startDate)) {
                            _endDate = null; // Clear end date if it's invalid
                          }
                        });
                      },
                                      ),*/
                        onTap: () =>  _selectStartDate(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  const Icon(Icons.arrow_right_alt_rounded, size: 20,color: Colors.blueAccent,),
                  const SizedBox(width: 10.0,),

                  // End Date Picker
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all( width: 1.0, color: Colors.grey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(" ${_endDate != null ? DateFormat('dd MMM yyyy').format(_endDate!.toLocal()) : 'No date'}"),
                        
                        leading: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_today,color: Colors.blueAccent,),
                        ),
                        /*    onTap: () => CustomDatePicker(
                      context: context,
                      initialDate: _endDate ?? _startDate,
                      firstDate: _startDate,
                      lastDate: DateTime(2101),
                      onDateChanged: (newDate) {
                        setState(() {
                          _endDate = newDate; // Update end date
                        });
                      },
                                      ),*/

                        onTap: () => _selectEndDate(context),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /*ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.employee != null) {
                      // Update existing employee
                      context.read<EmployeeCubit>().updateEmployee(
                        Employee(
                          id: widget.employee!.id,
                          name: _nameController.text,
                          role: _roleController.text,
                          startDate: _startDate,
                          endDate: _endDate, // Include end date
                        ),
                      );
                    } else {
                      // Add new employee
                      context.read<EmployeeCubit>().addEmployee(
                        Employee(
                          name: _nameController.text,
                          role: _roleController.text,
                          startDate: _startDate,
                          endDate: _endDate, // Include end date
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.employee == null ? 'Add Employee' : 'Update Employee'),
              ),*/
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style:  const ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)))),
                  backgroundColor: WidgetStatePropertyAll(Colors.lightBlue)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(StringConstants.cancel,style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)))),
                  backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.employee != null) {
                    // Update existing employee
                    context.read<EmployeeCubit>().updateEmployee(
                      Employee(
                        id: widget.employee!.id,
                        name: _nameController.text,
                        role: _roleController.text,
                        startDate: _startDate,
                        endDate: _endDate, // Include end date
                      ),
                    );
                  } else {
                    // Add new employee
                    context.read<EmployeeCubit>().addEmployee(
                      Employee(
                        name: _nameController.text,
                        role: _roleController.text,
                        startDate: _startDate,
                        endDate: _endDate, // Include end date
                      ),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child:  const Text(StringConstants.saveButton,style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ) ,
    );
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}