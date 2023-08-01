import 'package:flutter/material.dart';
import 'package:tils_app/models/instititutemd.dart';

import 'package:tils_app/service/db.dart';

import 'package:tils_app/widgets/drawer.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/display-announcements.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-home.dart';
import 'package:tils_app/widgets/screens/teacher-screens/teacher-rankings/teacher-ranking-display.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar});

  final Color? color;
  final TabBar? tabBar;

  @override
  Size get preferredSize => tabBar!.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}

class AllTabs extends StatefulWidget {
  final DatabaseService db;

  AllTabs(
    this.db,
  );
  @override
  _AllTabsState createState() => _AllTabsState();
}

class _AllTabsState extends State<AllTabs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<InstituteData?>(
      initialData: null,
      create: (context) => widget.db.getInstituteData(),
      builder: (context, child) {
        final instData = Provider.of<InstituteData?>(context);
        return instData != null
            ? DefaultTabController(
                length: 3,
                initialIndex: 1,
                child: Scaffold(
                  drawer: AppDrawer(),
                  appBar: AppBar(
                    title: Text(
                      '${instData.name}\'s Portal',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 76, 76),
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(30),
                      child: ColoredTabBar(
                        color: Theme.of(context).canvasColor,
                        tabBar: TabBar(
                            labelColor: Color.fromARGB(255, 76, 76, 76),
                            indicatorColor: Color.fromARGB(255, 143, 166, 203),
                            isScrollable: false,
                            tabs: <Widget>[
                              Tab(
                                text: 'Rankings',
                              ),
                              Tab(
                                text: 'Home',
                              ),
                              Tab(text: 'NewsFeed'),
                            ]),
                      ),
                    ),
                  ),
                  body: TabBarView(children: <Widget>[
                    TeacherRankingDisplay(),
                    HomePage(),
                    AllAnnouncements(),
                  ]),
                ),
              )
            : LoadingScreen();
      },
    );
  }
}
