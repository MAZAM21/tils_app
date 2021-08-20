

import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/service/db.dart';

import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-form.dart';

class AnnouncementDetail extends StatelessWidget {
  static const routeName = '/announcement-detail';
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final announcement =
        ModalRoute.of(context).settings.arguments as Announcement;
    return Scaffold(
      appBar: AppBar(
        title: Text('${announcement.title}'),
        actions: <Widget>[
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              db.deleteAnnouncement(announcement.id);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Edit'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AnnouncementForm.routeName,
                arguments: announcement,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${announcement.body}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
