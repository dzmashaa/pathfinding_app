import 'dart:collection';

import 'package:shortest_distance/models/grid.dart';
import 'package:shortest_distance/models/node.dart';
import 'package:shortest_distance/models/point.dart';

class Pathfinder {
  final Grid grid;
  Pathfinder(this.grid);

  static final List<Point> _directions = [
    Point(0, -1),
    Point(0, 1),
    Point(-1, 0),
    Point(1, 0),
    Point(-1, -1),
    Point(1, -1),
    Point(-1, 1),
    Point(1, 1),
  ];

  List<Point> findShortestPath(Point start, Point end) {
    if (start == end) return [start];

    Queue<Node> queue = Queue<Node>();
    Set<Point> visited = {};

    queue.add(Node(start));
    visited.add(start);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();

      for (Point nextPoint in _getValidNeighbors(current.point, visited)) {
        if (nextPoint == end) {
          return _reconstructPath(Node(nextPoint, current));
        }

        visited.add(nextPoint);
        queue.add(Node(nextPoint, current));
      }
    }

    return [];
  }

  List<Point> _getValidNeighbors(Point currentPoint, Set<Point> visited) {
    List<Point> validNeighbors = [];

    for (Point dir in _directions) {
      Point nextPoint = Point(currentPoint.x + dir.x, currentPoint.y + dir.y);

      if (grid.isWalkable(nextPoint) && !visited.contains(nextPoint)) {
        validNeighbors.add(nextPoint);
      }
    }

    return validNeighbors;
  }

  List<Point> _reconstructPath(Node endNode) {
    List<Point> path = [];
    Node? current = endNode;

    while (current != null) {
      path.add(current.point);
      current = current.parent;
    }

    return path.reversed.toList();
  }
}
