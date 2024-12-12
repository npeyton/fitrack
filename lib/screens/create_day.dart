import 'package:fittrack/config/colors.dart';
import 'package:fittrack/custom_widgets/snackbar_messenger.dart';
import 'package:fittrack/models/day_model.dart';
import 'package:fittrack/models/exercise_model.dart';
import 'package:fittrack/screens/create_exercise.dart';
import 'package:fittrack/widgets/bottom_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/exercise_controller.dart';
import '../widgets/custom_button.dart';

class CreateDay extends StatefulWidget {
  bool? isEditing;
  Day? day;

  CreateDay({super.key, this.isEditing, this.day});

  @override
  State<CreateDay> createState() => _CreateDayState();
}

class _CreateDayState extends State<CreateDay> {
  late final ExerciseController _exerciseController;
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<List<String>> _exerciseList = ValueNotifier([]);

  String title = "Create Day";

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    if (widget.isEditing ?? false) {
      _exerciseList.value = widget.day!.exerciseList;
      title = widget.day!.name;
      _nameController.text = widget.day!.name;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListenableBuilder(
                listenable: _exerciseController,
                builder: (a, b) {
                  return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: exerciseInputWidget(),
                        );
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomControls(
        child: customButton(
            onTap: createDay,
            title: (widget.isEditing ?? false) ? "Update" : "Save"),
      ),
    );
  }

  void createDay() {
    if (_nameController.text.isEmpty) {
      SnackBarMessenger.of(context).showWarning("Please name this Day");
      return;
    }
    if (_exerciseList.value.isEmpty) {
      //TODO
      SnackBarMessenger.of(context)
          .showWarning("Must have at least one Exercise");
      return;
    }

    if(widget.isEditing ?? false){
      _exerciseController.updateDay(
          Day(exerciseList: _exerciseList.value, name: _nameController.text,id: widget.day!.id!));
    }else{
      _exerciseController.saveDay(
          Day(exerciseList: _exerciseList.value, name: _nameController.text));
    }


    Navigator.pop(context);
  }

  Widget exerciseInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextField for entering exercise name.
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Day Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),

        ValueListenableBuilder(
            valueListenable: _exerciseList,
            builder: (a, val, b) {
              return Column(
                children: val.map((exerciseId) {
                  final Exercise e = _exerciseController.exerciseList
                      .singleWhere((e) => e.id == exerciseId);
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.amber.shade100),
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      List<String> exercise = val;
                                      exercise.remove(e);
                                      _exerciseList.value = List.from(exercise);
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.black87,
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateExercise(
                                                    isEditing: true,
                                                    exercise: e,
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black87,
                                    ))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (e.reps)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "e.g 10 Reps",
                                labelText: 'Reps',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.distance)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "e.g 1000 meters",
                                labelText: 'Distance',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.sets)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "e.g 90 mins",
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.weight)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "e.g 80 kg",
                                labelText: 'Weight',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: customButton(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .75,
                          child: ValueListenableBuilder<List<String>>(
                            valueListenable: _exerciseList,
                            builder: (BuildContext context, List<String> value,
                                Widget? child) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: _exerciseController
                                            .exerciseList
                                            .map((e) => InkWell(
                                                  onTap: () {
                                                    List<String> exerciseList =
                                                        _exerciseList.value;
                                                    exerciseList.add(e.id!);
                                                    _exerciseList.value =
                                                        List.from(exerciseList);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors
                                                              .amber.shade100),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            e.name,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16),
                                                          ),
                                                          if (value.contains(e))
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              child: Icon(
                                                                  Icons.check),
                                                            ),
                                                        ],
                                                      )),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: customButton(
                                          onTap: () {
                                            context.pushNamed(
                                                'home.createExercise');
                                          },
                                          title: "Create Exercise"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ));
                    });
              },
              title: "Add Exercise"),
        ),
      ],
    );
  }
}
