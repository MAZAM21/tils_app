import 'package:flutter/material.dart';

import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/service/parent-service.dart';

class ParentAttendancePanel extends StatelessWidget {
  final ParentUser pData;
  ParentAttendancePanel(this.pData);
  final ps = ParentService();

  @override
  Widget build(BuildContext context) {
    final percentage = ps.attendancePercentage(pData);
    final int presents = ps.presents(pData.attendance);
    final int lates = ps.lates(pData.attendance);
    final int absents = ps.absents(pData.attendance);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      //wrapping with material is an easy way to add elevation
      child: Material(
        borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
        elevation: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
          child: Container(
            decoration: BoxDecoration(
             
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 118, 200, 147).withOpacity(0.3),
                  Color.fromARGB(255, 22, 138, 173).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
            height: 150,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Attendance:',
                            style: TextStyle(
                              color: Color.fromARGB(255, 75, 63, 114),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Proxima Nova',
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Color.fromARGB(255, 75, 63, 114),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Present: $presents',
                      style: TextStyle(
                          color: Color.fromARGB(255, 105, 72, 115),
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Late: $lates',
                      style: TextStyle(
                          color: Color.fromARGB(255, 224, 161, 0),
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Absent: $absents',
                      style: TextStyle(
                          color: Color.fromARGB(255, 229, 61, 0),
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
