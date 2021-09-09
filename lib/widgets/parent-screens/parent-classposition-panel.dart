import 'package:flutter/material.dart';

class ClassPositionPanel extends StatelessWidget {
  const ClassPositionPanel({
    Key key,
    this.position,
  }) : super(key: key);
  final String position;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        child: Column(
          children: <Widget>[
            Divider(
              color: Color(0xff2A353F),
              thickness: 0.2,
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  'Class Position:',
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$position',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.915,
      ),
    );
  }
}
