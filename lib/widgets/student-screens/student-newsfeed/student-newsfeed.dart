import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

import './student-nf-tile.dart';

class StudentNewsFeed extends StatelessWidget {
  static const routeName = '/all-announcements';

  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
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
