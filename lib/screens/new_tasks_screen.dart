import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/shared/components/components.dart';
import 'package:todo_application/shared/components/constants.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {},
      builder: (context , state) {
        var tasks = AppCubit.get(context).newTasks;
        if(tasks.isEmpty){
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.list,size: 60,color: Colors.blueAccent,),
                Text('No tasks yet , please add new tasks',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black45
                ),)
              ],
            ),
          );
        }else{
          return ListView.separated(
              itemBuilder: (context , index) => buildTaskItem(tasks[index],context),
              separatorBuilder: (context , index) => Container(
                width: double.infinity,
                height: 0,
              ),
              itemCount: tasks.length
          );
        }

    },
    );
  }
}
