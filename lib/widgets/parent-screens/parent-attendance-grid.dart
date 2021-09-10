import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/subject-class.dart';

class ParentAttendanceGrid extends StatelessWidget {
  const ParentAttendanceGrid({
    Key key,
    @required this.myClasses,
    @required this.attMap,
  }) : super(key: key);

  final Map attMap;
  final List<SubjectClass> myClasses;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.915,
      child: GridView.builder(
        itemCount: myClasses.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          return Container(
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xffc54134))),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                if (attMap['${myClasses[i].id}'] == 1)
                  Text(
                    'Present',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 25, 19, 8),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                if (attMap['${myClasses[i].id}'] == 2)
                  Text(
                    'Late',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 25, 19, 8),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                if (attMap['${myClasses[i].id}'] == 3)
                  Text(
                    'Absent',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 25, 19, 8),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                Spacer(),
                Text(
                  '${myClasses[i].subjectName}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Spacer(),
                Text(
                  '${DateFormat('hh:mm a').format(myClasses[i].startTime)}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Text(
                  '${DateFormat('EEE, MMM d').format(myClasses[i].startTime)}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                SizedBox(height: 5,)
              ],
            ),
          );
        },
      ),
    );
  }
}
