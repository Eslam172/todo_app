import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/shared/cubit/states.dart';

import '../../screens/archived_tasks_screen.dart';
import '../../screens/done_tasks_screen.dart';
import '../../screens/new_tasks_screen.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  int selectedIndex =0;
  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];


  List<Widget> screens =[
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];

  void changeIndex(int index){
    selectedIndex = index;
    emit(AppChangeBottomNavState());
  }

  void createDatabase() {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database , version){
          print('database created');

          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)').then((value) {
            print('table created');
          }).catchError((error){
            print('Error when creating table ${error.toString()}');
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
          print('database opened');
        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

  Future insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async{
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks (title, time, date, status) VALUES ("$title", "$time", "$date", "new")'
      );
    }).then((value) {
      print(' ${value} raw inserted successfully');
      getDataFromDatabase(database);
      emit(AppInsertDatabaseState());

    }).catchError((error){
      print('Error when inserting record ${error.toString()}');
    });

  }

  void getDataFromDatabase(database) async{

    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       emit(AppGetDatabaseState());
       newTasks=[];
       doneTasks=[];
       archivedTasks=[];

       value.forEach((element) {
         if(element['status'] == 'new'){
           newTasks.add(element);
         }else if(element['status'] == 'done'){
           doneTasks.add(element);
         }else {
           archivedTasks.add(element);
         }
       });
     });

  }
  void updateData({
  required String status,
  required int id,
}){
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]
      ).then((value) {
        emit(AppUpdateDatabaseState());

        getDataFromDatabase(database);
      });
  }

  void deleteData({
    required int id,
  }){
    database.rawDelete(
        'DELETE FROM tasks  WHERE id = ?',
        [ id]
    ).then((value) {

      emit(AppDeleteDatabaseState());

      getDataFromDatabase(database);
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({
  required bool isShow,
  required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

}