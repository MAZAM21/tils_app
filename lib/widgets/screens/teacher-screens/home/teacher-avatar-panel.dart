import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/models/teacher-user-data.dart';

class TeacherAvatarPanel extends StatelessWidget {
  const TeacherAvatarPanel({
    Key? key,
    required this.teacherData,
  }) : super(key: key);

  final TeacherUser? teacherData;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toUtc();
    return defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? Row(
            children: <Widget>[
              Icon(
                Icons.person,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  width: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          if (now.isBefore(
                            DateTime.utc(
                              now.year,
                              now.month,
                              now.day,
                              13,
                            ),
                          ))
                            Text(
                              'Good morning,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                          if (now.isBefore(
                                DateTime.utc(
                                  now.year,
                                  now.month,
                                  now.day,
                                  17,
                                ),
                              ) &&
                              now.isAfter(DateTime.utc(
                                now.year,
                                now.month,
                                now.day,
                                13,
                              )))
                            Text(
                              'Good afternoon,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                          if (now.isBefore(
                                DateTime.utc(
                                  now.year,
                                  now.month,
                                  now.day,
                                  23,
                                ),
                              ) &&
                              now.isAfter(DateTime.utc(
                                now.year,
                                now.month,
                                now.day,
                                17,
                              )))
                            Text(
                              'Good evening,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${teacherData!.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2A353F),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: <Widget>[
              Icon(
                Icons.person,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          if (now.isBefore(
                            DateTime.utc(
                              now.year,
                              now.month,
                              now.day,
                              13,
                            ),
                          ))
                            Text(
                              'Good morning,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                          if (now.isBefore(
                                DateTime.utc(
                                  now.year,
                                  now.month,
                                  now.day,
                                  17,
                                ),
                              ) &&
                              now.isAfter(DateTime.utc(
                                now.year,
                                now.month,
                                now.day,
                                13,
                              )))
                            Text(
                              'Good afternoon,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                          if (now.isBefore(
                                DateTime.utc(
                                  now.year,
                                  now.month,
                                  now.day,
                                  23,
                                ),
                              ) &&
                              now.isAfter(DateTime.utc(
                                now.year,
                                now.month,
                                now.day,
                                17,
                              )))
                            Text(
                              'Good evening,',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5F686F),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${teacherData!.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2A353F),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
