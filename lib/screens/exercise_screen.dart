import 'package:fittrack/config/colors.dart';
import 'package:fittrack/config/constants.dart';
import 'package:fittrack/controllers/exercise_controller.dart';
import 'package:fittrack/screens/create_exercise.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late final ExerciseController _exerciseController;

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
      ),
      body: ListenableBuilder(
        listenable: _exerciseController,
        builder: (BuildContext context, Widget? child) {
          if(_exerciseController.isLoadingExercises){
            return const Center(child: CircularProgressIndicator());
          }else if (_exerciseController.exerciseList.isEmpty) {
            return const Center(child: Text("No Exercises!"));
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: _exerciseController.exerciseList
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CreateExercise(
                                          isEditing: true,
                                          exercise: e,
                                        ))),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade200,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black54,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ))
                    .toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed("home.createExercise");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
