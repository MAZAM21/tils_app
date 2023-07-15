import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SIL_app/models/subject-class.dart';

class MyClassesGrid extends StatelessWidget {
  const MyClassesGrid({
    Key? key,
    required this.myClasses,
  }) : super(key: key);

  final List<SubjectClass> myClasses;

  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    if (myClasses.isNotEmpty) {
      isActive = true;
    }
    return !isActive
        ? SizedBox(height: 10, width: 10,)
        : Container(
          height: 200,
          child: GridView.builder(
              itemCount: myClasses.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 200,
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 30,
              ),
              itemBuilder: (context, i) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 124,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'lib/assets/subject-images/${myClasses[i].subjectName}.jpg'),
                              fit: BoxFit.fill,
                            ),
                            // shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${myClasses[i].subjectName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff161616),
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${DateFormat('MMM dd, yyyy - hh:mm a').format(myClasses[i].startTime!)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff5f686f),
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
        );
  }
}
