import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/instititutemd.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/genDb.dart';
import 'package:tils_app/widgets/screens/all_tabs.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class DBDatastream extends StatefulWidget {
  const DBDatastream({Key? key}) : super(key: key);

  @override
  State<DBDatastream> createState() => _DBDatastreamState();
}

class _DBDatastreamState extends State<DBDatastream> {
  bool isActive = false;
  void initState() {
    super.initState();
    final db = Provider.of<DatabaseService>(context, listen: false);
    if (db.instID != null) {
      isActive = true;
      print('in db datastream isactive');
    }
  }

  //final db = GeneralDatabase();
  @override
  Widget build(BuildContext context) {
    final id = Provider.of<InstProvider?>(context)!.getId();
    final db = Provider.of<DatabaseService>(context, listen: false);

    // bool isActive = false;
    print('in db datastream isactive false');
    if (db.instID != null) {
      isActive = true;
      print('in db datastream isactive');
    }
    return !isActive
        ? LoadingScreen()
        : FutureBuilder<String?>(
            future: Provider.of<InstProvider>(context).getId(),
            builder: (context, snapshot) {
              // bool idActive = false;
              // if (snapshot.connectionState == ConnectionState.done) {
              //   idActive = true;
              //   print('inst id snapshot in db ds: ${snapshot.data}');
              // }
              // final instID = Provider.of<String?>(context);

              return FutureProvider<InstituteData?>(
                create: (ctx) => db.getInstituteDataforAllTabs(),
                initialData: InstituteData(
                    inst_subjects: [],
                    name: '',
                    year_subjects: {},
                    ranking_yearSub: {}),
                builder: (context, child) {
                  return AllTabs();
                },
              );
            },
          );
  }
}
