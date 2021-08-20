
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/service/db.dart';
import 'package:provider/provider.dart';

import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/display-announcements.dart';

class AnnouncementForm extends StatefulWidget {
  static const routeName = '/announcement-input';

  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> vals = {'title': '', 'body': ''};
  String id;
  bool _isInit = true;
  bool _isEdit = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Announcement;
      if (routeArgs != null) {
        vals['title'] = routeArgs.title;
        vals['body'] = routeArgs.body;
        id = routeArgs.id;
        _isEdit = true;
      }
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _saveState(String title, String body, String uid) {
    bool isValid = _formKey.currentState.validate();
    if (isValid) {
      if (!_isEdit) {
        db.addAnnouncementToCF(
          title,
          body,
          uid,
          DateTime.now(),
        );
        _formKey.currentState.reset();
      }
      if (_isEdit) {
        db.editAnnouncement(
          id,
          title,
          body,
          uid,
          DateTime.now(),
        );
        Navigator.popAndPushNamed(context, AllAnnouncements.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = Provider.of<User>(context).uid;
    bool isActive = false;
    if (id != null) {
      isActive = true;
    }

    return !isActive
        ? LoadingScreen()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                _formKey.currentState.save();
                _saveState(vals['title'], vals['body'], id);
              },
            ),
            appBar: AppBar(
              title: Text('Input Announcement'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 30),
                          TextFormField(
                            key: ValueKey('announcement title'),
                            validator: (value) {
                              if (value.isEmpty || value == '') {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              vals['title'] = value;
                            },
                            initialValue: vals['title'],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: ValueKey('announcement body'),
                            validator: (value) {
                              if (value.isEmpty || value == '') {
                                return 'Please enter announcement body';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              vals['body'] = value;
                            },
                            initialValue: vals['body'],
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Body',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            maxLines: 12,
                            minLines: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
