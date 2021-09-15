import 'package:excel/excel.dart';
import 'package:tils_app/service/db.dart';

class UploadService {
  final db = DatabaseService();
  void uploadStudentToDB(Excel excelSheet) {
    List<UploadStudent> upStud = [];

    for (var table in excelSheet.tables.keys) {

      print(table); //sheet Name
      print(excelSheet.tables[table].maxCols);
      print(excelSheet.tables[table].maxRows);

      for (var row in excelSheet.tables[table].rows) {

        print("$row");
        print('${row[3]}');
        if (row[0].toString() != 'Name') {

          List<String> subs = row[3].toString().split(', ');
          print(row[1]);
          upStud.add(
            UploadStudent(
              name: '${row[0]}',
              email: '${row[1]}',
              password: '${row[2]}',
              subjects: subs,
              year: '${row[4]}',
              batch: '${row[5]}',
              section: '${row[6]}',
            ),
          );
        }
      }
    }
    db.saveStudent(upStud);
  }
}

class UploadStudent {
  String name;
  String email;
  String password;
  List<String> subjects;
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
    this.batch,
  });
}
