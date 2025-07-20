import 'package:smart_learn/data/models/question_model.dart';

class QuizModel {
  final String quizId;
  final String topicName;
  final List<QuestionModel> questions;

  QuizModel({
    required this.quizId,
    required this.topicName,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quiz_id'] ?? '',
      topicName: json['TopicName'] ?? 'Unknown Topic',
      questions: (json['Questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'TopicName': topicName,
      'Questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
