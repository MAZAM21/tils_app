import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/subject.dart';

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
      height: 100,
      width: MediaQuery.of(context).size.width * 0.9,
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
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                gradient: attMap['${myClasses[i].id}'] == 1
                    ? LinearGradient(
                        colors: [
                          Color.fromARGB(255, 238, 235, 208).withOpacity(0.5),
                          Color.fromARGB(255, 105, 72, 115).withOpacity(0.7),
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [0, 1],
                      )
                    : attMap['${myClasses[i].id}'] == 2
                        ? LinearGradient(
                            colors: [
                              Color.fromARGB(255, 238, 235, 208).withOpacity(0.5),
                              Color.fromARGB(255, 224, 161, 0).withOpacity(0.7),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            stops: [0, 1],
                          )
                        : LinearGradient(
                            colors: [
                              Color.fromARGB(255, 238, 235, 208).withOpacity(0.5),
                              Color.fromARGB(255, 229, 61, 0).withOpacity(0.7),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            stops: [0, 1],
                          ),
              ),
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
                  Spacer(),
                  Text(
                    '${myClasses[i].topic}',
                    style: TextStyle(
                        color: Color.fromARGB(255, 76, 76, 76),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
