import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/controllers/exercise_controller.dart';
import 'package:fittrack/enums/exercise_enum.dart';
import 'package:fittrack/models/exercise_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/snackbar_messenger.dart';
import '../models/graph_model.dart';
import '../widgets/custom_button.dart';

class AddGraph extends StatefulWidget {
  bool? isEditing;
  Graph? graph;
  AddGraph({super.key, this.isEditing, this.graph});

  @override
  State<AddGraph> createState() => _AddGraphState();
}

class _AddGraphState extends State<AddGraph> {
  late ExerciseController _exerciseController;

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    _exerciseController.getExercises();

    if(widget.isEditing ?? false){
      _selectedExerciseId = widget.graph!.exerciseId;
      _timeFrameVal = widget.graph!.timeFrameInMonth;
      _aggregationVal = Aggregation.values.indexOf(widget.graph!.aggregation);
      _selectedCalculation = Calculations.values.indexOf(widget.graph!.calculations);
      _nameController.text = widget.graph!.name;
      _selectedExerciseMatric = widget.graph!.exerciseMetric;
    }
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  String _selectedExerciseId = '';
  bool _timeFrame = false;
  int _timeFrameVal = -1;
  int _aggregationVal = -1;
  List<String> calculationVal = ["Min", 'Max', 'Avg', 'Total'];
  int _selectedCalculation = -1;
  ExerciseEnum? _selectedExerciseMatric;

  bool _exercise = false;
  bool _matrix = false;
  bool _aggregation = false;
  bool _calculation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Graph"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Graph Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _showTimeSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _timeFrameVal != -1
                          ? "Time Frame : $_timeFrameVal months"
                          : "Time frame",
                      style: TextStyle(
                          fontWeight: _timeFrameVal != -1
                              ? FontWeight.w600
                              : FontWeight.normal),
                    ),
                    Icon(_timeFrame ? Icons.expand_less : Icons.expand_more)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all()),
              child: InkWell(
                onTap: () => _showExerciseSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_exercise
                        ? "Exercise: ${_exerciseController.exerciseList.singleWhere((e) => _selectedExerciseId == e.id).name}"
                        : "Exercise"),
                    Icon(Icons.expand_more)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all()),
              child: InkWell(
                onTap: ()=>_showMaticSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_selectedExerciseMatric!= null ? Text("Metric: ${_selectedExerciseMatric!.name.toUpperCase()}") : Text("Metric"), Icon(Icons.expand_more)],
                ),
              ),
            ),
            InkWell(
              onTap: () => _showAggregationSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_aggregationVal != -1
                        ? "Aggregation : $_aggregationVal Days"
                        : "Aggregation"),
                    Icon(Icons.expand_more)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all()),
              child: InkWell(
                onTap: () {
                  _showCalculationSheet(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedCalculation != -1
                        ? Text(
                            "Calculation : ${calculationVal[_selectedCalculation]}")
                        : const Text("Calculation"),
                    Icon(_calculation ? Icons.expand_less : Icons.expand_more)
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: customButton(onTap: () async {

                  DocumentReference userRef = FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid);

                  if(
                    _nameController.text.isEmpty ||
                    _timeFrameVal == -1 ||
                    _selectedExerciseMatric == null ||
                    _selectedCalculation == -1 ||
                    _aggregationVal == -1 ||
                    _timeFrameVal == -1 ||
                    _selectedExerciseId.isEmpty
                  ){
                    SnackBarMessenger.of(context)
                        .showWarning("Please select all fields");
                    return;
                  }
                  late Graph graph;
                  if(widget.isEditing ?? false){
                    graph = Graph(
                        userRef: userRef,
                        id: widget.graph!.id,
                        name: _nameController.text,
                        createdAt: DateTime.now(),
                        aggregation: Aggregation.values[_aggregationVal],
                        calculations: Calculations.values[_selectedCalculation],
                        exerciseId: _selectedExerciseId,
                        exerciseMetric: _selectedExerciseMatric!,
                        timeFrameInMonth: _timeFrameVal
                    );
                  }else{
                    graph = Graph(
                        userRef: userRef,
                        name: _nameController.text,
                        createdAt: DateTime.now(),
                        aggregation: Aggregation.values[_aggregationVal],
                        calculations: Calculations.values[_selectedCalculation],
                        exerciseId: _selectedExerciseId,
                        exerciseMetric: _selectedExerciseMatric!,
                        timeFrameInMonth: _timeFrameVal
                    );
                  }

                  await _exerciseController.addGraph(graph,update: widget.isEditing ?? false);
                  Navigator.pop(context);
                }, title: (widget.isEditing ?? false) ? "Update" : "Create"))
          ],
        ),
      ),
    );
  }

  void _showCalculationSheet(BuildContext context) {
    setState(() {
      _calculation = !_calculation;
    });

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Calculations',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('How would you prefer the calculations to be.'),
              ),
              const SizedBox(height: 10,),
              ListTile(
                title: Text(calculationVal[0]),
                trailing: (_selectedCalculation == 0) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _calculation = !_calculation;
                    _selectedCalculation = 0;
                  });
                  Navigator.pop(context);
                  print('Selected: ${calculationVal[0]}');
                },
              ),
              ListTile(
                title: Text(calculationVal[1]),
                trailing: (_selectedCalculation == 1) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _calculation = !_calculation;
                    _selectedCalculation = 1;
                  });
                  Navigator.pop(context);
                  print('Selected: ${calculationVal[1]}');
                },
              ),
              ListTile(
                title: Text(calculationVal[2]),
                trailing: (_selectedCalculation == 2) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _calculation = !_calculation;
                    _selectedCalculation = 2;
                  });
                  Navigator.pop(context);
                  print('Selected: ${calculationVal[2]}');
                },
              ),
              ListTile(
                title: Text(calculationVal[3]),
                trailing: (_selectedCalculation == 3) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _calculation = !_calculation;
                    _selectedCalculation = 3;
                  });
                  Navigator.pop(context);
                  print('Selected: ${calculationVal[3]}');
                },
              ),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _calculation = !_calculation;
                  });
                  Navigator.pop(context);
                  print('Action sheet dismissed');
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _showTimeSheet(BuildContext context) {
    setState(() {
      _timeFrame = !_timeFrame;
    });

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Time Frame',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Choose a time frame for the graph'),
              ),
              ListTile(
                title: const Text('1 month'),
                trailing: (_timeFrameVal == 1) ? Icon(Icons.check) : SizedBox(),
                onTap: () {
                  setState(() {
                    _timeFrame = !_timeFrame;
                    _timeFrameVal = 1;
                  });
                  Navigator.pop(context);
                  // Handle selection of "1 month"
                  print('Selected: 1 month');
                },
              ),
              ListTile(
                title: const Text('3 months'),
                trailing: (_timeFrameVal == 3) ? Icon(Icons.check) : SizedBox(),
                onTap: () {
                  setState(() {
                    _timeFrame = !_timeFrame;
                    _timeFrameVal = 3;
                  });
                  Navigator.pop(context);
                  // Handle selection of "3 months"
                  print('Selected: 3 months');
                },
              ),
              ListTile(
                title: const Text('6 months'),
                trailing: (_timeFrameVal == 6) ? Icon(Icons.check) : SizedBox(),
                onTap: () {
                  setState(() {
                    _timeFrame = !_timeFrame;
                    _timeFrameVal = 6;
                  });
                  Navigator.pop(context);
                  // Handle selection of "6 months"
                  print('Selected: 6 months');
                },
              ),
              ListTile(
                title: const Text('1 year'),
                trailing: (_timeFrameVal == 12) ? Icon(Icons.check) : SizedBox(),
                onTap: () {
                  setState(() {
                    _timeFrame = !_timeFrame;
                    _timeFrameVal = 12;
                  });
                  Navigator.pop(context);
                  // Handle selection of "1 year"
                  print('Selected: 1 year');
                },
              ),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _timeFrame = !_timeFrame;
                  });
                  Navigator.pop(context);
                  print('Action sheet dismissed');
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _showMaticSheet(BuildContext context) {
    Exercise? exercise = _exerciseController.exerciseList
        .singleWhere((e) => _selectedExerciseId == e.id);

    setState(() {
      _matrix = !_matrix;
    });

    if (_selectedExerciseId == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an exercise first!")),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Matric',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Choose a time frame for the graph'),
              ),
              SizedBox(height: 10,),
              if (exercise.weight)
                ListTile(
                  title: const Text('Weights'),
                  trailing: (_selectedExerciseMatric == ExerciseEnum.weight)
                      ? const Icon(Icons.check)
                      : const SizedBox(),
                  onTap: () {
                    setState(() {
                      _matrix = !_matrix;
                      _selectedExerciseMatric = ExerciseEnum.weight;
                    });
                    Navigator.pop(context);
                    print('Selected: Weights');
                  },
                ),
              if (exercise.sets)
                ListTile(
                  title: const Text('Sets'),
                  trailing: (_selectedExerciseMatric == ExerciseEnum.sets)
                      ? const Icon(Icons.check)
                      : const SizedBox(),
                  onTap: () {
                    setState(() {
                      _matrix = !_matrix;
                      _selectedExerciseMatric = ExerciseEnum.sets;
                    });
                    Navigator.pop(context);
                    print('Selected: Sets');
                  },
                ),
              if (exercise.reps)
                ListTile(
                  title: const Text('Reps'),
                  trailing: (_selectedExerciseMatric == ExerciseEnum.reps)
                      ? const Icon(Icons.check)
                      : const SizedBox(),
                  onTap: () {
                    setState(() {
                      _matrix = !_matrix;
                      _selectedExerciseMatric = ExerciseEnum.reps;
                    });
                    Navigator.pop(context);
                    print('Selected: Reps');
                  },
                ),
              if (exercise.distance)
                ListTile(
                  title: const Text('Distance'),
                  trailing: (_selectedExerciseMatric == ExerciseEnum.distance)
                      ? const Icon(Icons.check)
                      : const SizedBox(),
                  onTap: () {
                    setState(() {
                      _matrix = !_matrix;
                      _selectedExerciseMatric = ExerciseEnum.distance;
                    });
                    Navigator.pop(context);
                    print('Selected: Distance');
                  },
                ),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _matrix = !_matrix;
                  });
                  Navigator.pop(context);
                  print('Action sheet dismissed');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAggregationSheet(BuildContext context) {
    setState(() {
      _aggregation = !_aggregation;
    });

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Aggregation',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Choose a time frame for the graph'),
              ),

              SizedBox(height: 10,),
              ListTile(
                title: const Text('Daily'),
                trailing: (_aggregationVal == 1) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _aggregation = !_aggregation;
                    _aggregationVal = 1;
                  });
                  Navigator.pop(context);
                  print('Selected: Daily');
                },
              ),
              ListTile(
                title: const Text('Weekly'),
                trailing: (_aggregationVal == 7) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _aggregation = !_aggregation;
                    _aggregationVal = 7;
                  });
                  Navigator.pop(context);
                  print('Selected: Weekly');
                },
              ),
              ListTile(
                title: const Text('Monthly'),
                trailing: (_aggregationVal == 30) ? const Icon(Icons.check) : const SizedBox(),
                onTap: () {
                  setState(() {
                    _aggregation = !_aggregation;
                    _aggregationVal = 30;
                  });
                  Navigator.pop(context);
                  print('Selected: Monthly');
                },
              ),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _aggregation = !_aggregation;
                  });
                  Navigator.pop(context);
                  print('Action sheet dismissed');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExerciseSheet(BuildContext context) {
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
              child: ListenableBuilder(
                listenable: _exerciseController,
                builder: (a, b) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: _exerciseController.exerciseList
                                .map((e) => InkWell(
                                      onTap: () {
                                        _selectedExerciseId = e.id!;
                                        setState(() {
                                          _exercise = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: Colors.amber.shade100),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              if (_selectedExerciseId == e.id)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(Icons.check),
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
                  );
                },
              ));
        });
  }
}
