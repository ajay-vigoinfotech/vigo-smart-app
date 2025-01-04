import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FamilyDetailsScreen(),
    );
  }
}

class FamilyDetailsScreen extends StatefulWidget {
  @override
  _FamilyDetailsScreenState createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {

  List<Map<String, dynamic>> familyDetails = [
    {"dob": "", "name": "", "relation": "", "relationId": ""},
  ];

  Map<String, dynamic> getFamilyDetailsJson() {
    return {"familyDetails": familyDetails};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ExpansionTile(
            title: Text("Family Details"),
            initiallyExpanded: true,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: familyDetails.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Name (As Per Aadhaar)",
                              ),
                              onChanged: (value) {
                                familyDetails[index]["name"] = value;
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                              ),
                              onChanged: (value) {
                                familyDetails[index]["dob"] = value;
                              },
                            ),
                            DropdownButtonFormField(
                              value: familyDetails[index]["relation"].isNotEmpty
                                  ? familyDetails[index]["relation"]
                                  : null,
                              items: ["Brother", "Sister", "Father", "Mother"].map((relation) {
                                return DropdownMenuItem(
                                  value: relation,
                                  child: Text(relation),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: "Relation",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  familyDetails[index]["relation"] = value ?? "";
                                  familyDetails[index]["relationId"] =
                                  (value == "Brother" ? "1" : value == "Sister" ? "2" : "3");
                                });
                              },
                              hint: Text("Select Relation"),
                            ),
                            if (familyDetails.length > 1)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      familyDetails.removeAt(index);
                                    });
                                  },
                                  child: Text(
                                    "Remove",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      familyDetails.add({
                        "dob": "",
                        "name": "",
                        "relation": "",
                        "relationId": ""
                      });
                    });
                  },
                  child: Text(
                    "+ Add More",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String jsonOutput = jsonEncode(getFamilyDetailsJson());

                  // final jsonOutput = getFamilyDetailsJson();
                  print(jsonOutput);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Data saved successfully!"),
                    ),
                  );
                },
                child: Text("Submit and Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
