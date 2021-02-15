import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/service/db.dart';

class DeployAssessment extends StatefulWidget {
  final assid;
  DeployAssessment(this.assid);
  @override
  _DeployAssessmentState createState() => _DeployAssessmentState();
}

class _DeployAssessmentState extends State<DeployAssessment> {
  final db = DatabaseService();

  DateTime _startDate = DateTime.now();

  DateTime _startTime = DateTime.now();

  DateTime _endTime = DateTime.now();

  String _duration;

  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _startDate = pickedDate;
        _startTime = pickedDate;
      });
    });
  }

  Widget buildDatepicker() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          child: Text('Date'),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          onPressed: () {
            pickDate();
            print(_startDate);
          },
        ),
      ),
    );
  }

  void pickTimeStart() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _startTime = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          time.hour,
          time.minute,
        );
      });
    });
  }

  Widget buildTimePicker() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            pickTimeStart();
          },
          child: Text('Start Time'),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.fromHeight(35)),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
        ),
      ),
    );
  }

  Widget buildTimeDisplay() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            DateFormat('h:mm a').format(_startTime),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildDateDisplay() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            DateFormat('d MMM').format(_startDate),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildDurationOption(String duration, int h, int m) {
    return Flexible(
      fit: FlexFit.loose,
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: _duration == duration
                ? MaterialStateProperty.all(Colors.redAccent)
                : MaterialStateProperty.all(Colors.deepPurpleAccent),
          ),
          child: Text(duration),
          onPressed: () {
            setState(() {
              setDuration(h, m, duration);
            });
            print(duration);
          },
        ),
      ),
    );
  }

  void setDuration(int h, int m, String d) {
    _duration = d;
    _endTime = _startTime.add(Duration(hours: h, minutes: m));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 250,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildDatepicker(),
                        buildDateDisplay(),
                      ],
                    ),
                  ),
                  Divider(),
                  //Time Display and Picker
                  Container(
                    width: 250,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTimePicker(),
                        buildTimeDisplay(),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 350,
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              buildDurationOption('24', 24, 0),
                              buildDurationOption('12', 12, 30),
                              buildDurationOption('6', 6, 0),
                              buildDurationOption('2', 2, 30),
                              buildDurationOption('1', 1, 0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${DateFormat('EEE, MMM d, hh:mm a').format(_startTime)} to ${DateFormat('EEE, MMM d, hh:mm a').format(_endTime)}',
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              color: Colors.brown,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: Text('Deploy'),
                    onPressed: () {
                      if (_startTime != _endTime) {
                        db.addAssessmentDeployment(
                            _startTime, _endTime, widget.assid);
                        Navigator.pop(context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('Select Duration'),
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
