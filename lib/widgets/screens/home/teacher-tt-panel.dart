import 'package:flutter/material.dart';

class TeacherTTPanel extends StatelessWidget {
  const TeacherTTPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Material(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(215, 143, 166, 203).withOpacity(0.5),
                  Color.fromARGB(255, 219, 244, 167).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Add Class',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 76, 76),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Open Time Table',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 76, 76),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
