import 'package:flutter/material.dart';
import 'package:SIL_app/models/parent-user-data.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/service/ranking-service.dart';
import 'package:provider/provider.dart';

class ARParentPanel extends StatefulWidget {
  const ARParentPanel({
    required this.parentData,
  });
  final ParentUser parentData;

  @override
  _ARParentPanelState createState() => _ARParentPanelState();
}

class _ARParentPanelState extends State<ARParentPanel> {
  final rs = RankingService();
  @override
  Widget build(BuildContext context) {
    List<AssessmentResult>? compRaList = [];
    final raList = Provider.of<List<RAfromDB>>(context);
    compRaList = rs.completedAssessmentsParent(raList, widget.parentData);

    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width * 0.915,
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 0.2,
            color: Color(0xff2A353F),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Assessment Results',
                style: TextStyle(
                  fontFamily: 'Proxima Nova',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Container(
            height: 175,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  leading: Text(
                    '${compRaList![i].title}',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 25, 19, 8),
                    ),
                  ),
                  trailing: Text(
                    '${compRaList[i].percentage}',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffc54134),
                    ),
                  ),
                );
              },
              itemCount: compRaList!.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
