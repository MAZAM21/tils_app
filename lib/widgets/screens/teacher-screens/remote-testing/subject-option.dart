import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/teacher-user-data.dart';

import 'package:SIL_app/widgets/screens/loading-screen.dart';

import './rt-input.dart';

class RASubject extends StatelessWidget {
  static const routeName = '/pick-subject';
  Widget _buttonBuilder(
    String buttName,
    String sub,
    String id,
    DateTime time,
    BuildContext context,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RemoteAssessmentInput.routeName, arguments: {
              'sub': sub,
              'id': id,
              'time': time,
            });
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          child: Text(buttName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _idRecieved = false;
    final id = Provider.of<User>(context).uid;
    final td = Provider.of<TeacherUser>(context);
    List<String> subs = [];
    if (id != null && td != null) {
      _idRecieved = true;
      subs = td.subjects;
    }
    final time = DateTime.now();
    return Scaffold(
      appBar: AppBar(),
      body: !_idRecieved
          ? LoadingScreen()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Subject Notifier
                        for (var x = 0; x < subs.length; x++)
                          _buttonBuilder(subs[x], subs[x], id, time, context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
