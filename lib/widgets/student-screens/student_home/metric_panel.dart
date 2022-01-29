import 'package:flutter/material.dart';
import 'package:tils_app/models/metrics.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/metric-service.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';

class MetricDisplay extends StatelessWidget {
  const MetricDisplay({
    @required this.studData,
    @required this.metrics,
    Key key,
  }) : super(key: key);
  final List<StudentMetrics> metrics;
  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    final ms = MetricService();
    bool isActive = false;
    MetricAchievement display;
    if (ms != null) {
      display = ms.getAssignmentMetric(metrics, studData.uid);
      if (display.achievement != null) {
        isActive = true;
      }
    }

    return !isActive
        ? SizedBox()
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Color(0xffFFDCA4),
              height: 75,
              width: MediaQuery.of(context).size.width * 0.915,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        display.achievement + display.emoji,
                        style: TextStyle(
                            color: Color(0xff030453),
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 7,),
                  Text(
                    display.duration,
                    style: TextStyle(
                        color: Color(0xff0077B6),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
  }
}
