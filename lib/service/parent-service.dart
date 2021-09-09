
import 'package:tils_app/models/parent-user-data.dart';

import 'package:tils_app/models/subject.dart';

class ParentService {
  int attendancePercentage(ParentUser pd) {
    Map att = pd.attendance;
    double perc = 0;
    int presents = 0;
    int all = att.length;
    att.forEach((key, value) {
      if (value == 1 || value == 2) {
        presents++;
      }
    });
    perc = (presents / all) * 100;

    return perc.toInt();
  }

  ///getMarkedClasses takes all subjectclass list and the user's attendance map and returns the marked attendance classes
  ///made for parents attendance grid

  List<SubjectClass> getMarkedClasses(List<SubjectClass> allClasses, Map att) {
    List<SubjectClass> marked = [];
    if (att!=null) {
  allClasses.forEach((element) {
    if (att.containsKey(element.id) && element != null) {
      marked.add(element);
    }
  });
}
    marked.sort((a, b) => b.startTime.compareTo(
        a.startTime)); // easy sorting of dates. Use in attendance grid as well
    return marked;
  }

  int presents(Map att) {
    int p = 0;
    att.forEach((key, value) {
      if (value == 1) {
        p++;
      }
    });
    return p;
  }

  int lates(Map att) {
    int l = 0;
    att.forEach((key, value) {
      if (value == 2) {
        l++;
      }
    });
    return l;
  }

  int absents(Map att) {
    int a = 0;
    att.forEach((key, value) {
      if (value == 3) {
        a++;
      }
    });
    return a;
  }
}
