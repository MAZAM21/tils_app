import 'package:flutter/material.dart';

class ClassSchedulingScreen extends StatefulWidget {
  static const routeName = '/schedule-class';
  @override
  _ClassSchedulingScreenState createState() => _ClassSchedulingScreenState();
}

class _ClassSchedulingScreenState extends State<ClassSchedulingScreen> {
  // Your year_subjects map
  final Map<String, Map<String, dynamic>> year_subjects = {
    "Year 1": {
      "Mathematics": ["Section A", "Section B"],
      "English": ["Section A", "Section B", "Section C"],
      // Add more subjects and sections as needed
    },
    // Add more years as needed
  };

  String selectedSection = "";
  List<String> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Scheduling"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: year_subjects.keys
                  .map((section) => buildSectionButton(section))
                  .toList(),
            ),
          ),
          if (selectedSection.isNotEmpty) Expanded(child: buildSubjectGrid()),
        ],
      ),
    );
  }

  Widget buildSectionButton(String section) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedSection = section;
          subjects = year_subjects[section]?.keys.toList() ?? [];
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedSection == section ? Colors.blue : Colors.grey,
      ),
      child: Text(section),
    );
  }

  Widget buildSubjectButton(String subName) {
    // Your implementation of buildSubjectButton
    // Replace this with your actual implementation of WhiteMainButton or any other widget you have.
    return WhiteMainButton(
      text: subName,
      onPressed: () {
        // Handle subject button press here
        // For example, you can navigate to a new screen or perform some other action.
      },
    );
  }

  Widget buildSubjectGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        return buildSubjectButton(subjects[index]);
      },
    );
  }
}

// Replace WhiteMainButton with your predefined widget
class WhiteMainButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  WhiteMainButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
