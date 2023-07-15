import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/parent-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/parent-screens/parent-home.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';

class ParentDataStream extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User>(context).uid;
    bool isActive = false;
    isActive = true;
    return !isActive
        ? LoadingScreen()
        : StreamProvider<ParentUser?>(
            initialData: null,
            create: (context) => db.streamParentUser(uid),
            builder: (context, _) => ParentHome(),
          );
  }
}
