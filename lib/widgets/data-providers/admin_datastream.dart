import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/admin-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/admin-screens/admin-home.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class AdminDataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final uid = Provider.of<User>(context).uid;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<AdminUser?>(
            initialData: null,
            create: (context) => db.streamAdminUser(uid),
            builder: (context, _) => AdminHome(),
          );
  }
}
