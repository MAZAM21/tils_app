import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:flutter/material.dart';

import 'package:SIL_app/widgets/drawer.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/announcements/display-announcements.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-home.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/teacher-rankings/teacher-ranking-display.dart';
import 'package:provider/provider.dart';

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
  @override
  _AllTabsState createState() => _AllTabsState();
}

class _AllTabsState extends State<AllTabs> {
  @override
  Widget build(BuildContext context) {
    final instData = Provider.of<InstituteData?>(context);
    final teacherData = Provider.of<TeacherUser?>(context);
    bool isActive = false;
    if (teacherData != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            body: Row(
              children: [
                AppDrawer(teacherData!, instData),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    initialIndex: 1,
                    child: Scaffold(
                      // drawer: AppDrawer(),
                      appBar: AppBar(
                        title: Text(
                          '${instData!.name}\'s Portal',
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
                                indicatorColor:
                                    Color.fromARGB(255, 143, 166, 203),
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
                        TeacherRankingDisplay(instData.ranking_yearSub),
                        HomePage(),
                        AllAnnouncements(),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
