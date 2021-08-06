import 'package:flutter/material.dart';

class ClassPositionPanel extends StatelessWidget {
  const ClassPositionPanel({
    Key key,
    this.position,
  }) : super(key: key);
  final String position;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Class Position:',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 75, 63, 114),
                    ),
                  )),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$position',
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 75, 63, 114),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          height: 70,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 5),
            ],
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 118, 200, 147).withOpacity(0.3),
                Color.fromARGB(255, 22, 138, 173).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
      ),
    );
  }
}
