import 'package:cloud_firestore/cloud_firestore.dart';

class Day {
  String? id;
  String name;
  List<String> exerciseList;

  Day({
    this.id,
    required this.name,
    required this.exerciseList,
  });

  factory Day.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;

    final List<dynamic> exerciseList = map["exercise_list"];
    final List<String> exerciseIDList =
    exerciseList.map((e) => e.toString()).toList();

    return Day(name: map["day_name"], id: doc.id, exerciseList: exerciseIDList);
  }
}

class RecordedDay {
  DateTime createdAt;
  DocumentReference dayRef;
  DocumentReference userRef;
  List<RecordedData> recordedDataList;

  RecordedDay({
    required this.userRef,
    required this.createdAt,
    required this.dayRef,
    required this.recordedDataList,
  });

  factory RecordedDay.fromJson(Map<String, dynamic> json) {
    return RecordedDay(
      userRef: json['user'] as DocumentReference,
      createdAt: json['created_at'].toDate(),
      dayRef: json['day'] as DocumentReference,
      recordedDataList: (json['recorded_data'] as List<dynamic>)
          .map((item) => RecordedData.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RecordedData {
  String id;
  String name;
  bool hasDistance;
  bool hasReps;
  bool hasWeight;
  bool hasSets;
  int distanceVal;
  int repsVal;
  int weightVal;
  int setsVal;

  RecordedData({required this.id,
    required this.name,
    required this.hasDistance,
    required this.hasReps,
    required this.hasWeight,
    required this.hasSets,
    required this.setsVal,
    required this.weightVal,
    required this.distanceVal,
    required this.repsVal});


  factory RecordedData.fromMap(Map<String, dynamic> map){
    return RecordedData(
        id: map["id"],
        name: map["exercise_name"],
        hasDistance: map["has_distance"],
        hasReps: map["has_reps"],
        hasWeight: map["has_weight"],
        hasSets: map["has_sets"],
        setsVal: map["setsVal"],
        weightVal: map["weightVal"],
        distanceVal: map["distanceVal"],
        repsVal: map["repsVal"]
    );
  }
}
