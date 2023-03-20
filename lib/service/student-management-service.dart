import 'package:SIL_app/models/student_rank.dart';

class ManagementService {
  List<StudentRank> alphabeticalSort(List<StudentRank> studs) {
    studs.sort((a, b) => a.name.compareTo(b.name));
    return studs;
  }

  List<StudentRank> getStudentsOfSub(String sub, List<StudentRank> allStuds) {
    List<StudentRank> subStuds = [];
    allStuds.forEach((stud) {
      if (stud.subjects.contains(sub)) {
        subStuds.add(stud);
      }
    });
    return alphabeticalSort(subStuds);
  }

  List<StudentRank> getStudentsOfYear(String year, List<StudentRank> allStuds) {
    List<StudentRank> yearStuds = [];
    allStuds.forEach((stud) {
      if (stud.year == year) {
        yearStuds.add(stud);
      }
    });
    return alphabeticalSort(yearStuds);
  }
  //end of class
}
