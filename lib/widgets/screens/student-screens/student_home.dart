import 'package:flutter/material.dart';

class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 350,
            child: Column(
              children: <Widget>[
                Container(
                    height: 150,
                    width: 400,
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            'Welcome Message',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Proxima Nova Bold',
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide.none))),
                Card(
                  child: Text('Countdown'),
                ),
                Card(
                  child: Text('Attendance Record'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
