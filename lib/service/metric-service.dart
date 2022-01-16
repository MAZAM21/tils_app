import 'dart:collection';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:tils_app/models/metrics.dart';

class MetricService {
  String getAssignmentMetric(List<StudentMetrics> metrics, String id) {
    LinkedHashMap timePos = new LinkedHashMap();
    String reString = '';

    metrics.forEach((m) {
      if (m.name == 'assignment-marks') {
        /// iterating through the assignment-marks map, we extract the postion from
        /// an already sorted id and marks map. We then store the time and position in a LHM.
        /// LHM is used because it retains the order in which the values were added
        m.assignmentMarks.forEach((time, idMarks) {
          if (idMarks.keys.contains(id)) {
            timePos[time] = idMarks.keys.toList().indexOf(id);
          }
        });

        /// now we have to check for our required position and
        /// then calculate the duration of how long has the student retained his
        /// position
        int pos;
        String firstTime;
        int parsedFT;
        int parsedLT;
        int duration;
        if (timePos.values.last == 0 ||
            timePos.values.last == 1 ||
            timePos.values.last == 2) {
          
          pos = timePos.values.last;
          
          firstTime =
              timePos.keys.firstWhere((element) => timePos[element] == pos);
          parsedFT = int.parse(firstTime);
          print('initial time: $parsedFT');
          parsedLT = int.parse(timePos.keys.last);
          print('final time: $parsedLT');
          duration = parsedLT-parsedFT;
          print(duration);
          Duration posDuration = Duration(milliseconds: duration);
          
          print( 'duration: ${posDuration.inDays} days ${posDuration.inHours - posDuration.inDays*24} hours ${Emojis.fire}');
          reString ='duration: ${posDuration.inDays} days ${posDuration.inHours - posDuration.inDays*24} hours ${Emojis.fire}';
        }
      }
    });
    return reString;
  }
}

/// the StudentMetrics assignment mark map where each key is the timestamp and each value is a map with
/// the student id as key and the value as the total assignment marks
/// our objective is to find the changes in position of our user across time.
