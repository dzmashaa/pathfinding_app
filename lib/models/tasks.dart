import 'package:shortest_distance/models/grid.dart';
import 'package:shortest_distance/models/point.dart';

class PathfindingTask {
  final String id;
  final Grid grid;
  final Point start;
  final Point end;

  PathfindingTask({
    required this.id,
    required this.grid,
    required this.start,
    required this.end,
  });

  factory PathfindingTask.fromJson(Map<String, dynamic> json) {
    return PathfindingTask(
      id: json['id'],
      grid: Grid(List<String>.from(json['field'])),
      start: Point.fromJson(json['start']),
      end: Point.fromJson(json['end']),
    );
  }
}

class TaskResult {
  final PathfindingTask task;
  final List<Point> steps;
  final String pathString;

  TaskResult({
    required this.task,
    required this.steps,
    required this.pathString,
  });

  Map<String, dynamic> toJson() => {
    'id': task.id,
    'result': {
      'steps': steps.map((p) => p.toJson()).toList(),
      'path': pathString,
    },
  };
}
