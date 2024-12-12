import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/models/day_model.dart';
import 'package:fittrack/models/exercise_model.dart';
import 'package:fittrack/models/graph_model.dart';
import 'package:flutter/cupertino.dart';

class ExerciseController extends ChangeNotifier {
  List<Day> _dayList = [];

  List<Day> get dayList => _dayList;

  List<Exercise> _exerciseList = [];

  bool isLoadingExercises = false;

  List<Exercise> get exerciseList => _exerciseList;

  void getDays() {}

  void updateExercise(Exercise exercise) {}

  void saveExercise(Exercise exercise) {}

  void getExercises() {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);


    FirebaseFirestore.instance
        .collection("Exercises")
        .where('user', isEqualTo: userRef)
        .snapshots()
        .listen((QuerySnapshot data) {
          _exerciseList.clear();
          for (var doc in data.docs) {
            _exerciseList.add(Exercise.fromJson(doc));
          }
          notifyListeners();
    });
  }

  void updateDay(Day day) {}

  void saveDay(Day day) {}

  Future<void> addGraph(Graph graph, {required bool update}) async {
    if (update) {
      await FirebaseFirestore.instance
          .collection('Graphs')
          .doc(graph.id)
          .update(graph.toJson());
    } else {
      await FirebaseFirestore.instance.collection('Graphs').add(graph.toJson());
    }
  }
}
