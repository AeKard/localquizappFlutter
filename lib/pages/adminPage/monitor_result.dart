import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:quizapp/models/studen_score_model.dart';

class MonitorResult extends StatefulWidget {
  const MonitorResult({super.key});

  @override
  State<MonitorResult> createState() => _MonitorResult();
}

class _MonitorResult extends State<MonitorResult> {
  List<StudenScoreModel> _allScores = [];
  List<StudenScoreModel> _filteredScores = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchFilter = 'ID';
  @override
  void initState() {
    super.initState();
    _fetchStudentScore();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredScores =
          _allScores.where((score) {
            switch (_searchFilter) {
              case 'ID':
                return score.id.toString().contains(query);
              case 'Student Number':
                return score.studentnumber.toLowerCase().contains(query);
              case 'Score':
                return score.score.toLowerCase().contains(query);
              default:
                return false;
            }
          }).toList();
    });
  }

  Future<void> _fetchStudentScore() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/getstudentscore.php",
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _allScores =
            data.map((json) => StudenScoreModel.fromJson(json)).toList();
        setState(() {
          _filteredScores = _allScores;
        });
      } else {
        throw Exception("Failed to load student scores");
      }
    } catch (e) {
      debugPrint("Error fetching scores: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context), body: tablesearch());
  }

  Padding tablesearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: _searchFilter,
                items:
                    <String>['ID', 'Student Number', 'Score'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text("Search by $value"),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _searchFilter = value;
                      _onSearchChanged(); // Re-filter on filter change
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Center(
                      child: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Student Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Score',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows:
                    _filteredScores.map((score) {
                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text(score.id.toString()))),
                          DataCell(Center(child: Text(score.studentnumber))),
                          DataCell(Center(child: Text(score.score))),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Monitor Result",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/admin');
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/arrow-left-solid.svg'),
        ),
      ),
    );
  }
}
