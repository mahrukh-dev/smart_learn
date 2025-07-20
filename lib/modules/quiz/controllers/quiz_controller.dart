// lib/app/modules/quiz/controllers/quiz_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'package:smart_learn/core/utils/app_dialogs.dart';
import 'package:smart_learn/data/models/question_model.dart';
import 'package:smart_learn/data/models/quiz_model.dart';
import 'package:smart_learn/data/services/auth_service.dart';
import 'package:smart_learn/data/services/quiz_service.dart';
import 'package:smart_learn/routes/app_pages.dart';

class QuizController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final AuthService _authService = Get.find<AuthService>();

  // State variables for the Quiz
  final Rx<QuizModel?> currentQuiz = Rx<QuizModel?>(null);
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt correctAnswersCount = 0.obs;
  final RxInt totalQuestions = 0.obs;
  final RxBool isQuizFinished = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxBool isAnswerSubmitted = false.obs;

  // Timer variables
  final int timePerQuestion = 40; // 40s per question
  final RxInt timeLeft = 40.obs;
  Timer? _timer;

  // Quiz tracking for history/analytics
  final DateTime _quizStartTime = DateTime.now();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // --- Quiz Selection and Initialization ---

  // Placeholder list of available topics
  final List<String> availableTopics = [
    'Mathematics',
    'History',
    'Science',
    'English'
  ];

  // Start a new quiz based on selected topic and number of questions
  void startQuiz(String topic, int numQuestions) {
    // 1. Fetch the quiz data
    List<QuizModel> quizzes =
        _quizService.getQuizzesByTopic(topic, numQuestions);

    if (quizzes.isEmpty || quizzes.first.questions.isEmpty) {
      AppDialogs.showFlushbar(
          'Error', 'No quizzes found for $topic or invalid selection.',
          isError: true);
      return;
    }

    // We assume the service returns a single QuizModel with the selected questions
    currentQuiz.value = quizzes.first;
    totalQuestions.value = currentQuiz.value!.questions.length;
    currentQuestionIndex.value = 0;
    correctAnswersCount.value = 0;
    isQuizFinished.value = false;

    // Start the quiz flow
    _startQuestionTimer();
    Get.toNamed(Routes.QUIZ_SCREEN);
  }

  // --- Quiz Navigation and Timer ---

  void _startQuestionTimer() {
    _timer?.cancel();
    timeLeft.value = timePerQuestion;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        // Time is up, auto-submit the answer (as incorrect if none selected)
        _timer?.cancel();
        submitAnswer(null);
      }
    });
  }

  // Move to the next question or finish the quiz
  void nextQuestion() {
    selectedAnswer.value = '';
    isAnswerSubmitted.value = false;

    if (currentQuestionIndex.value < totalQuestions.value - 1) {
      currentQuestionIndex.value++;
      _startQuestionTimer();
    } else {
      finishQuiz();
    }
  }

  // --- Answering and Scoring ---

  // Used by UI to select an option
  void selectAnswer(String answerKey) {
    if (!isAnswerSubmitted.value) {
      selectedAnswer.value = answerKey;
    }
  }

  // Submit the selected answer or null if time runs out
  void submitAnswer(String? answerKey) {
    _timer?.cancel();
    isAnswerSubmitted.value = true;

    // Determine the answer key used (selected or none if timed out)
    String submittedKey = answerKey ?? selectedAnswer.value;

    if (submittedKey.isNotEmpty) {
      QuestionModel question =
          currentQuiz.value!.questions[currentQuestionIndex.value];

      if (submittedKey == question.correctAnswerKey) {
        correctAnswersCount.value++;
      }
    }

    // We delay slightly to allow the user to see the result before moving on
    // This delay will be handled in the QuizScreenView when the user presses 'Next'
  }

  // --- Quiz Completion and Results ---

  void finishQuiz() {
    isQuizFinished.value = true;
    _timer?.cancel();

    // Calculate total time taken
    Duration timeTaken = DateTime.now().difference(_quizStartTime);

    // Save quiz history (implementation will go here later in the AuthService/Firestore)
    // We'll add this feature when implementing Performance Analytics (Feature 5)

    // Navigate to the results screen
    Get.offNamed(Routes.RESULT_SCREEN);
  }
}
