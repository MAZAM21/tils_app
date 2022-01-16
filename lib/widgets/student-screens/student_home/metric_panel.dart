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
    
    String display = ms.getAssignmentMetric(metrics, studData.uid);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.white,
        height: 65,
        width: MediaQuery.of(context).size.width * 0.915,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(display),
              ],
            )
          ],
        ),
      ),
    );
  }
}
