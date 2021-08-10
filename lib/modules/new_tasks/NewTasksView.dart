import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class NewTasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return AppCubit.get(context).newTasks.length != 0 ? ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
            separatorBuilder: (context, index) => Container(
              height: .5,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length) : Center(child: Text('No new Tasks' , style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),));
      },
    );
  }
}
