import 'package:flutter/material.dart';
import 'package:tils_app/models/attendance-chart-values.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/service/teachers-service.dart';

class AttendanceGraph extends StatelessWidget {
  final List<Meeting> meetings;
  final ts = TeacherService();
  AttendanceGraph(this.meetings);
  @override
  Widget build(BuildContext context) {
    final attList = Provider.of<List<Attendance>>(context);
    final chartVals = ts.getChartVals(meetings, attList);
    return Row(
      children: <Widget>[
        Container(
          height: 200,
          width: 200,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<AttChartVals, String>(
                dataSource: chartVals,
                xValueMapper: (AttChartVals att, _) => att.day,
                yValueMapper: (AttChartVals att, _) => att.allPresent,
              )
            ],
          ),
        )
      ],
    );
  }
}
