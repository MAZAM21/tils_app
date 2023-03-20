import 'package:flutter/material.dart';
import 'package:SIL_app/models/student_rank.dart';

class SecondThirdStudRow extends StatelessWidget {
  const SecondThirdStudRow({
    Key key,
    @required this.students,
  }) : super(key: key);

  final List<StudentRank> students;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
              child: Container(
                height: 100,
                color: Color.fromARGB(255, 160, 214, 113),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(students[1].imageUrl),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          '${students[1].name}',
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 0, 77)),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 0, 77)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
              child: Container(
                height: 100,
                color: Color.fromARGB(255, 160, 214, 113),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(students[2].imageUrl),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          '${students[2].name}',
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 0, 77)),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 0, 77)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
