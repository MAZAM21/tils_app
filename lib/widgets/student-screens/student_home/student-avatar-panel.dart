import 'package:flutter/material.dart';
import 'package:tils_app/models/student-user-data.dart';

class StudentAvatarPanel extends StatelessWidget {
  const StudentAvatarPanel({
    Key key,
    @required this.studData,
  }) : super(key: key);

  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (studData.imageURL != '')
          CircleAvatar(
            backgroundImage: studData.imageURL != null
                ? NetworkImage(studData.imageURL)
                : null,
            radius: 30,
          ),
        if (studData.imageURL == '')
          Icon(
            Icons.person,
            size: 60,
          ),
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
                Row(
                  children: [
                    Text(
                      '${studData.name}',
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
