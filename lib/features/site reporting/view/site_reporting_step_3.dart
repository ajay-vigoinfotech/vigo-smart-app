import 'package:flutter/material.dart';

class SiteReportingStep3 extends StatefulWidget {
  final int activityId;
  final String activityName;
  final List<Map<String, dynamic>> questions;
  final dynamic value;

  const SiteReportingStep3({
    super.key,
    required this.activityId,
    required this.activityName,
    required this.questions,
    required this.value,
  });

  @override
  State<SiteReportingStep3> createState() => _SiteReportingStep3State();
}

class _SiteReportingStep3State extends State<SiteReportingStep3> {
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                // Questions
                ...uniqueQuestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;

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
                        // Comment Input
                        TextField(
                          decoration:
                              const InputDecoration(hintText: 'Comment'),
                          onChanged: (value) {
                            question['comment'] = value;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<int>(
                                  value: 1,
                                  groupValue: question['selectedOption'],
                                  onChanged: (value) {
                                    setState(() {
                                      question['selectedOption'] = value;
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
                                  groupValue: question['selectedOption'],
                                  onChanged: (value) {
                                    setState(() {
                                      question['selectedOption'] = value;
                                    });
                                  },
                                ),
                                const Text('No'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                // Submit Button
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        //debugPrint('Responses: ${uniqueQuestions.toString()}');
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
}
