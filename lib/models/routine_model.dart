import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  final DateTime? createdAt;
  final List<String> dayList;
  final String name;
  final String user;

  // Constructor
  Routine({
    this.createdAt,
    required this.dayList,
    required this.name,
    required this.user,
  });

  // Factory method for creating a Routine from JSON
  factory Routine.fromJson(DocumentSnapshot doc) {

    final Map<String,dynamic> json = doc as Map<String,dynamic>;

    return Routine(
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      dayList: (json['day_list'] as List<dynamic>?)!.map((e) => e as String).toList(),
      name: json['name'] as String,
      user: json['user'] as String,
    );
  }

  // Method to convert a Routine to JSON
  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt?.toIso8601String(),
      'day_list': dayList,
      'name': name,
      'user': user,
    };
  }
}
