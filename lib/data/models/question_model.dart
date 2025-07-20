class QuestionModel {
  final String question;
  final String correctAnswerKey;
  final Map<String, String> answerOptions;
  final String answerExplaination;

  QuestionModel({
    required this.question,
    required this.correctAnswerKey,
    required this.answerOptions,
    required this.answerExplaination,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> optionsRaw = json['AnswerOptions'] ?? {};
    Map<String, String> options =
        optionsRaw.map((key, value) => MapEntry(key, value.toString()));
    return QuestionModel(
      question: json['Question'] ?? '',
      correctAnswerKey: json['Answer'] ?? '',
      answerOptions: options,
      answerExplaination: json['AnswerExplaination'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Question': question,
      'Answer': correctAnswerKey,
      'AnswerOptions': answerOptions,
      'AnswerExplaination': answerExplaination,
    };
  }
}
