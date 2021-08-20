import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/models/assessment-result.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class ResultDataGrid extends StatelessWidget {
  final String sub;
  ResultDataGrid(this.sub);
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: db.getAllARTitles(sub),
      builder: (context, titlesnap) {
        if (titlesnap.hasData) {
          return FutureBuilder<List<ARStudent>>(
              future: db.getARData(sub),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                }
                if (snap.hasError) {
                  print('err in futurebuilder ARDataGrid: ${snap.error}');
                }
                if (snap.hasData) {
                  //print('futurebuilder called');

                  return DG(
                    dataSource: snap.data,
                    titles: titlesnap.data,
                    subject: sub,
                  );
                }
                return LoadingScreen();
              });
        }
        return LoadingScreen();
      },
    );
  }
}

class DG extends StatefulWidget {
  const DG({
    Key key,
    @required this.dataSource,
    @required this.titles,
    @required this.subject,
  }) : super(key: key);

  final List<ARStudent> dataSource;
  final List<String> titles;
  final String subject;
  @override
  _DGState createState() => _DGState();
}

class _DGState extends State<DG> {
  final ts = TeacherService();
  ARDataGridSource _dataSource;
  @override
  void initState() {
    _dataSource = ARDataGridSource(widget.dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerStyle: DataGridHeaderCellStyle(
            textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Proxima Nova'),
            backgroundColor: getColor(widget.subject),
          ),
        ),
        child: SfDataGrid(
          allowSorting: true,
          source: _dataSource,
          columns: [
            GridTextColumn(
              headerText: 'Name',
              mappingName: 'name',
              minimumWidth: 150,
              maximumWidth: 200,
              allowSorting: true,
            ),
            for (var x = 0; x < widget.titles.length; x++)
              GridTextColumn(
                headerText: '${widget.titles[x]}',
                mappingName: '${widget.titles[x]}',
                minimumWidth: 200,
                maximumWidth: 500,
                maxLines: 3,
                textAlignment: Alignment.center,
                allowSorting: true,
              ),
          ],
        ),
      ),
    );
  }
}

class ARDataGridSource extends DataGridSource<ARStudent> {
  List<ARStudent> gData;
  ARDataGridSource(this.gData);
  @override
  List<ARStudent> get dataSource => gData;
  @override
  getValue(ARStudent student, String columnHeader) {
    //first column is for student names
    if (columnHeader == 'name') {
      //returns all student names for column Name
      return student.name;
    } else if (columnHeader != 'name') {
      //returns all marks for assessment title column
      if (student.titleMarks['$columnHeader'] == null) {
        return '0';
      } else {
        return student.titleMarks['$columnHeader'].toString();
      }
    }
    return 'nul';
  }
}
