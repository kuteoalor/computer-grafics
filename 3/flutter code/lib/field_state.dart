class FieldState {
  final List<int> cols;
  final List<int> rows;
  LineType lineType;
  int time = 0;
  //int count;

  FieldState(
      {required this.cols, required this.rows, this.lineType = LineType.step});
  //FieldState({required this.table, required this.stack, this.count = 0});
}

enum LineType { step, dda, brez, circBrez }

class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}

class Point {
  final int x;
  final int y;

  Point({required this.x, required this.y});
}
