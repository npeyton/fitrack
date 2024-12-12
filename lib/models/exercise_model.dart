import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String? id; // Nullable to reflect String!
  final String name;
  final bool distance;
  final bool reps;
  final bool sets;
  final bool weight;
  final String? repsVal;
  final String? distanceVal;
  final String? setsVal;
  final String? weightVal;
  final DateTime? createdAt;
  final DocumentReference? userRef;

  // Constructor
  Exercise({
    this.id,
    required this.name,
    required this.distance,
    required this.reps,
    required this.sets,
    required this.weight,
    this.weightVal,
    this.distanceVal,
    this.setsVal,
    this.repsVal,
    this.createdAt,
    this.userRef,
  });

  // Factory method for creating an Exercise from JSON
  factory Exercise.fromJson(DocumentSnapshot doc) {

    Map<String,dynamic> json = doc.data() as Map<String,dynamic>;

    return Exercise(
      id: doc.id,
      name: json['exercise_name'] as String,
      distance: json['has_distance'] as bool,
      reps: json['has_weight'] as bool,
      sets: json['has_sets'] as bool,
      weight: json['has_reps'] as bool,
      userRef: json['user'],
      createdAt: json['created_at'].toDate(),
    );
  }

  // Method to convert an Exercise to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'reps': reps,
      'sets': sets,
      'weight': weight,
      'repsVal': repsVal,
      'distanceVal': distanceVal,
      'setsVal': setsVal,
      'weightVal': weightVal,
      'userRef': userRef,
    };
  }
}
