import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-detail.dart';


class AnnouncementTile extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementTile(
    this.announcement, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${announcement.title}',
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: InkWell(
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${announcement.body}',
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.fade,
                ),
              )),
              onTap: () {
                Navigator.pushNamed(context, AnnouncementDetail.routeName,
                    arguments: announcement);
              },
            ),
          ),
        ],
      ),
    );
  }
}
