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
          headerColor: getColor(widget.subject),
        ),
        child: SfDataGrid(
          allowSorting: true,
          source: _dataSource,
          columns: [
            GridColumn(
              label: Text('Name'),
              columnName: 'name',
              minimumWidth: 150,
              maximumWidth: 200,
              allowSorting: true,
            ),
            for (var x = 0; x < widget.titles.length; x++)
              GridColumn(
                label: Text('${widget.titles[x]}'),
                columnName: '${widget.titles[x]}',
                minimumWidth: 200,
                maximumWidth: 500,
                allowSorting: true,
              ),
          ],
        ),
      ),
    );
  }
}

class ARDataGridSource extends DataGridSource {
  List<ARStudent> gData;
  ARDataGridSource(this.gData);
  @override
  List<DataGridRow> get rows =>
      gData.map<DataGridRow>((dRow) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'name', value: dRow.name),
            for (int v = 0; v < dRow.titleMarks.length; v++)
              DataGridCell<String>(
                  columnName: '${dRow.titleMarks.keys.toList()[v]}',
                  value: '${dRow.titleMarks.values.toList()[v]}')
          ]));
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      return Text(dataCell.value.toString());
    }).toList());
  }
}
