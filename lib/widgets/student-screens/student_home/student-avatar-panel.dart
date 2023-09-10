import 'package:flutter/material.dart';
import 'package:SIL_app/models/student-user-data.dart';

class StudentAvatarPanel extends StatelessWidget {
  const StudentAvatarPanel({
    Key? key,
    required this.studData,
  }) : super(key: key);

  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toUtc();
    return Row(
      children: <Widget>[
        // if (studData.imageURL != '')
        //   CircleAvatar(
        //     backgroundImage: studData.imageURL != null
        //         ? NetworkImage(studData.imageURL!)
        //         : null,
        //     radius: 30,
        //   ),
        // if (studData.imageURL == '')
        //   Icon(
        //     Icons.person,
        //     size: 60,
        //   ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 7,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${studData.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
