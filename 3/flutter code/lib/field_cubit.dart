import 'dart:math';

import 'package:cglab3/field_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldCubit extends Cubit<FieldState> {
  FieldCubit()
      : super(
          FieldState(
            rows: [],
            cols: [],
          ),
        );

  void addPixel(int x, int y) {
    //final table = state.table..[x][y] = 1;
    //final stack = state.stack..push(Point(x: x, y: y));
    //emit(FieldState(table: table, count: state.count + 1, stack: stack));
    final cols = state.cols;
    final rows = state.rows;
    cols.add(x);
    rows.add(y);
    emit(FieldState(cols: cols, rows: rows, lineType: state.lineType));
  }

  // void deletePixel(int x, int y) {
  //   final table = state.table..[x][y] = 0;
  //   emit(FieldState(table: table, count: state.count + 1, stack: state.stack));
  // }

  bool checkIfSelected(int x, int y) {
    for (int i = 0; i < state.cols.length; i++) {
      if (state.cols[i] == x) {
        if (state.rows[i] == y) {
          return true;
        }
      }
    }
    return false;
  }

  void typeChanged(int index) {
    final type = switch (index) {
      0 => LineType.step,
      1 => LineType.dda,
      2 => LineType.brez,
      3 => LineType.circBrez,
      _ => LineType.step,
    };
    emit(FieldState(cols: state.cols, rows: state.rows, lineType: type));
  }

  void draw(int x1, int y1, int x2, int y2) {
    emit(FieldState(cols: [], rows: [], lineType: state.lineType));

    switch (state.lineType) {
      case LineType.step:
        drawLineStepwise(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
      case LineType.dda:
        drawLineDDA(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
      case LineType.brez:
        drawLineBresenham(x1 + 1, y1 + 1, x1 + 1, y2 + 1);
      case LineType.circBrez:
        drawCircleBresenham(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
    }
  }

  // Метод 1. Рисование отрезка с пошаговым алгоритмом
  void drawLineStepwise(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().millisecondsSinceEpoch;
    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int steps = dx > dy ? dx : dy;

    double xIncrement = (x2 - x1) / steps;
    double yIncrement = (y2 - y1) / steps;

    double x = x1.toDouble();
    double y = y1.toDouble();

    for (int i = 0; i <= steps; i++) {
      addPixel(x.round(), y.round());
      x += xIncrement;
      y += yIncrement;
    }
    final end = DateTime.now().millisecondsSinceEpoch;
    state.time = end - start;
    //print(state.cols);
  }

  // Метод 2. Рисование отрезка с использованием алгоритма ЦДА
  void drawLineDDA(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().millisecondsSinceEpoch;
    double dx = (x2 - x1).toDouble();
    double dy = (y2 - y1).toDouble();
    int steps = (dx.abs() > dy.abs()) ? dx.abs().round() : dy.abs().round();

    double xIncrement = dx / steps;
    double yIncrement = dy / steps;

    double x = x1.toDouble();
    double y = y1.toDouble();

    for (int i = 0; i <= steps; i++) {
      addPixel(x.round(), y.round());
      x += xIncrement;
      y += yIncrement;
    }
    final end = DateTime.now().millisecondsSinceEpoch;
    state.time = end - start;
  }

  // Метод 3. Рисование отрезка с использованием алгоритма Брезенхема
  void drawLineBresenham(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().millisecondsSinceEpoch;
    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int sx = x1 < x2 ? 1 : -1;
    int sy = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      addPixel(x1, y1);

      if (x1 == x2 && y1 == y2) break;
      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x1 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y1 += sy;
      }
    }
    final end = DateTime.now().millisecondsSinceEpoch;
    state.time = end - start;
  }

  // Метод 4. Рисование окружности с использованием алгоритма Брезенхема
  void drawCircleBresenham(int xc, int yc, int x, int y) {
    final start = DateTime.now().millisecondsSinceEpoch;
    int dx = (x - xc).abs();
    int dy = (y - yc).abs();
    int r = sqrt(dx * dx + dy * dy).round(); // радиус окружности
    int d = 3 - 2 * r;
    int cx = 0, cy = r;

    while (cx <= cy) {
      // Добавляем все восьмеричные симметричные точки
      addPixel(xc + cx, yc + cy);
      addPixel(xc - cx, yc + cy);
      addPixel(xc + cx, yc - cy);
      addPixel(xc - cx, yc - cy);
      addPixel(xc + cy, yc + cx);
      addPixel(xc - cy, yc + cx);
      addPixel(xc + cy, yc - cx);
      addPixel(xc - cy, yc - cx);

      if (d < 0) {
        d = d + 4 * cx + 6;
      } else {
        d = d + 4 * (cx - cy) + 10;
        cy--;
      }
      cx++;
    }
    final end = DateTime.now().millisecondsSinceEpoch;
    state.time = end - start;
  }

  int getTime() {
    return state.time;
  }
}
