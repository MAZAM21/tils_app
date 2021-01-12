import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:tils_app/providers/all_classes.dart';
import 'package:provider/provider.dart';
import './edit-timetable-form.dart';

class CalendarApp extends StatefulWidget {
  // final List<Meeting> _allmeets;
  // CalendarApp(this._allmeets);
  static const routeName = '/time-table';

  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  void onTapCalendar(Meeting tappedClass) {
    Navigator.popAndPushNamed(context, EditTTForm.routeName,
        arguments: tappedClass);
  }

  void showElementDetails(Meeting selected) {
    showModalBottomSheet(
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
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meetingsData = Provider.of<List<Meeting>>(context);

    return MaterialApp(
      title: 'Calendar Demo',
      home: Scaffold(
        // appBar: AppBar(
        //   actions: <Widget>[
        //     FlatButton(
        //       child: Text('Back'),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //     FlatButton(
        //       child: Text('Edit Time Table'),
        //       onPressed: () {
        //         Navigator.pushNamed(
        //           context,
        //           EditTTForm.routeName,
        //         );
        //       },
        //     )
        //   ],
        // ),
        body: SfCalendar(
          view: CalendarView.workWeek,
          dataSource:
              meetingsData != null ? MeetingDataSource(meetingsData) : null,
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          onTap: (CalendarTapDetails details) {
            DateTime date = details.date;
            dynamic appointments = details.appointments;
            //CalendarElement view = details.targetElement;
            print(date.toString());
            showElementDetails(appointments[0]);
          },
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(Duration(days: 7)),
          allowViewNavigation: false,
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
// class Meeting {
//   /// Creates a meeting class with required details.
//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
//       this.docId);

//   factory Meeting.fromFirestore(QueryDocumentSnapshot doc) {
//     Map data = doc.data();
//     return Meeting(
//       data['subjectName'] ?? '',
//       DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']),
//       DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['endTime']),
//       Colors.lightGreen,
//       false,
//       doc.id,
//     );
//   }

//   /// Event name which is equivalent to subject property of [Appointment].
//   String eventName;

//   /// From which is equivalent to start time property of [Appointment].
//   DateTime from;

//   /// To which is equivalent to end time property of [Appointment].
//   DateTime to;

//   /// Background which is equivalent to color property of [Appointment].
//   Color background;

//   /// IsAllDay which is equivalent to isAllDay property of [Appointment].
//   bool isAllDay;

//   /// Firestore doc ID.
//   String docId;
// }
