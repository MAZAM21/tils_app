import 'package:flutter/material.dart';

import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/service/parent-service.dart';

class ParentAttendancePanel extends StatelessWidget {
  final ParentUser pData;
  ParentAttendancePanel(this.pData);
  final ps = ParentService();

  @override
  Widget build(BuildContext context) {
    int percentage = 0;
    if (ps.attendancePercentage(pData) > 0) {
      percentage = ps.attendancePercentage(pData);
    } else {
      percentage = 0;
    }
    final int presents = ps.presents(pData.attendance);
    final int lates = ps.lates(pData.attendance);
    final int absents = ps.absents(pData.attendance);
    return Container(
      width: MediaQuery.of(context).size.width * 0.915,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Attendance:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Proxima Nova',
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: Color(0xffc54134),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Proxima Nova',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '$presents',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Present',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '$lates',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Late',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '$absents',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'Absent',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
