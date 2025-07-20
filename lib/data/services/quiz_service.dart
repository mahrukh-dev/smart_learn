import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:smart_learn/data/models/question_model.dart';
import 'package:smart_learn/data/models/quiz_model.dart';

class QuizService extends GetxService {
  List<QuizModel> _allQuizzes = [];
  bool _isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    if (_isLoaded) return;
    try {
      String jsonString = await rootBundle.loadString('assets/quiz_data.json');
      List<dynamic> jsonList = json.decode(jsonString);
      _allQuizzes = jsonList.map((json) => QuizModel.fromJson(json)).toList();
      _isLoaded = true;
      print('Loaded ${_allQuizzes.length} quizzes fron JSON.');
    } catch (e) {
      print('Error loading quizzes: $e');
    }
  }

  List<QuizModel> getAllQuizzes() {
    return _allQuizzes;
  }

  List<QuizModel> getQuizzesByTopic(String topicName, int count) {
    List<QuizModel> topicQuizzes = _allQuizzes
        .where(
            (quiz) => quiz.topicName.toLowerCase() == topicName.toLowerCase())
        .toList();
    if (topicQuizzes.isEmpty || count <= 0) {
      return [];
    }
    if (topicQuizzes.isNotEmpty) {
      QuizModel originalQuiz = topicQuizzes.first;
      List<QuestionModel> selectedQuestions = List.from(originalQuiz.questions);
      selectedQuestions.shuffle();
      List<QuestionModel> limitedQuestions =
          selectedQuestions.take(count).toList();
      return [
        QuizModel(
          quizId: originalQuiz.quizId,
          topicName: originalQuiz.topicName,
          questions: limitedQuestions,
        )
      ];
    }
    return [];
  }
}
