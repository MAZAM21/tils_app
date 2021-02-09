import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/subject.dart';

class MyClassesGrid extends StatelessWidget {
  const MyClassesGrid({
    Key key,
    @required this.myClasses,
  }) : super(key: key);

  final List<SubjectClass> myClasses;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: myClasses.length,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 253, 255, 182).withOpacity(0.5),
                  myClasses[i].getColor().withOpacity(0.7),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${myClasses[i].subjectName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                 Spacer(),
                 Text(
                  '${DateFormat('hh:mm a').format(myClasses[i].startTime)}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Text(
                  '${DateFormat('EEE, MMM d').format(myClasses[i].startTime)}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Spacer(),
                Text(
                  '${myClasses[i].topic}',
                  style: TextStyle(
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                SizedBox(height: 5,)
              ],
            ),
          ),
        );
      },
    );
  }
}
