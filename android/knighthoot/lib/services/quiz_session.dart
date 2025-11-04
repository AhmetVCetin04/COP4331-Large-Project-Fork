class QuizSession {
  final String testID;
  final String testName;
  final int currentQuestion;
  final int totalQuestions;
  final bool isLive;
  final List<Question> questions;

  QuizSession({
    required this.testID,
    required this.testName,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.isLive,
    required this.questions,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    List<Question> questionsList = [];
    if (json['questions'] != null) {
      questionsList = (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList();
    }

    return QuizSession(
      testID: json['ID'] ?? json['testID'] ?? '',
      testName: json['testName'] ?? 'Quiz',
      currentQuestion: json['currentQuestion'] ?? -1,
      totalQuestions: questionsList.length,
      isLive: json['isLive'] ?? false,
      questions: questionsList,
    );
  }
}

class Question {
  final String questionText;
  final List<String> choices;
  final String? correctAnswer;

  Question({
    required this.questionText,
    required this.choices,
    this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['question'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
      correctAnswer: json['answer'],
    );
  }
}
