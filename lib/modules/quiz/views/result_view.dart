import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_learn/modules/quiz/controllers/quiz_controller.dart';
import 'package:smart_learn/routes/app_pages.dart';

class ResultView extends GetView<QuizController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final correctCount = controller.correctAnswersCount.value;
    final totalCount = controller.totalQuestions.value;
    final percentage = (correctCount / totalCount * 100).toStringAsFixed(0);

    // Determine the result message and color
    String message;
    Color color;
    if (correctCount / totalCount >= 0.8) {
      message = 'Excellent!';
      color = Colors.green;
    } else if (correctCount / totalCount >= 0.5) {
      message = 'Good job, keep practicing!';
      color = Colors.orange;
    } else {
      message = 'Keep studying, you can do better!';
      color = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent going back to the quiz
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Completed!',
                style: Get.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 80,
                backgroundColor: color.withOpacity(0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      'Score',
                      style: TextStyle(fontSize: 18, color: color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                message,
                style: Get.textTheme.headlineSmall
                    ?.copyWith(color: color, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'You answered $correctCount out of $totalCount questions correctly.',
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to the Home screen
                    Get.offAllNamed(Routes.HOME);
                  },
                  child: const Text('Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
