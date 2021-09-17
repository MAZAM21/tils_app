import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/ranking-service.dart';

class ClassPositionPanel extends StatefulWidget {
  const ClassPositionPanel({
    this.pData,
  });
  final ParentUser pData;

  @override
  _ClassPositionPanelState createState() => _ClassPositionPanelState();
}

class _ClassPositionPanelState extends State<ClassPositionPanel> {
  final rs = RankingService();
  @override
  Widget build(BuildContext context) {
    final studList = Provider.of<List<StudentRank>>(context);
    List<StudentRank> yearScoreSorted = [];
    int position;
    if (studList != null) {
      yearScoreSorted = rs.getStudentYearScore(widget.pData.year, studList);
      position = yearScoreSorted
          .firstWhere((stud) => stud.id == widget.pData.studId)
          .getPostion();
    }
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
