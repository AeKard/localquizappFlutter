class QuestionModel {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String answer;

  QuestionModel({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: int.parse(json['id']),
      question: json['question'],
      optionA: json['a'],
      optionB: json['b'],
      optionC: json['c'],
      optionD: json['d'],
      answer: json['answer_letter'],
    );
  }
}
