import 'package:fittrack/config/colors.dart';
import 'package:fittrack/models/exercise_model.dart';
import 'package:fittrack/widgets/bottom_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/exercise_controller.dart';

class CreateExercise extends StatefulWidget {
  bool? isEditing;
  Exercise? exercise;

  CreateExercise({super.key, this.isEditing, this.exercise});

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  late final ExerciseController _exerciseController;
  final TextEditingController _nameController = TextEditingController();

  bool repsSelected = false;
  bool weightSelected = false;
  bool distanceSelected = false;
  bool sets = false;

  String title = "Create Exercise";

  @override
  void initState() {
    if (widget.isEditing ?? false) {
      repsSelected = widget.exercise!.reps;
      weightSelected = widget.exercise!.weight;
      distanceSelected = widget.exercise!.distance;
      sets = widget.exercise!.sets;
      _nameController.text = widget.exercise!.name;
      title = "Edit Exercise";
    }

    _exerciseController = context.read<ExerciseController>();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: exerciseInputWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomControls(
        child: InkWell(
          onTap: () {
            if (!repsSelected &&
                !distanceSelected &&
                !weightSelected &&
                !sets) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("You should track at least one item")));
              return;
            }
            if (_nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Exercise name is required")));
              return;
            }

            if (widget.isEditing ?? false) {
              Exercise exercise = Exercise(
                  id: widget.exercise!.id!,
                  name: _nameController.text,
                  reps: repsSelected,
                  distance: distanceSelected,
                  weight: weightSelected,
                  sets: sets);
              _exerciseController.updateExercise(exercise);
            } else {
              Exercise exercise = Exercise(
                  name: _nameController.text,
                  reps: repsSelected,
                  distance: distanceSelected,
                  weight: weightSelected,
                  sets: sets);
              _exerciseController.saveExercise(exercise);
            }

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Exercise Saved")));
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.isEditing ?? false) ? "Update" : "Save",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              labelText: 'Exercise Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Switch for Reps.
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: const Text('Reps'),
          value: repsSelected,
          onChanged: (val) => setState(() {
            repsSelected = val;
          }),
        ),
        // Switch for Weight.
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: const Text('Weight'),
          value: weightSelected,
          onChanged: (val) => setState(() {
            weightSelected = val;
          }),
        ),
        // Switch for Distance.
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: const Text('Distance'),
          value: distanceSelected,
          onChanged: (val) => setState(() {
            distanceSelected = val;
          }),
        ),
        // Switch for Time.
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: const Text('Time'),
          value: sets,
          onChanged: (val) => setState(() {
            sets = val;
          }),
        ),
      ],
    );
  }
}
