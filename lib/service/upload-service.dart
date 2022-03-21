import 'package:excel/excel.dart';
import 'package:tils_app/service/db.dart';

class UploadService {
  final db = DatabaseService();

  /// This function takes an excell sheet and makes students out of it
  /// the order of fields is as follows
  /// name
  /// email
  /// password
  /// subjects (split iwth ', ')
  /// year
  /// batch
  /// section
  void uploadStudentToDB(Excel excelSheet) {
    List<UploadStudent> upStud = [];

    for (var table in excelSheet.tables.keys) {
      for (var row in excelSheet.tables[table].rows) {
        if (row[0].value.toString() != 'Name') {
          List<String> subs = row[3].value.toString().split(', ');

          upStud.add(
            UploadStudent(
                name: '${row[0].value}',
                email: '${row[1].value}',
                password: '${row[2].value}',
                subjects: subs,
                year: '${row[4].value}',
                batch: '${row[5].value}',
                section: '${row[6].value}',
                subMap: {}),
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

  void uploadTeacherToDB(Excel excelSheet) {

    ///Error note:
    /// While uploading teachers for bls, two things went wrong
    /// 1. Year was not added
    /// 2. The registered subjects field name was previously set to 'subjects' in model. 
    /// but in db upload function it is 'RegisteredSubs' 
    /// This caused me some grief. Fix or take note
    
    List<UploadTeacher> upTeacher = [];
    //Excel sheets can have multiple tables hence the first for loop checks for the first table
    for (var table in excelSheet.tables.keys) {
      //Now we iterate through each row in the table
      for (var row in excelSheet.tables[table].rows) {
        if (row[0].value.toString() != 'Name') {
          List<String> subs = row[3].value.toString().split(', ');
          upTeacher.add(
            UploadTeacher(
              name: '${row[0].value}',
              email: '${row[1].value}',
              password: '${row[2].value}',
              subjects: subs,
              subMap: {},
            ),
          );
        }
      }
    }
    upTeacher.forEach(
      (t) {
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
            if (t.subjects.contains('$k')) {
              print(t.name);
              t.subMap['$k'] = true;
            } else {
              t.subMap['$k'] = false;
            }
          },
        );
      },
    );
    db.saveTeacher(upTeacher);
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

class UploadTeacher {
  String name;
  String email;
  String password;
  List<String> subjects = [];
  String uid;
  Map subMap = {};
  UploadTeacher({
    this.name,
    this.email,
    this.password,
    this.subjects,
    this.subMap,
    this.uid,
  });
}
