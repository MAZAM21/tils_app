import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/meeting.dart';

import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/db.dart';
import './time_table.dart';

class EditTTForm extends StatefulWidget {
  static const routeName = '/edit-tt-form';

  @override
  _EditTTFormState createState() => _EditTTFormState();
}

class _EditTTFormState extends State<EditTTForm> {
  DateTime _startDate = DateTime.now();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  SubjectName _subName;

  String _duration;
  int _customHours = 0;
  int _customMinutes = 0;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isEdit = false;
  String _editedId;

  final db = DatabaseService();
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final editClass = ModalRoute.of(context).settings.arguments as Meeting;
      if (editClass != null) {
        _startDate = editClass.from;
        _startTime = editClass.from;
        _endTime = editClass.to;
        _subName = checkSubject(editClass.eventName);
        _isEdit = true;
        _editedId = editClass.docId;
      }
      //if a route argument is passed to this then it copies the passed values to the local variables and executes findMeetingIndex to get the index of the edited element.
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //sets _subName to SubjectName enum
  void setSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        _subName = SubjectName.Jurisprudence;
        break;
      case 'Trust':
        _subName = SubjectName.Trust;
        break;
      case 'Conflict':
        _subName = SubjectName.Conflict;
        break;
      case 'Islamic':
        _subName = SubjectName.Islamic;
        break;
      default:
        _subName = SubjectName.Undeclared;
    }
  }

  //returns string from enum
  String enToString(SubjectName name) {
    switch (name) {
      case SubjectName.Jurisprudence:
        return 'Jurisprudence';
        break;
      case SubjectName.Trust:
        return 'Trust';
        break;
      case SubjectName.Conflict:
        return 'Conflict';
        break;
      case SubjectName.Islamic:
        return 'Islamic';
        break;
      default:
        return 'Undeclared';
    }
  }

//takes string returns subject name
  SubjectName checkSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return SubjectName.Jurisprudence;
        break;
      case 'Trust':
        return SubjectName.Trust;
        break;
      case 'Conflict':
        return SubjectName.Conflict;
        break;
      case 'Islamic':
        return SubjectName.Islamic;
        break;
      default:
        return SubjectName.Undeclared;
    }
  }

//subject option buttons,
//set _subName.
  Widget buildSubjectButton(String subName) {
    return ElevatedButton(
      child: Text(subName),
      onPressed: () {
        setState(() {
          setSubject(subName);
        });
        print(_subName);
      },
      style: ButtonStyle(
        backgroundColor: _subName == checkSubject(subName)
            ? MaterialStateProperty.all(Colors.redAccent)
            : MaterialStateProperty.all(Colors.purple[900]),
      ),
    );
  }

  //date picker
  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: _isEdit ? _startDate : DateTime.now(),
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

  //the date selection button
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

  //Displays date
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

  void pickTimeStart() {
    showTimePicker(
      context: context,
      initialTime:
          _isEdit ? TimeOfDay.fromDateTime(_startDate) : TimeOfDay.now(),
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

// void studentAttendance() {

//     _studentCollection.get().then((allStudDocs) {
//       allStudDocs.docs.forEach((student) {
//         // if (student['registeredSubs'] == true) {
//         attStatus.addAll({student['studentName']: false});
//         //}
//       });
//     }).catchError((err) {
//       print('$err');
//     });

//   }

  void _saveForm(BuildContext context) {
    if (!_endTime.isBefore(_startTime) &&
        _subName != SubjectName.Undeclared &&
        _duration != null) {
      if (!_isEdit) {
        db.addToCF(
          _subName,
          _startTime,
          _endTime,
        );
        setState(() {
          _subName = null;
          _startTime = DateTime.now();
          _duration = null;
        });
      } else {
        db.editInCF(
          _editedId,
          enToString(_subName),
          _startTime,
          _endTime,
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: Text('Fields Incorrect'),
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _form,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      //Subject Buttons
                      Container(
                        height: 200,
                        width: 150,
                        child: Column(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildSubjectButton('Jurisprudence'),
                            buildSubjectButton('Trust'),
                            buildSubjectButton('Conflict'),
                            buildSubjectButton('Islamic'),
                          ],
                        ),
                      ),
                      Divider(),
                      //Date Display and Picker
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
                      Divider(),
                      //Duration presets
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: 400,
                        height: 50,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  buildDurationOption('1', 1, 0),
                                  buildDurationOption('1.5', 1, 30),
                                  buildDurationOption('2', 2, 0),
                                  buildDurationOption('2.5', 2, 30),
                                  buildDurationOption('3', 3, 0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      //Custom duration
                      Container(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Custom Duration',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Lato',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: ElevatedButton(
                                    child: Text(
                                      'H',
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return NumberPickerDialog.integer(
                                            initialIntegerValue: 0,
                                            minValue: 0,
                                            maxValue: 12,
                                            title: Text('H'),
                                          );
                                        },
                                      ).then((value) {
                                        setState(() {
                                          _customHours = value;
                                          setDuration(
                                              _customHours, _customMinutes, '');
                                        });
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 11),
                                      child: Text(
                                        _customHours.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey[900]),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: ElevatedButton(
                                    child: Text(
                                      'M',
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return NumberPickerDialog.integer(
                                            initialIntegerValue: 0,
                                            minValue: 0,
                                            maxValue: 60,
                                            title: Text('Minutes'),
                                          );
                                        },
                                      ).then((value) {
                                        setState(() {
                                          _customMinutes = value;
                                          setDuration(
                                              _customHours, _customMinutes, '');
                                        });
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 40,
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 11),
                                      child: Text(
                                        _customMinutes.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey[900]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      // Save button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Add to Time Table'),
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: _subName != SubjectName.Undeclared &&
                                        _duration != null
                                    ? Text(
                                        '${enToString(_subName)} on ${DateFormat('d MMM hh mm a').format(_startTime)} added to Time Table')
                                    : Text('Class not added'),
                              ));
                              setState(() {
                                _saveForm(context);
                              });
                              if (_isEdit) {
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}