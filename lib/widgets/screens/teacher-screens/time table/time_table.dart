import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:tils_app/models/meeting.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import './edit-timetable-form.dart';

class CalendarApp extends StatefulWidget {
  // final List<Meeting> _allmeets;
  // CalendarApp(this._allmeets);
  static const routeName = '/time-table';

  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  final db = DatabaseService();
  final ts = TeacherService();
  CalendarController _controller;
  DateTime _jumpToTime = DateTime.now();
  // String _text = '';

  @override
  void initState() {
    _controller = CalendarController();
    _controller.view = CalendarView.workWeek;
    //_text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    super.initState();
  }

  void _updateState(DateTime date) {
    setState(() {
      _jumpToTime = date;
      //_text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    });
  }

  List<String> views = <String>[
    'Day',
    'Week',
    'WorkWeek',
    'Month',
    'Timeline Day',
    'Timeline Week',
    'Timeline WorkWeek'
  ];

  bool myClass = true;

  void calendarTapped(
      CalendarTapDetails calendarTapDetails, List<StudentRank> students) {
    dynamic appointments = calendarTapDetails.appointments;
    if (appointments != null) {
      showElementDetails(appointments[0], students);
    }
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    } else if (_controller.view == CalendarView.day &&
        calendarTapDetails.targetElement == CalendarElement.header) {
      _controller.view = CalendarView.workWeek;
      _updateState(calendarTapDetails.date);
    }
  }

  void onTapCalendar(Meeting tappedClass) {
    Navigator.pushNamed(context, EditTTForm.routeName, arguments: tappedClass);
  }

  void showElementDetails(Meeting selected, List<StudentRank> students) {
    showModalBottomSheet(
      backgroundColor: selected.background,
      context: context,
      builder: (BuildContext context) {
        List<StudentRank> ofSub =
            ts.getStudentsOfSub(students, selected.eventName);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Subject: ${selected.eventName}',
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 235, 215),
                  fontFamily: 'Proxima Nova',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(),
              Text(
                'Starts at: ${DateFormat('d MMM hh mm a').format(selected.from)}',
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 235, 215),
                  fontFamily: 'Proxima Nova',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(),
              Text(
                'Ends at: ${DateFormat('d MMM hh mm a').format(selected.to)}',
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 235, 215),
                  fontFamily: 'Proxima Nova',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                child: Text(
                  'Edit Class',
                  style: TextStyle(
                    color: Color.fromARGB(255, 250, 235, 215),
                    fontFamily: 'Proxima Nova',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onTapCalendar(selected);
                },
              ),
              ElevatedButton(
                child: Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  db.deleteClass(selected.docId, ofSub);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meetingsData = Provider.of<List<Meeting>>(context);
    final teacherData = Provider.of<TeacherUser>(context);
    final students = Provider.of<List<StudentRank>>(context);
    final myClasses = ts.getMyClasses(meetingsData, teacherData.subjects);
    var source = myClasses;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.calendar_today),
          itemBuilder: (BuildContext context) => views.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            setState(() {
              if (value == 'Day') {
                _controller.view = CalendarView.day;
              } else if (value == 'Week') {
                _controller.view = CalendarView.week;
              } else if (value == 'WorkWeek') {
                _controller.view = CalendarView.workWeek;
              } else if (value == 'Month') {
                _controller.view = CalendarView.month;
              } else if (value == 'Timeline Day') {
                _controller.view = CalendarView.timelineDay;
              } else if (value == 'Timeline Week') {
                _controller.view = CalendarView.timelineWeek;
              } else if (value == 'Timeline WorkWeek') {
                _controller.view = CalendarView.timelineWorkWeek;
              }
            });
          },
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (myClass)
                Text(
                  'My Classes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (!myClass)
                Text(
                  'All Classes',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              Switch(
                value: myClass,
                onChanged: (option) {
                  setState(() {
                    myClass = option;
                  });
                },
                inactiveThumbColor: Colors.cyan,
                inactiveTrackColor: Colors.cyanAccent,
                activeColor: Colors.lightGreen,
              ),
              FlatButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
      body: SfCalendar(
        view: _controller.view,
        controller: _controller,
        dataSource: meetingsData != null && myClass
            ? MeetingDataSource(myClasses)
            : meetingsData != null && !myClass
                ? MeetingDataSource(meetingsData)
                : null,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        onTap: (CalendarTapDetails details) {
          DateTime date = details.date;
          print(date.toString());
          calendarTapped(details, students);
        },
        initialDisplayDate: _jumpToTime,
        //maxDate: DateTime.now().add(Duration(days: 7)),
        allowViewNavigation: false,
      ),
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
