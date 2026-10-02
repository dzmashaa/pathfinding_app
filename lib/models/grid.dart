import 'point.dart';

class Grid {
  final List<String> rows;
  final int width;
  final int height;

  Grid(this.rows)
    : height = rows.length,
      width = rows.isNotEmpty ? rows.first.length : 0 {
    if (height < 2 || height >= 100 || width < 2 || width >= 100) {
      throw ArgumentError('Розмір сітки повинен бути > 1 та < 100');
    }
  }

  bool isInBounds(Point point) {
    return point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;
  }

  bool isBlocked(Point point) {
    if (!isInBounds(point)) return true;
    return rows[point.y][point.x] == 'X';
  }

  bool isWalkable(Point p) {
    return isInBounds(p) && !isBlocked(p);
  }
}
