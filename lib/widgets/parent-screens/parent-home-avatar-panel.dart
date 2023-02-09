import 'package:flutter/material.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tils_app/main.dart';
import 'package:tils_app/service/db.dart';

class ParentHomeAvatarPanel extends StatefulWidget {
  const ParentHomeAvatarPanel({
    Key key,
    @required this.parentData,
  }) : super(key: key);

  final ParentUser parentData;

  @override
  _ParentHomeAvatarPanelState createState() => _ParentHomeAvatarPanelState();
}

class _ParentHomeAvatarPanelState extends State<ParentHomeAvatarPanel> {
  String _token;
  final db = DatabaseService();
  void initState() {
    super.initState();
    final pd = Provider.of<ParentUser>(context, listen: false);

    ///this is for foreground notifications supposedly

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${notification.title}'),
        ));
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android?.smallIcon,
              ),
            ));
      }
    });

    if (pd != null) {
      getToken(pd.studId);
      print(_token);
    }
    // getTopics();
  }

  getToken(studID) async {
    String token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    print(token);
    db.addParentTokenToStudent(token, studID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                    color: Color(0xffc54134),
                    height: 80,
                    width: MediaQuery.of(context).size.width),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                        color: Color(0xffc54134),
                        height: 80,
                        width: MediaQuery.of(context).size.width),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                          color: Colors.white,
                          height: 40,
                          width: MediaQuery.of(context).size.width),
                    ),
                  ],
                ),
                if (widget.parentData.imageUrl.isNotEmpty)
                  CircleAvatar(
                    backgroundImage: widget.parentData.imageUrl != null
                        ? NetworkImage(widget.parentData.imageUrl)
                        : null,
                    radius: 30,
                  ),
                
                
              ],
            ),
          ),
          Text(
            '${widget.parentData.studentName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Proxima Nova',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
