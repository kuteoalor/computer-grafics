class GridState {
  final List<int> cols;
  final List<int> rows;
  final List<int> intensities;
  final List<Line> lines;
  LineType lineType;
  int time = 0;
  //int count;

  GridState(
      {required this.cols,
      required this.rows,
      required this.lines,
      required this.intensities,
      this.lineType = LineType.step});
  //FieldState({required this.table, required this.stack, this.count = 0});
}

enum LineType { step, dda, brez, circBrez }

class Line {
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  final LineType type;

  Line(
      {required this.x1,
      required this.y1,
      required this.x2,
      required this.y2,
      required this.type});
}
