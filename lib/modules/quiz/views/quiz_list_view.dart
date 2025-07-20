import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_learn/modules/quiz/controllers/quiz_controller.dart';

class QuizListView extends GetView<QuizController> {
  const QuizListView({super.key});

  @override
  Widget build(BuildContext context) {
    // We use QuizController here, ensuring it's initialized via QuizBinding
    final QuizController quizController = Get.find<QuizController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz Topic'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a subject and quiz length:',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: quizController.availableTopics.length,
                itemBuilder: (context, index) {
                  final topic = quizController.availableTopics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          const Icon(Icons.school, color: Colors.deepPurple),
                      title: Text(topic,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          _showQuizLengthDialog(context, topic, quizController),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuizLengthDialog(
      BuildContext context, String topic, QuizController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Start $topic Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select number of questions:'),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('5 Questions'),
              onTap: () {
                Get.back(); // Dismiss dialog
                controller.startQuiz(topic, 5);
              },
            ),
            ListTile(
              title: const Text('10 Questions'),
              onTap: () {
                Get.back();
                controller.startQuiz(topic, 10);
              },
            ),
            ListTile(
              title: const Text('15 Questions'),
              onTap: () {
                Get.back();
                controller.startQuiz(topic, 15);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
