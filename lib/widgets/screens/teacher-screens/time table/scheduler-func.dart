import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Years',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Persistant Classes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<int> selectedMonth = {};
  final startTime = DateTime.now();
  List<String> values = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Map<DateTime, DateTime> persistantDates(
      DateTime starttime, DateTime endtime, Set<int> selectedMonths) {
    print(starttime.weekday);
    if (starttime.isAfter(endtime) || selectedMonths.isEmpty) {
      return {};
    }

    int startWeekday = starttime.weekday;
    int currentYear = starttime.year;
    Duration lessonTime = endtime.difference(starttime);
    Map<DateTime, DateTime> result = {};

    for (int month in selectedMonths) {
      if (month < 1 || month > 12) continue;
      DateTime currentDate;
      if (month == starttime.month) {
        print(values[starttime.month]);
        currentDate = DateTime(currentYear, month, starttime.day);
      } else if (month > starttime.month) {
        currentDate = DateTime(currentYear, month, 1);
      } else {
        currentDate = DateTime(currentYear + 1, month, 1);
      }

      // Find the first occurrence of the specified weekday in the month
      while (currentDate.weekday != startWeekday) {
        currentDate = currentDate.add(const Duration(days: 1));
      }

      // Add entries to the result map until the end of the month
      while (currentDate.month == month) {
        result[currentDate] = currentDate.add(lessonTime);
        currentDate = currentDate.add(const Duration(days: 7));
        print(currentDate.weekday);
      }
    }
    print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Months"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: () {
                List<Widget> buttonRows = [];
                for (int i = 1; i < values.length; i += 3) {
                  List<Widget> rowChildren = [];

                  for (int j = i; j < i + 3 && j < values.length; j++) {
                    rowChildren.add(
                      TextButton(
                        onPressed: () {
                          if (selectedMonth.contains(j)) {
                            setState(() {
                              selectedMonth.remove(j);
                            });
                          } else {
                            setState(() {
                              selectedMonth.add(j);
                              print("set state called");
                              selectedMonth.map((e) => print(values[e]));
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          values[j],
                        ),
                      ),
                    );
                  }

                  buttonRows.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rowChildren,
                    ),
                  );
                }

                return buttonRows;
              }(),
            ),
            Column(
                children: selectedMonth.map((e) => Text(values[e])).toList()),
            TextButton(
                onPressed: () {
                  persistantDates(startTime,
                      startTime.add(const Duration(hours: 3)), selectedMonth);
                },
                child: const Text("Generate Presistant Dates"))
          ],
        ),
      ),
    );
  }
}
