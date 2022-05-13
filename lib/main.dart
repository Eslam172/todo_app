import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/home_screen.dart';
import 'package:todo_application/shared/bloc_observer.dart';
import 'package:todo_application/shared/cubit/cubit.dart';

void main() {
  BlocOverrides.runZoned(
        () {
          runApp(const MyApp());

      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home:  HomeScreen(),
    );
  }
}

