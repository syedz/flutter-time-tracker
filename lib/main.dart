import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
      builder: (BuildContext context) => Auth(),
    );
  }
}
