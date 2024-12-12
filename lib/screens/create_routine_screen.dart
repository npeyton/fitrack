import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/widgets/bottom_controls.dart';
import 'package:fittrack/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/exercise_controller.dart';
import '../custom_widgets/snackbar_messenger.dart';
import '../models/day_model.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  late ExerciseController _exerciseController;
  final TextEditingController _nameController = TextEditingController();
  List<Day> _days = [];
  bool _isSaving = false;

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    _exerciseController.getDays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Routine"),
      ),
      body: ListenableBuilder(
        listenable: _exerciseController,
        builder: (a, b) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _days
                        .map((d) => InkWell(
                              onTap: () {},
                              child: Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.amber.shade100),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        d.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            _days.remove(d);
                                          });
                                        },
                                      )
                                    ],
                                  )),
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: customButton(
                      onTap: () => presentDayBottomSheet(), title: "Add day"),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomControls(
          child: customButton(
              onTap: () => saveRoutine(), title: "Save", isLoading: _isSaving)),
    );
  }

  Future<void> saveRoutine() async {
    if (_isSaving) {
      return;
    }

    if (_nameController.text.isEmpty) {
      SnackBarMessenger.of(context).showWarning("Please name this Routine");
      return;
    }
    if (_days.isEmpty) {
      SnackBarMessenger.of(context).showWarning("Please add at least one day");
      return;
    }

    setState(() {
      _isSaving = true;
    });
    List<String> days = _days.map((day) => day.id!).toList();

    DocumentReference userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.collection("Routines").add({
      "created_at": DateTime.now(),
      "name": _nameController.text,
      "day_list": days,
      "user": userRef
    }).then((val) {
      SnackBarMessenger.of(context).showSuccess("Saved Successfully");
      setState(() {
        _isSaving = true;
      });
      Navigator.of(context).pop();
    });
  }

  void presentDayBottomSheet() {
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: _exerciseController.dayList
                            .map((d) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      _days.add(d);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.amber.shade100),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            d.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
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
                            context.pushNamed('home.createExercise');
                          },
                          title: "Create Exercise"),
                    ),
                  ],
                ),
              ));
        });
  }
}
