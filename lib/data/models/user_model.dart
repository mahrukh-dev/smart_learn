import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String? profilePicture;
  final String? gradeLevel;
  final String? reminderTime;
  final List<Map<String, dynamic>> quizHistory;
  final Map<String, dynamic>? generatedQuiz;

  UserModel({
    required this.uid,
    required this.name,
    this.profilePicture,
    this.gradeLevel,
    this.reminderTime,
    this.quizHistory = const [],
    this.generatedQuiz,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      profilePicture: data['profilePicture'],
      gradeLevel: data['gradeLevel'],
      reminderTime: data['reminderTime'],
      quizHistory: List<Map<String, dynamic>>.from(data['quizHistory'] ?? []),
      generatedQuiz: data['generatedQuiz'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePicture': profilePicture,
      'gradeLevel': gradeLevel,
      'reminderTime': reminderTime,
      'quizHistory': quizHistory,
      'generatedQuiz': generatedQuiz,
    };
  }
}
