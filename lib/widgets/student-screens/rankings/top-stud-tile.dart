import 'package:flutter/material.dart';
import 'package:tils_app/models/student_rank.dart';

/// The top student display tile in rankings
class TopStudentTile extends StatelessWidget {
  const TopStudentTile({
    Key key,
    @required this.topStud,
  }) : super(key: key);

  final StudentRank topStud;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.all(
              Radius.elliptical(15, 15),
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.elliptical(15, 15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 233, 117),
                //shodow not working
              
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: topStud.imageUrl != ''
                        ? NetworkImage(topStud.imageUrl)
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                            '${topStud.name}',
                            style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 51, 101, 138)),
                          ) ??
                          Text(''),
                      SizedBox(width: 60),
                      Text(
                        '${topStud.position}',
                        style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 101, 138)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
