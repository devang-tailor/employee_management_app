import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/employee_list_view.dart';
import 'viewmodels/employee_cubit.dart';
import 'services/database_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        BlocProvider<EmployeeCubit>(
          create: (context) => EmployeeCubit(
            context.read<DatabaseService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Employee Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EmployeeListView(),
      ),
    );
  }
}
