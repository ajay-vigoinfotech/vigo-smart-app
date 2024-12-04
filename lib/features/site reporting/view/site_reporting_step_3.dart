import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_step_4.dart';

class SiteReportingStep3 extends StatefulWidget {
  final dynamic activityId;
  final String activityName;
  final List<Map<String, dynamic>> questions;
  final dynamic value;
  final dynamic text;

  const SiteReportingStep3({
    super.key,
    required this.activityId,
    required this.activityName,
    required this.questions,
    required this.value,
    required this.text,
  });

  @override
  State<SiteReportingStep3> createState() => _SiteReportingStep3State();
}

class _SiteReportingStep3State extends State<SiteReportingStep3> {
  final Map<int, Map<String, dynamic>> userResponses = {};
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    // Filter questions by activityId and ensure unique questionId
    final filteredQuestions = widget.questions
        .where((question) => question['activityId'] == widget.activityId)
        .toList();

    // Remove duplicate questions based on questionId
    final uniqueQuestions = {
      for (var question in filteredQuestions) question['questionId']: question
    }.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Reporting'),
      ),
      body: uniqueQuestions.isEmpty
          ? const Center(
        child: Text(
          'No questions available for this activity.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView(
        children: [
          // Header
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Questions List - Steps 3/4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Questions
          ...uniqueQuestions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final questionId = question['questionId'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Text
                  Text(
                    '${index + 1}. ${question['questionName']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue:
                            userResponses[questionId]?['selectedOption'],
                            onChanged: (value) {
                              setState(() {
                                userResponses[questionId] =
                                    userResponses[questionId] ?? {};
                                userResponses[questionId]!['selectedOption'] =
                                    value;
                                showError = false;
                              });
                            },
                          ),
                          const Text('Yes'),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            groupValue:
                            userResponses[questionId]?['selectedOption'],
                            onChanged: (value) {
                              setState(() {
                                userResponses[questionId] =
                                    userResponses[questionId] ?? {};
                                userResponses[questionId]!['selectedOption'] =
                                    value;
                                showError = false; // Reset error if corrected
                              });
                            },
                          ),
                          const Text('No'),
                        ],
                      ),
                    ],
                  ),
                  if (showError &&
                      (userResponses[questionId]?['selectedOption'] == null))
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select an option.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  // Comment Input
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Comment'),
                    onChanged: (value) {
                      userResponses[questionId] = userResponses[questionId] ?? {};
                      userResponses[questionId]!['comment'] = value ;
                    },
                  ),
                ],
              ),
            );
          }),
          // Submit Button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  final isValid = uniqueQuestions.every((question) {
                    final questionId = question['questionId'];
                    return userResponses[questionId]?['selectedOption'] !=
                        null;
                  });

                  if (!isValid) {
                    setState(() {
                      showError = true;
                    });

                    Fluttertoast.showToast(
                      msg: "Please select an option for all questions.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  // Extract individual lists
                  final questionIds = <String>[];
                  final selectedOptions = <String>[];
                  final comments = <String>[];

                  userResponses.forEach((questionId, response) {
                    questionIds.add(questionId.toString());
                    selectedOptions
                        .add(response['selectedOption'] == 1 ? 'yes' : 'no');
                    comments.add((response['comment']?.toString() ?? '').isEmpty ? '-' : response['comment']!);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SiteReportingStep4(
                        value: widget.value,
                        text: widget.text,
                        activityId: widget.activityId.toString(),
                        questionIds: questionIds.map((id) => id.toString()).toList(),
                        selectedOptions: selectedOptions,
                        comments: comments,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'TAKE PHOTO',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
