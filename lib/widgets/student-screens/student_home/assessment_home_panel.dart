import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';

class AssessmentHomePanel extends StatelessWidget {
  const AssessmentHomePanel({
    Key key,
    @required this.ss,
    @required this.studData,
  }) : super(key: key);

  final StudentService ss;
  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    final raList = Provider.of<List<RAfromDB>>(context);
    int totalNumRA = raList.length;
    List<RAfromDB> topThree = [];
    bool idActive = false;

    if (raList.isNotEmpty) {
      topThree = ss.getTopThree(raList, studData);
      print(topThree.length);
      idActive = true;
    }

    return !idActive
        ? CircularProgressIndicator()
        : Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/all-ras'),
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider.value(
                            value: studData,
                            child: StudentRADisplay(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Assessements',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Text(
                    '($totalNumRA)',
                    style: TextStyle(
                      color: Color(0xff5f686f),
                      fontFamily: 'Proxima Nova',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topThree.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    String dStat = ss.getdeadlineStatus(topThree[i]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        tileColor: Colors.white,
                        title: Text(
                          '${topThree[i].assessmentTitle}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          'Deadline: ${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].endTime)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            color: Color(0xff5F686F),
                          ),
                        ),
                        trailing: Text(
                          '$dStat',
                          style: TextStyle(
                            color: Color(0xffC54134),
                            fontFamily: 'Proxima Nova',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          );
  }
}
