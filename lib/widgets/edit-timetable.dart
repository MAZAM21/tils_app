import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subject.dart';

import '../providers/all_classes.dart';
import 'package:provider/provider.dart';

class EditTT extends StatefulWidget {
  static const routeName = '/edit-tt';
  @override
  _EditTTState createState() => _EditTTState();
}

class _EditTTState extends State<EditTT> {
  DateTime _dateSelected = DateTime.now();
  DateTime _dateStart = DateTime.now();
  int _duration;
  String _chosenSub;
  //Meeting classAdded;

  List<String> _allSubjects = [
    'Conflict',
    'Islamic',
    'Jurisprudence',
    'Trust',
  ];
  final _durationController = TextEditingController();

  SubjectName stringToEnum(String name) {
    switch (name) {
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

//Function shows time picker, then converts TimeofDay value into Datetime and assigns it to _dateStart
  void pickTimeStart() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _dateStart = DateTime(
          _dateSelected.year,
          _dateSelected.month,
          _dateSelected.day,
          time.hour,
          time.minute,
        );
      });
    });
  }

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
        _dateSelected = pickedDate;
      });
    });
  }

  void durationSetter() {
    if (_durationController == null) {
      return;
    } else {
      _duration = int.parse(_durationController.text);
    }
  }

  Widget buildDropdown() {
    return Container(
      child: DropdownButton(
        value: _chosenSub,
        style: Theme.of(context).textTheme.headline4,
        items: _allSubjects.map<DropdownMenuItem<String>>((String chosen) {
          return DropdownMenuItem<String>(
            value: chosen,
            child: Text(chosen),
          );
        }).toList(),
        onChanged: (String chosen) {
          setState(() {
            _chosenSub = chosen;
          });
        },
      ),
    );
  }

  Widget buildDatepicker() {
    return Container(
      child: ElevatedButton(
        child: Text('Pick date'),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(35)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
        onPressed: () {
          pickDate();
          print(_dateSelected);
        },
      ),
    );
  }

  Widget buildDateDisplay() {
    return SizedBox(
      height: 45,
      child: Card(
        color: Theme.of(context).canvasColor,
        child: Text(
          DateFormat('d MMM').format(_dateSelected),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildTimePicker() {
    return Container(
      height: 45,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ElevatedButton(
              onPressed: () {
                pickTimeStart();
              },
              child: Text('Pick Start Time'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size.fromHeight(35)),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
          //Duration setter
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Duration',
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: _durationController,
                onSubmitted: (_) => durationSetter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeDisplay() {
    return SizedBox(
      height: 45,
      child: Card(
        color: Theme.of(context).canvasColor,
        child: Text(
          DateFormat('h:mm a').format(_dateStart),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  

  Widget buildSubmitButton(AllClasses meetingsData) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          //Dialog box
          if (_dateStart == null ||
              _chosenSub == 'None Chosen' ||
              _duration == null) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                title: Text('Fields Incorrect'),
                content: Text('Please fill all fields correctly'),
              ),
            );
          } else {
            // meetingsData.addMeeting(
            //   _dateStart,
            //   stringToEnum(_chosenSub),
            //   _duration,
            // );
            //Navigator.pushReplacementNamed(context, CalendarApp.routeName);
            Navigator.pop(context);
          }
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(35)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
        child: Text('Submit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meetingsData = Provider.of<AllClasses>(context);

    //final thisMeeting = meetingsData.allClassMeetings;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            'Edit Time Table',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Subject Dropdown
                  buildDropdown(),
                  //Date Picker
                  buildDatepicker(),
                  //Date display
                  buildDateDisplay(),
                  //Time picker
                  buildTimePicker(),
                  //Time display
                  buildTimeDisplay(),
                  //Submit Button
                  buildSubmitButton(meetingsData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// TimeOfDay t;
// final now = new DateTime.now();
// return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
