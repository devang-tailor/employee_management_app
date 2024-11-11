import 'package:employee_management_app/constants/string_constants.dart';
import 'package:employee_management_app/viewmodels/employee_cubit.dart';
import 'package:employee_management_app/viewmodels/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_edit_employee_view.dart';

class EmployeeListView extends StatefulWidget {
  @override
  _EmployeeListViewState createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  @override
  void initState() {
    super.initState();
    // Fetch employees when the widget is initialized
    context.read<EmployeeCubit>().fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0XffF9F9F8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditEmployeeView()),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(StringConstants.employeeList,style: TextStyle(color: Colors.white),),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            // Separate current and previous employees
            final currentEmployees = state.employees
                .where((employee) => employee.endDate == null)
                .toList();
            final previousEmployees = state.employees
                .where((employee) => employee.endDate != null)
                .toList();

            if (currentEmployees.isEmpty && previousEmployees.isEmpty) {
              return Center(
                child: Image.asset('assets/no_employee_found.png',height: 250,width: 250,),
              );
            }

            return ListView(
              children: [
                // Current Employees Section
                if (currentEmployees.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(StringConstants.currentEmployee,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ...currentEmployees.map((employee) {
                    return Dismissible(
                      key: Key(employee.id.toString()),
                      // Unique key for each employee
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      // Swipe from right to left
                      onDismissed: (direction) {
                        // Remove the employee from the list and show a snackbar
                        context
                            .read<EmployeeCubit>()
                            .deleteEmployee(employee.id!);

                        // Show snackbar with undo option
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${employee.name} deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Add the employee back to the list
                                context
                                    .read<EmployeeCubit>()
                                    .addEmployee(employee);
                              },
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(employee.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.role,
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal)
                            ),
                            const SizedBox(height: 4,),
                            Text(
                              '${employee.getFormattedStartDate()} (Current)',
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal)
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditEmployeeView(employee: employee),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],

                // Previous Employees Section
                if (previousEmployees.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(StringConstants.previousEmployee,
                        style: TextStyle(
                          color: Colors.blueAccent,
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ...previousEmployees.map((employee) {
                    return Dismissible(
                      key: Key(employee.id.toString()),
                      // Unique key for each employee
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      // Swipe from right to left
                      onDismissed: (direction) {

                        context
                            .read<EmployeeCubit>()
                            .deleteEmployee(employee.id!);


                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${employee.name} deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Add the employee back to the list
                                context
                                    .read<EmployeeCubit>()
                                    .addEmployee(employee);
                              },
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(employee.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.role,
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal)
                            ),
                            Text(
                              '${employee.getFormattedStartDate()} - ${employee.getFormattedEndDate()}',
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal)
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditEmployeeView(employee: employee),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(StringConstants.swipeToDelete,style: TextStyle(fontSize: 16,color: Colors.grey),),
                )
              ],
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
