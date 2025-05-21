import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  const TaskCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Delete logic
          },
        ),
      ),
    );
  }
}
