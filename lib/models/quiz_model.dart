class QuizQuestion {
  final int id;
  final String question;
  final String a;
  final String b;
  final String c;
  final String d;
  final String answerLetter;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.answerLetter,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: int.parse(json['id']),
      question: json['question'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      d: json['d'],
      answerLetter: json['answer_letter'],
    );
  }
}
