import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class LogDay extends StatefulWidget {
  bool? isEditing;
  Day? day;

  LogDay({super.key, this.isEditing, this.day});

  @override
  State<LogDay> createState() => _LogDayState();
}

class _LogDayState extends State<LogDay> {
  late final ExerciseController _exerciseController;
  List<TextEditingController> _controllers = [];
  final ValueNotifier<List<String>> _exerciseList = ValueNotifier([]);
  bool _isLoading = false;
  String title = "Create Day";

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    if (widget.isEditing ?? false) {
      _exerciseList.value = widget.day!.exerciseList;
      _initializeControllers(_exerciseList.value.length * 4);
      title = widget.day!.name;
    }

    super.initState();
  }

  // Method to initialize TextEditingControllers
  void _initializeControllers(int count) {
    _controllers = List.generate(count, (index) => TextEditingController());
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
        child: customButton(onTap: logDay, title: "Save",isLoading: _isLoading),
      ),
    );
  }

  Future<void> logDay() async {
    final List<Map<String, dynamic>> exerciseList = [];
    List<int> controllerIndices = [];




    DocumentReference userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // SnackBarMessenger.of(context).showWarning("Please name this Day");
    //  _exerciseController.saveDay(
    //      Day(exerciseList: _exerciseList.value, name: _nameController.text));


    for (var e in _exerciseList.value) {
      Exercise exercise =
          _exerciseController.exerciseList.singleWhere((ex) => ex.id == e);
      int baseIndex = _exerciseList.value.indexOf(e);
      Exercise exerciseToSave = exercise;

      if (exercise.reps) {
        if (_controllers[1 + (baseIndex * 4) - 1].text.isEmpty) {
          SnackBarMessenger.of(context)
              .showWarning("Please fill ${exercise.name}: Reps");
          return;
        }
        exerciseToSave = Exercise(
          id: exerciseToSave.id,
          name: exerciseToSave.name,
          distance: exerciseToSave.distance,
          reps: exerciseToSave.reps,
          sets: exerciseToSave.sets,
          weight: exerciseToSave.weight,
          repsVal: _controllers[1 + (baseIndex * 4) - 1].text,
          userRef: userRef,
        );
      }
      if (exercise.distance) {
        if (_controllers[2 + (baseIndex * 4) - 1].text.isEmpty) {
          SnackBarMessenger.of(context)
              .showWarning("Please fill ${exercise.name}: Distance");
          return;
        }
        exerciseToSave = Exercise(
          id: exerciseToSave.id,
          name: exerciseToSave.name,
          distance: exerciseToSave.distance,
          reps: exerciseToSave.reps,
          sets: exerciseToSave.sets,
          weight: exerciseToSave.weight,
          repsVal: exerciseToSave.repsVal ?? '0',
          distanceVal: _controllers[2 + (baseIndex * 4) - 1].text,
          userRef: userRef,
        );
      }
      if (exercise.sets) {
        if (_controllers[3 + (baseIndex * 4) - 1].text.isEmpty) {
          SnackBarMessenger.of(context)
              .showWarning("Please fill ${exercise.name}: Sets");
          return;
        }

        exerciseToSave = Exercise(
          id: exerciseToSave.id,
          name: exerciseToSave.name,
          distance: exerciseToSave.distance,
          reps: exerciseToSave.reps,
          sets: exerciseToSave.sets,
          weight: exerciseToSave.weight,
          repsVal: exerciseToSave.repsVal ?? '0',
          distanceVal: exerciseToSave.distanceVal ?? '0',
          setsVal: _controllers[3 + (baseIndex * 4) - 1].text,
          userRef: userRef,
        );
      }
      if (exercise.weight) {
        controllerIndices.add(4 + (baseIndex * 4) - 1);
        if (_controllers[4 + (baseIndex * 4) - 1].text.isEmpty) {
          SnackBarMessenger.of(context)
              .showWarning("Please fill ${exercise.name}: Weight");
          return;
        }

        exerciseToSave = Exercise(
          id: exerciseToSave.id,
          name: exerciseToSave.name,
          distance: exerciseToSave.distance,
          reps: exerciseToSave.reps,
          sets: exerciseToSave.sets,
          weight: exerciseToSave.weight,
          repsVal: exerciseToSave.repsVal ?? '0',
          distanceVal: exerciseToSave.distanceVal ?? '0',
          setsVal: exerciseToSave.setsVal ?? '0',
          weightVal: _controllers[4 + (baseIndex * 4) - 1].text,
          userRef: userRef,
        );
      }
      exerciseList.add(exerciseToSave.toJson());
      debugPrint(exerciseToSave.toString());
      debugPrint(exerciseToSave.toString());
    }

    DocumentReference dayRef =
        FirebaseFirestore.instance.collection("days").doc(widget.day!.id);

    setState(() {
      _isLoading = true;
    });

    await FirebaseFirestore.instance.collection("DayLogEntries").add({
      "created_at": DateTime.now(),
      "day": dayRef,
      "user": userRef,
      "recorded_data": exerciseList
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });

    debugPrint("Done");
    //Navigator.pop(context);
  }

  Widget exerciseInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
            valueListenable: _exerciseList,
            builder: (a, val, b) {
              return Column(
                children: val.map((exerciseId) {
                  int exerciseIndex = _exerciseList.value.indexOf(exerciseId);
                  int controllerIndex =
                      (exerciseIndex + (exerciseIndex * 4) - 1);
                  debugPrint(controllerIndex.toString());

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
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (e.reps)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              controller:
                                  _controllers[(1 + (exerciseIndex * 4) - 1)],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "e.g 10 Reps",
                                labelText: 'Reps',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.distance)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              controller:
                                  _controllers[(2 + (exerciseIndex * 4) - 1)],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "e.g 1000 meters",
                                labelText: 'Distance',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.sets)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              controller:
                                  _controllers[(3 + (exerciseIndex * 4) - 1)],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "e.g 3 sets",
                                labelText: 'Sets',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        if (e.weight)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10),
                            child: TextField(
                              controller:
                                  _controllers[(4 + (exerciseIndex * 4) - 1)],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
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
      ],
    );
  }
}
