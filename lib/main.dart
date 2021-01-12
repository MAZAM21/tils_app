import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import './routes_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Tapp());
}

class Tapp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return RoutesAndTheme();
      },
    );
  }
}

