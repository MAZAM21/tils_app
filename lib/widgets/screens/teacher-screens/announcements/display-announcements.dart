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
        title: Text('Announcements'),
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
              return GridView.builder(
                itemCount: ordered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnnouncementTile(ordered[i]),
                ),
              );
            }
            return Text('No data');
          }),
    );
  }
}
