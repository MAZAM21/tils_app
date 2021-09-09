import 'package:flutter/material.dart';
import 'package:tils_app/models/parent-user-data.dart';
class ParentHomeAvatarPanel extends StatelessWidget {
  const ParentHomeAvatarPanel({
    Key key,
    @required this.parentData,
  }) : super(key: key);

  final ParentUser parentData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                    color: Color(0xffc54134),
                    height: 80,
                    width: MediaQuery.of(context).size.width),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                        color: Color(0xffc54134),
                        height: 80,
                        width: MediaQuery.of(context).size.width),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                          color: Colors.white,
                          height: 40,
                          width: MediaQuery.of(context).size.width),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(parentData.imageUrl),
                ),
              ],
            ),
          ),
          Text(
            '${parentData.studentName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Proxima Nova',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
