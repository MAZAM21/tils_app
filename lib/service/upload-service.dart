import 'package:excel/excel.dart';
import 'package:tils_app/service/db.dart';

class UploadService {
  final db = DatabaseService();
  void uploadStudentToDB(Excel excelSheet) {
    List<UploadStudent> upStud = [];

    for (var table in excelSheet.tables.keys) {
      // print(table); //sheet Name
      // print(excelSheet.tables[table].maxCols);
      // print(excelSheet.tables[table].maxRows);

      for (var row in excelSheet.tables[table].rows) {
        //rint("$row");

        if (row[0].value.toString() != 'Name') {
          List<String> subs = row[3].value.toString().split(', ');
          // print('$subs');
          // print('${row[1].value}');
          // print('${row[2].value}');
          // print('${row[3].value}');

          upStud.add(
            UploadStudent(
              name: '${row[0].value}',
              email: '${row[1].value}',
              password: '${row[2].value}',
              subjects: subs,
              year: '${row[4].value}',
              batch: '${row[5].value}',
              section: '${row[6].value}',
              subMap: {}
            ),
          );
        }
      }
    }
    upStud.forEach(
      (stud) {
        Map<String, bool> subs = {
          'Conflict': false,
          'Jurisprudence': false,
          'Islamic': false,
          'Trust': false,
          'Company': false,
          'Tort': false,
          'Property': false,
          'EU': false,
          'HR': false,
          'Contract': false,
          'Criminal': false,
          'Public': false,
          'LSM': false,
        };

        subs.forEach(
          (k, v) {
            print(k);
            if (stud.subjects.contains('$k')) {
              print(stud.name);
              stud.subMap['$k'] = true;
            } else {
              stud.subMap['$k'] = false;
            }
          },
        );
      },
    );
    db.saveStudent(upStud);
  }
}

class UploadStudent {
  String name;
  String email;
  String password;
  List<String> subjects = [];
  Map subMap = {};
  String year;
  String batch;
  String section;
  String uid;
  UploadStudent({
    this.name,
    this.email,
    this.password,
    this.subjects,
    this.year,
    this.section,
    this.uid,
    this.subMap,
    this.batch,
  });
}
