import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/config/colors.dart';
import 'package:fittrack/controllers/exercise_controller.dart';
import 'package:fittrack/models/day_model.dart';
import 'package:fittrack/screens/create_day.dart';
import 'package:fittrack/screens/create_routine_screen.dart';
import 'package:fittrack/screens/day_logging_screen.dart';
import 'package:fittrack/screens/log_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/routine_model.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  late ExerciseController _exerciseController;
  bool _isLoading = true;
  List<Routine> _routines = [];

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    _exerciseController.getDays();
    _getRoutines();
    super.initState();
  }

  Future<void> _getRoutines() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance
        .collection("Routines")
        .where("user", isEqualTo: userRef)
        .get()
        .then((snapshots) {
      for (var doc in snapshots.docs) {
        Routine routine = Routine.fromJson(doc);
        _routines.add(routine);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routines"),
      ),
      body: ListenableBuilder(
        listenable: _exerciseController,
        builder: (a, b) {
          return _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: _routines.map((routine) {
                      return Container(
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: double.maxFinite,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: routine.dayList.map((id) {
                                  final day = _exerciseController.dayList
                                      .singleWhere((d) => d.id! == id);

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () => _openDay(day),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        width: double.maxFinite,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              day.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                            IconButton(icon: Icon(Icons.edit), onPressed: ()=> _editDay(day),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (c) => const CreateRoutineScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _openDay(Day d) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => LogDay(
              isEditing: true,
              day: d,
            )));
  }

  _editDay(Day day){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => CreateDay(
          isEditing: true,
          day: day,
        )));
  }
}
