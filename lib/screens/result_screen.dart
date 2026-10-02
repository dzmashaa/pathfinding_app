import 'package:flutter/material.dart';
import 'package:shortest_distance/models/tasks.dart';
import 'package:shortest_distance/screens/preview_screen.dart';

class ResultListScreen extends StatelessWidget {
  final List<TaskResult> results;

  const ResultListScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result list screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.separated(
        itemCount: results.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final result = results[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(result: result),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: Text(
                  result.pathString,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
