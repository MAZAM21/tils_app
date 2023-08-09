import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teachers-all.dart';

class ManagementService {
  List<StudentRank> alphabeticalSort(List<StudentRank> studs) {
    studs.sort((a, b) => a.name.compareTo(b.name));
    return studs;
  }

  List<AllTeachers> alphabeticalSortTeachers(List<AllTeachers> studs) {
    studs.sort((a, b) => a.name!.compareTo(b.name!));
    return studs;
  }

  List<StudentRank> getStudentsOfSub(String? sub, List<StudentRank> allStuds) {
    List<StudentRank> subStuds = [];
    allStuds.forEach((stud) {
      if (stud.subjects!.contains(sub)) {
        subStuds.add(stud);
      }
    });
    return alphabeticalSort(subStuds);
  }

  List<AllTeachers> getTeachersOfSub(
      String? sub, List<AllTeachers> allTeachers) {
    List<AllTeachers> subTeachers = [];
    allTeachers.forEach((teach) {
      if (teach.subjects!.contains(sub)) {
        subTeachers.add(teach);
        print('management service teacher by sub: ${teach.name}');
      }
    });
    return alphabeticalSortTeachers(subTeachers);
  }

  List<StudentRank> getStudentsOfYear(
      String? year, List<StudentRank> allStuds) {
    List<StudentRank> yearStuds = [];
    allStuds.forEach((stud) {
      if (stud.year == year) {
        yearStuds.add(stud);
      }
    });
    return alphabeticalSort(yearStuds);
  }

  List<AllTeachers> getTeachersOfYear(
      String? year, List<AllTeachers> allTeachers) {
    List<AllTeachers> yearTeachers = [];
    allTeachers.forEach((stud) {
      if (stud.year == year) {
        yearTeachers.add(stud);
      }
    });
    return alphabeticalSortTeachers(yearTeachers);
  }
  //end of class
}
