import 'package:SIL_app/models/role.dart';
import 'package:SIL_app/service/genDB.dart';
import 'package:SIL_app/widgets/data-providers/parent_db_datastream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/parent-user-data.dart';

import 'package:SIL_app/widgets/screens/loading-screen.dart';

class ParentDataStream extends StatefulWidget {
  @override
  State<ParentDataStream> createState() => _ParentDataStreamState();
}

class _ParentDataStreamState extends State<ParentDataStream> {
  final genDb = GeneralDatabase();
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final roleProv = Provider.of<Role?>(context, listen: false);
        print(
            'parent datastream instprovider called instID:${roleProv!.instID}');
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
    final uid = Provider.of<User?>(context)?.uid;
    final role = Provider.of<Role?>(context, listen: false);
    final inst = role?.instID;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
      print('is active in t datastream true');
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<ParentUser?>(
            initialData: null,
            create: (context) => genDb.streamParentUser(uid, inst),
            builder: (context, _) => ParentDBDatastream(),
          );
  }
}
