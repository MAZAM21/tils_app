import 'package:SIL_app/models/role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/student-user-data.dart';

import 'package:SIL_app/widgets/screens/loading-screen.dart';

import 'package:SIL_app/service/genDB.dart';
import './student_db_datastream.dart';

class StudentDataStream extends StatefulWidget {
  @override
  State<StudentDataStream> createState() => _StudentDataStreamState();
}

class _StudentDataStreamState extends State<StudentDataStream> {
  final genDb = GeneralDatabase();
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final roleProv = Provider.of<Role?>(context, listen: false);
        print(
            'student datastream instprovider called instID:${roleProv!.instID}');
        //if (!dbActive) {
        Provider.of<InstProvider>(context, listen: false)
            .setID(roleProv.instID);
        //dbActive = true;
        //}
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final db = Provider.of<DatabaseService>(context, listen: false);
    final uid = Provider.of<User?>(context)?.uid;
    final role = Provider.of<Role?>(context, listen: false);
    final inst = role?.instID;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<StudentUser?>(
            initialData: null,
            create: (context) => genDb.streamStudentUser(uid, inst),
            builder: (context, _) => StudentDBDatastream(),
          );
  }
}
