import 'package:flutter/material.dart';
import 'package:SIL_app/models/announcement.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/announcements/announcement-detail.dart';

class AnnouncementTile extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementTile(
    this.announcement, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imagePath;
    if (announcement.category == 'uol') {
      imagePath = 'lib/assets/uol-logo.png';
    } else if (announcement.category == 'bls') {
      imagePath = 'lib/assets/BLS-header.png';
    } else {
      imagePath = null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnnouncementDetail(),
              settings: RouteSettings(name: '/main-ann', arguments: announcement),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            if (imagePath != null)
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(imagePath),
                ),
              ),
            Container(
              height: 135,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 13,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          '${announcement.title}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4c4c4c)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 73,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 13,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            '${announcement.body}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Proxima Nova'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
