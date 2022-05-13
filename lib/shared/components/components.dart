import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archived', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  size: 30,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
