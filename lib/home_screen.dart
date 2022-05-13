import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/screens/archived_tasks_screen.dart';
import 'package:todo_application/screens/done_tasks_screen.dart';
import 'package:todo_application/screens/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/shared/components/constants.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';


class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context)  => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state) {},
        builder: (context , state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Todo App'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertIntoDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    ).then((value) {
                      Navigator.pop(context);
                    });
                    // insertIntoDatabase(
                    //     title: titleController.text,
                    //     time: timeController.text,
                    //     date: dateController.text
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   fabIcon = Icons.edit;
                    //     // });
                    //     isBottomSheetShown = false;
                    //   });
                    //
                    // });
                  }
                }else{
                  scaffoldKey.currentState?.showBottomSheet((context) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType:TextInputType.text ,
                              validator: (String? value){
                                if(value?.isEmpty == true){

                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('Title'),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.title_outlined),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: timeController,
                              keyboardType:TextInputType.datetime ,
                              validator: (String? value){
                                if(value?.isEmpty == true){

                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              onTap: (){
                                showTimePicker(context: context,
                                    initialTime: TimeOfDay.now()
                                ).then((value) {
                                  timeController.text = value!.format(context).toString();
                                });
                              },
                              readOnly: true,
                              showCursor: true,
                              decoration: const InputDecoration(
                                label: Text('Time'),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.watch_later_outlined),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: dateController,
                              keyboardType:TextInputType.datetime ,
                              validator: (String? value){
                                if(value?.isEmpty == true){

                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              onTap: (){
                                showDatePicker(context: context,
                                    initialDate: DateTime.now()
                                    , firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-06-11')
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                              readOnly: true,
                              showCursor: true,
                              decoration: const InputDecoration(
                                label: Text('Date'),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).closed.then((value) {

                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);

                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);

                }

              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.selectedIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived'
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.selectedIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
          );
    },
      ),
    );
  }

}

// create database
// create table
// open database
// insert to database
// get from database
// update into database
// delete from database



