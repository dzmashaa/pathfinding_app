class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(json['x'] as int, json['y'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'x': x.toString(), 'y': y.toString()};
  }

  @override
  String toString() => '($x,$y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
