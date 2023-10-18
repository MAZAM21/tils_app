import 'package:SIL_app/widgets/screens/role-getter.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
  static const routeName = '/landing-page';
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 235, 235),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 500, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.popAndPushNamed(
                              context, RoleGetter.routeName);
                        });
                      },
                      child: const Text('Sign in',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Jura',
                              fontSize: 26,
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Row(
                                children: [
                                  Text(
                                    'Fluency',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Jura',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, bottom: 8),
                              child: Text(
                                'The Answers you were looking for',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'Jura',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 400,
                          child: LPImages()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LPImages extends StatelessWidget {
  final List<String> items = [
    'lib/assets/lp-images/image 1.png',
    'lib/assets/lp-images/image 2.png',
    'lib/assets/lp-images/image 3.png',
    'lib/assets/lp-images/image 4.png',
    'lib/assets/lp-images/image 5.png',
    'lib/assets/lp-images/image 6.png',
    'lib/assets/lp-images/image 7.png',
    'lib/assets/lp-images/image 8.png',
    'lib/assets/lp-images/image 9.png',
    // ... (Add more image assets here)
  ];

  List<Widget> buildRows() {
    List<Widget> rows = [];
    int i = 0;

    while (i < items.length) {
      List<Widget> rowItems = [];
      // 5 items in first row
      for (int x = 0; x < 5; x++) {
        if (i < items.length) {
          rowItems.add(
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 177,
                width: 177,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: Offset(5, 7),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    items[i],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
        i++;
      }
      rows.add(Row(
        children: rowItems,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ));
      rows.add(SizedBox(
        height: 20,
      ));

      rowItems = [];
      // 4 items in second row
      for (int x = 0; x < 4; x++) {
        if (i < items.length) {
          rowItems.add(
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 177,
                width: 177,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    items[i],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
        i++;
      }
      rows.add(Row(
        children: rowItems,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildRows(),
      ),
    );
  }
}
