import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class ResourcesMain extends StatefulWidget {
  static const routeName = '/resource-main';
  const ResourcesMain({Key key}) : super(key: key);

  @override
  State<ResourcesMain> createState() => _ResourcesMainState();
}

class _ResourcesMainState extends State<ResourcesMain> {
  @override
  Widget build(BuildContext context) {
    final resources = Provider.of<List<ResourceDownload>>(context);
    bool isActive = false;
    if (resources.isNotEmpty) {
      isActive = true;
    }
    return isActive
        ? Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Column(children: []),
            ),
          )
        : LoadingScreen();
  }
}
