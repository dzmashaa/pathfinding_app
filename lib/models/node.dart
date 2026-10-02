import 'point.dart';

class Node {
  final Point point;
  final Node? parent;

  Node(this.point, [this.parent]);
}
