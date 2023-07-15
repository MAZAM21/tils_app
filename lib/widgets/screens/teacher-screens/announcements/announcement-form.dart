import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/models/announcement.dart';
import 'package:SIL_app/service/db.dart';
import 'package:provider/provider.dart';

import 'package:SIL_app/widgets/screens/loading-screen.dart';

class AnnouncementForm extends StatefulWidget {
  static const routeName = '/announcement-input';

  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  Map<String, String?> vals = {'title': '', 'body': ''};
  String? id;
  bool _isInit = true;
  bool _isEdit = false;
  String? category;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Announcement?;
      if (routeArgs != null) {
        vals['title'] = routeArgs.title;
        vals['body'] = routeArgs.body;
        id = routeArgs.id;
        category = routeArgs.category;
        _isEdit = true;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _saveState(String? title, String? body, String uid, String? cat) {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (!_isEdit) {
        db.addAnnouncementToCF(title, body, uid, DateTime.now(), cat);
        _formKey.currentState!.reset();
        category = null;
        Navigator.pop(context);
      }
      if (_isEdit) {
        db.editAnnouncement(
          id,
          title,
          body,
          uid,
          category,
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = Provider.of<User>(context).uid;
    bool isActive = false;
    isActive = true;

    return !isActive
        ? LoadingScreen()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                _formKey.currentState!.save();
                if (category != null) {
                  _saveState(vals['title'], vals['body'], id, category);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text('Please Select Category'),
                        );
                      });
                }
              },
            ),
            appBar: AppBar(
              title: Text(
                'Input Announcement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 30),
                          TextFormField(
                            key: ValueKey('announcement title'),
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
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
                              if (value!.isEmpty || value == '') {
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
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: category == 'uol'
                                          ? MaterialStateProperty.all(
                                              Colors.blue)
                                          : MaterialStateProperty.all(
                                              Color.fromARGB(255, 76, 76, 76))),
                                  onPressed: () {
                                    setState(() {
                                      category = 'uol';
                                    });
                                  },
                                  child: Text('UoL')),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: category == 'bls'
                                          ? MaterialStateProperty.all(
                                              Colors.blue)
                                          : MaterialStateProperty.all(
                                              Color.fromARGB(255, 76, 76, 76))),
                                  onPressed: () {
                                    setState(() {
                                      category = 'bls';
                                    });
                                  },
                                  child: Text('BLS'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
