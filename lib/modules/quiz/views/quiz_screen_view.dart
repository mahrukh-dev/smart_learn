// lib/app/modules/quiz/views/quiz_screen_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_learn/data/models/question_model.dart';
import 'package:smart_learn/modules/quiz/controllers/quiz_controller.dart'; // Import for loading

class QuizScreenView extends GetView<QuizController> {
  const QuizScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent user from going back during the quiz
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Session'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Hide back button
        ),
        body: Obx(() {
          if (controller.currentQuiz.value == null ||
              controller.currentQuiz.value!.questions.isEmpty) {
            return const Center(child: Text('Loading Quiz...'));
          }

          if (controller.isQuizFinished.value) {
            // This case should ideally be handled by the controller navigating to the result screen,
            // but we ensure a fallback here.
            return const Center(child: Text('Quiz Finished.'));
          }

          final QuestionModel currentQuestion = controller.currentQuiz.value!
              .questions[controller.currentQuestionIndex.value];

          return _buildQuizContent(context, currentQuestion);
        }),
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuestionModel question) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildQuizHeader(),
          const SizedBox(height: 20),
          _buildTimerBar(),
          const SizedBox(height: 30),
          _buildQuestionCard(question),
          const SizedBox(height: 20),
          _buildAnswerOptions(question),
          const Spacer(),
          _buildSubmitButton(question),
        ],
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Obx(() {
      final totalQs = controller.totalQuestions.value;
      final currentQsIndex = controller.currentQuestionIndex.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question ${currentQsIndex + 1} of $totalQs',
            style: Get.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          // We can display the score here
          Text(
            'Score: ${controller.correctAnswersCount.value}',
            style: Get.textTheme.titleMedium?.copyWith(color: Colors.green),
          ),
        ],
      );
    });
  }

  Widget _buildTimerBar() {
    return Obx(() {
      // Calculate progress (0.0 to 1.0)
      double progress = controller.timeLeft.value / controller.timePerQuestion;

      // Determine color based on time remaining (red when low)
      Color timerColor = progress > 0.5
          ? Colors.green
          : (progress > 0.2 ? Colors.orange : Colors.red);

      return Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: timerColor,
            minHeight: 10,
          ),
          const SizedBox(height: 10),
          Text(
            'Time left: ${controller.timeLeft.value}s',
            style: TextStyle(fontSize: 18, color: timerColor),
          ),
        ],
      );
    });
  }

  Widget _buildQuestionCard(QuestionModel question) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          question.question,
          style: Get.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(QuestionModel question) {
    return Obx(() {
      return Column(
        children: question.answerOptions.entries.map((entry) {
          final key = entry.key;
          final value = entry.value;

          bool isSelected = controller.selectedAnswer.value == key;
          bool isCorrect = key == question.correctAnswerKey;
          bool isSubmitted = controller.isAnswerSubmitted.value;

          Color? tileColor;
          Color? textColor = Get.textTheme.bodyLarge?.color;

          if (isSubmitted) {
            if (isCorrect) {
              // Highlight correct answer in green after submission
              tileColor = Colors.green.withOpacity(0.2);
              textColor = Colors.green[800];
            } else if (isSelected) {
              // Highlight selected incorrect answer in red
              tileColor = Colors.red.withOpacity(0.2);
              textColor = Colors.red[800];
            }
          } else if (isSelected) {
            // Highlight selected answer before submission (e.g., purple)
            tileColor = Get.theme.primaryColor.withOpacity(0.1);
            textColor = Get.theme.primaryColor;
          }

          return InkWell(
            onTap: isSubmitted ? null : () => controller.selectAnswer(key),
            child: Card(
              color: tileColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: textColor ?? Get.theme.primaryColor,
                      radius: 12,
                      child: Text(key,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (isSubmitted && isCorrect)
                      const Icon(Icons.check_circle, color: Colors.green),
                    if (isSubmitted && isSelected && !isCorrect)
                      const Icon(Icons.close, color: Colors.red),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSubmitButton(QuestionModel question) {
    return Obx(() {
      if (controller.isAnswerSubmitted.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(height: 30),
            Text(
              'Explanation:',
              style: Get.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(question.answerExplaination, style: Get.textTheme.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.nextQuestion,
              child: Text(
                controller.currentQuestionIndex.value ==
                        controller.totalQuestions.value - 1
                    ? 'View Results'
                    : 'Next Question',
              ),
            ),
          ],
        );
      } else {
        return ElevatedButton(
          onPressed: controller.selectedAnswer.value.isNotEmpty
              ? () => controller.submitAnswer(controller.selectedAnswer.value)
              : null,
          child: const Text('Submit Answer'),
        );
      }
    });
  }
}
