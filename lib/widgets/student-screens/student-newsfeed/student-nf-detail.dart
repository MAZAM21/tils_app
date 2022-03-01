import 'package:flutter/material.dart';
import 'package:tils_app/models/announcement.dart';
import 'package:tils_app/service/db.dart';

import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-form.dart';

class StudentNFDetail extends StatelessWidget {
  static const routeName = '/announcement-detail';
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final announcement =
        ModalRoute.of(context).settings.arguments as Announcement;

    String imagePath;
    if (announcement.category == 'uol') {
      imagePath = 'lib/assets/uol-logo.png';
    } else if (announcement.category == 'bls') {
      imagePath = 'lib/assets/BLS-header.png';
    } else {
      imagePath = null;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imagePath != null)
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(imagePath),
                ),
              ),
            SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.white,
              child: Text(
                '${announcement.title}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Proxima Nova',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c4c4c),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${announcement.body}',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4c4c4c)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
