import 'package:flutter/material.dart';
import 'package:SIL_app/models/announcement.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/service/teachers-service.dart';

import 'package:SIL_app/widgets/screens/loading-screen.dart';

import './student-nf-tile.dart';

class StudentNewsFeed extends StatelessWidget {
  static const routeName = '/all-announcements';
  final db = DatabaseService();
  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
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
              List ordered = ts.orderAnnouncement(announcementSnap.data!);
              return ListView.builder(
                itemCount: ordered.length,
                itemBuilder: (ctx, i) => StudentNFTile(ordered[i]),
                shrinkWrap: true,
              );
            }
            return Text('No data');
          }),
    );
  }
}
