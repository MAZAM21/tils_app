import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';

class TeacherAvatarPanel extends StatelessWidget {
  const TeacherAvatarPanel({
    Key key,
    @required this.teacherData,
  }) : super(key: key);

  final TeacherUser teacherData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('lib/assets/p3.JPG'),
          radius: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Good morning,',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5F686F),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${teacherData.name}',
                  style: TextStyle(
                    fontSize: 14,
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