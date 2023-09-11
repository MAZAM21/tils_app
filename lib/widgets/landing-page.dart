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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        // Handle button press here
                      },
                      child: const Text('Menu',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Jura',
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 30),
                  TextButton(
                      onPressed: () {
                        // Handle button press here
                      },
                      child: const Text('Menu',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Jura',
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 40),
                  TextButton(
                      onPressed: () {
                        // Handle button press here
                      },
                      child: const Text('Menu',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Jura',
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 40),
                  TextButton(
                      onPressed: () {
                        // Handle button press here
                      },
                      child: const Text('Menu',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Jura',
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 40),
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
                              fontWeight: FontWeight.bold))),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Fluency',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'Jura',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 90,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'AI Powered Learning Management',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'Jura',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            Text(
                              'for Teachers and Students and Parents',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'Jura',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Flexible(
                        flex: 2,
                        child: Image(
                          image:
                              AssetImage('lib/assets/Landing-page-image-1.png'),
                          height: 522,
                        ),
                      ),
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
