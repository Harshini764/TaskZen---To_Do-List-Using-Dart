import 'package:flutter/material.dart';

class GamificationDashboard extends StatelessWidget {
  final int streakCount;
  final int points;

  const GamificationDashboard({super.key, required this.streakCount, required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Streak: $streakCount days", style: const TextStyle(fontSize: 18)),
            Text("Points: $points", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
