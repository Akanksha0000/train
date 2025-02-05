import 'package:flutter/material.dart';
import 'screen/map_screen.dart';


void main() {
  runApp(const TrainTrackerApp());
}

class TrainTrackerApp extends StatelessWidget {
  const TrainTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MapScreen(),
    );
  }
}
