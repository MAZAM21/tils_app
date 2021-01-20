
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:tils_app/models/meeting.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/service/db.dart';
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
  CalendarController _controller;
  DateTime _jumpToTime = DateTime.now();
  String _text = '';

  @override
  void initState() {
    _controller = CalendarController();
    _controller.view = CalendarView.workWeek;
    _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    super.initState();
  }

  void _updateState(DateTime date) {
    setState(() {
      _jumpToTime = date;
      _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    });
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    dynamic appointments = calendarTapDetails.appointments;
    if (appointments != null) {
      showElementDetails(appointments[0]);
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
    Navigator.pushNamed(context, EditTTForm.routeName,
        arguments: tappedClass);
  }

  void showElementDetails(Meeting selected) {
    showModalBottomSheet(
      backgroundColor: selected.background,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Subject: ${selected.eventName}'),
              Divider(),
              Text(
                  'Starts at: ${DateFormat('d MMM hh mm a').format(selected.from)}'),
              Divider(),
              Text(
                  'Ends at: ${DateFormat('d MMM hh mm a').format(selected.to)}'),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text('Edit Class'),
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
                  db.deleteClass(selected.docId);
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

    return Scaffold(
      body: SfCalendar(
        view: _controller.view,
        controller: _controller,
        dataSource:
            meetingsData != null ? MeetingDataSource(meetingsData) : null,
        // by default the month appointment display mode set as Indicator, we can
        // change the display mode as appointment using the appointment display
        // mode property

        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        onTap: (CalendarTapDetails details) {
          DateTime date = details.date;

          //CalendarElement view = details.targetElement;
          print(date.toString());

          calendarTapped(details);
        },
        initialDisplayDate: _jumpToTime,
        maxDate: DateTime.now().add(Duration(days: 7)),
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
