import 'package:flutter/material.dart';
import 'package:shortest_distance/models/point.dart';
import 'package:shortest_distance/models/tasks.dart';

class PreviewScreen extends StatelessWidget {
  final TaskResult result;

  const PreviewScreen({super.key, required this.result});

  Color _getCellColor(Point point) {
    if (point == result.task.start) {
      return const Color(0xFF64FFDA);
    } else if (point == result.task.end) {
      return const Color(0xFF009688);
    } else if (result.task.grid.isBlocked(point)) {
      return const Color(0xFF000000);
    } else if (result.steps.contains(point)) {
      return const Color(0xFF4CAF50);
    } else {
      return const Color(0xFFFFFFFF);
    }
  }

  Color _getTextColor(Point point) {
    if (result.task.grid.isBlocked(point)) {
      return Colors.white;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final width = result.task.grid.width;
    final height = result.task.grid.height;

    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedCellSize = screenWidth / width;
    final double cellSize = calculatedCellSize < 45.0
        ? 45.0
        : calculatedCellSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width * cellSize,
                  height: height * cellSize,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: width * height,
                    itemBuilder: (context, index) {
                      final int x = index % width;
                      final int y = index ~/ width;
                      final point = Point(x, y);

                      return Container(
                        decoration: BoxDecoration(
                          color: _getCellColor(point),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            '($x,$y)',
                            style: TextStyle(
                              color: _getTextColor(point),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  result.pathString,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
