import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';

import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-form.dart';
import './announcement-tile.dart';

class AllAnnouncements extends StatelessWidget {
  static const routeName = '/all-announcements';
  final db = DatabaseService();
  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AnnouncementForm.routeName);
            },
          )
        ],
      ),
      body: StreamBuilder<List<Announcement>>(
          stream: db.streamAnnouncement(),
          builder: (context, announcementSnap) {
            if (announcementSnap.hasError) {
              print('announcement stream builder has error');
            }
            if (announcementSnap.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }

            if (announcementSnap.hasData) {
              List ordered = ts.orderAnnouncement(announcementSnap.data);
              return ListView.builder(
                itemCount: ordered.length,
                itemBuilder: (ctx, i) => AnnouncementTile(ordered[i]),
                shrinkWrap: true,
              );
            }
            return Text('No data');
          }),
    );
  }
}
