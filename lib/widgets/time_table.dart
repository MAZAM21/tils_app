import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import './edit-timetable.dart';
import '../providers/all_classes.dart';
import 'package:provider/provider.dart';

class CalendarApp extends StatefulWidget {
  static const routeName = '/time-table';
  
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  

  @override
  Widget build(BuildContext context) {
   
   final meetingsData = Provider.of<AllClasses>(context);
    final thisMeeting = meetingsData.timeTable;
    return MaterialApp(
      title: 'Calendar Demo',
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Edit Time Table'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditTT.routeName,
                );
              },
            )
          ],
        ),
        body: SfCalendar(
          view: CalendarView.workWeek,
          dataSource:
              thisMeeting != null ? MeetingDataSource(thisMeeting) : null,
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        //   onTap: (CalendarTapDetails details){
        //  DateTime date = details.date;
        //  dynamic appointments = details.appointments;
        //  CalendarElement view = details.targetElement;
      //  },
        ),
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

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
