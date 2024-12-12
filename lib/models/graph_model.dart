import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/enums/exercise_enum.dart';
import 'package:fittrack/models/exercise_model.dart';

enum Calculations { min, max, avg, total }

enum Aggregation { daily, weekly, monthly }

class Graph {
  String name;
  String? id;
  DocumentReference? userRef;
  DateTime? createdAt;
  int timeFrameInMonth;
  String exerciseId;
  ExerciseEnum exerciseMetric;
  Aggregation aggregation;
  Calculations calculations;

  Graph(
      {required this.name,
      this.id,
      this.userRef,
      this.createdAt,
      required this.timeFrameInMonth,
      required this.exerciseId,
      required this.exerciseMetric,
      required this.aggregation,
      required this.calculations});

  Map<String, dynamic> toJson() {
    return {
      'exercise_name': name,
      'id': id,
      'user_ref': userRef,
      'calculations': calculations.name,
      'aggregation': aggregation.name,
      'metric': exerciseMetric.name,
      'exercise_id': exerciseId,
      'time_frame_in_month': timeFrameInMonth,
      'created_at': createdAt
    };
  }

  factory Graph.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    return Graph(
      name: map['exercise_name'],
      id: doc.id,
      userRef: map['user_ref'],

      createdAt: map['created_at'].toDate(),
      timeFrameInMonth: map['time_frame_in_month'],
      exerciseId: map['exercise_id'],
      exerciseMetric:
          ExerciseEnum.values.firstWhere((e) => e.name == map['metric']),
      aggregation:
          Aggregation.values.firstWhere((e) => e.name == map['aggregation']),
      calculations:
          Calculations.values.firstWhere((e) => e.name == map['calculations']),
    );
  }
}
