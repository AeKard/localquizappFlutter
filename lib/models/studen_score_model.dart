class StudenScoreModel {
  final int id;
  String studentnumber;
  String score;

  StudenScoreModel({
    required this.id,
    required this.studentnumber,
    required this.score,
  });

  factory StudenScoreModel.fromJson(Map<String, dynamic> json) {
    return StudenScoreModel(
      id: int.parse(json['id']),
      studentnumber: json['studentnumber'],
      score: json['score'],
    );
  }
}
