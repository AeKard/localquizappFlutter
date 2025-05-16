import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizapp/models/question_model.dart';

class DeleteQuestion extends StatefulWidget {
  const DeleteQuestion({super.key});

  @override
  State<DeleteQuestion> createState() => _DeleteQuestionState();
}

class _DeleteQuestionState extends State<DeleteQuestion> {
  Set<int> selectedQuestionIds = {};
  bool isMultiSelectMode = false;
  bool _isDeleting = false;

  Future<List<QuestionModel>> fetchQuestions() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/getquestion.php",
    );
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => QuestionModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load questions");
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
      return [];
    }
  }

  Future<void> deleteQuestionsFromServer(Set<int> ids) async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/deletequestions.php",
    );
    debugPrint(jsonEncode({'ids': ids.toList()}));

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ids': ids.toList()}),
      );
      if (response.statusCode == 200) {
        debugPrint("Questions deleted successfully");
      } else {
        throw Exception("Failed to delete questions");
      }
    } catch (e) {
      debugPrint("Error deleting questions: $e");
    }
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedQuestionIds.contains(id)) {
        selectedQuestionIds.remove(id);
      } else {
        selectedQuestionIds.add(id);
      }
    });
  }

  void deleteSelectedQuestions() async {
    if (_isDeleting) return;
    _isDeleting = true;
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Delete Selected"),
            content: Text(
              "Are you sure you want to delete ${selectedQuestionIds.length} selected questions?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm != true) {
      _isDeleting = false;
      return;
    }

    await deleteQuestionsFromServer(selectedQuestionIds);

    setState(() {
      isMultiSelectMode = false;
      selectedQuestionIds.clear();
    });
    _isDeleting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: FutureBuilder<List<QuestionModel>>(
        future: fetchQuestions(), // Function that fetches question list
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading questions"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No questions found"));
          }

          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              // final isSelected = selectedQuestionIds.contains(question.id);

              return ListTile(
                onLongPress: () {
                  setState(() => isMultiSelectMode = true);
                  toggleSelection(question.id);
                },
                onTap: () {
                  if (isMultiSelectMode) {
                    toggleSelection(question.id);
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text("Question Details"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Q: ${question.question}"),
                                Text("A: ${question.optionA}"),
                                Text("B: ${question.optionB}"),
                                Text("C: ${question.optionC}"),
                                Text("D: ${question.optionD}"),
                                Text("Answer: ${question.answer}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Close"),
                              ),
                            ],
                          ),
                    );
                  }
                },
                leading:
                    isMultiSelectMode
                        ? Checkbox(
                          value: selectedQuestionIds.contains(question.id),
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedQuestionIds.add(question.id);
                            } else {
                              selectedQuestionIds.remove(question.id);
                              if (selectedQuestionIds.isEmpty) {
                                isMultiSelectMode = false;
                              }
                            }
                            setState(() {
                              if (value == true) {
                                selectedQuestionIds.add(question.id);
                              } else {
                                selectedQuestionIds.remove(question.id);
                              }
                            });
                          },
                        )
                        : null,
                title: Text(question.question),
              );
            },
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: isMultiSelectMode,
        child: FloatingActionButton(
          onPressed: deleteSelectedQuestions,
          backgroundColor: Colors.red,
          child: Icon(Icons.delete),
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Delete Question : Hold To Delete",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions:
          isMultiSelectMode
              ? [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isMultiSelectMode = false;
                      selectedQuestionIds.clear();
                    });
                  },
                ),
              ]
              : [],
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/arrow-left-solid.svg'),
        ),
      ),
    );
  }
}
