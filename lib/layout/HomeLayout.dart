import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archive_tasks/ArchiveTasksView.dart';
import 'package:to_do_app/modules/done_tasks/DoneTasksView.dart';
import 'package:to_do_app/modules/new_tasks/NewTasksView.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            // body: tasks.length == 0 ? Center(child: CircularProgressIndicator()): cubit.screens[cubit.currentIndex],
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState?.validate() == true) {
                    cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                    // insertToDatabase(
                    //     titleController.text,
                    //     dateController.text,
                    //     timeController.text
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //   getDataFromDatabase(database).then((value) {
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    //
                    // });
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet((context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'title can`t be empty';
                                }
                                return null;
                              },
                              label: 'Task title',
                              prefix: Icons.title),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'time can`t be empty';
                                }
                                return null;
                              },
                              label: 'Task time',
                              prefix: Icons.access_time_outlined),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-09-10'))
                                    .then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'date can`t be empty';
                                }
                                return null;
                              },
                              label: 'Task date',
                              prefix: Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),elevation: 15).closed.then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        },
      ),
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: AppCubit.get(context).currentIndex,
        onTap: (index) {
          AppCubit.get(context).changeIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archive'),
        ]);
  }

}

