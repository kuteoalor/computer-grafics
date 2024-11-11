import 'dart:math';

import 'package:cglab3/field_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit()
      : super(
          GridState(
            rows: [],
            cols: [],
            lines: [],
            intensities: [],
          ),
        );

  void addPixel(int x, int y, int intensity) {
    //final table = state.table..[x][y] = 1;
    //final stack = state.stack..push(Point(x: x, y: y));
    //emit(FieldState(table: table, count: state.count + 1, stack: stack));
    final cols = state.cols;
    final rows = state.rows;
    final intensities = state.intensities;
    cols.add(x);
    rows.add(y);
    intensities.add(intensity);
    emit(GridState(
        cols: cols,
        rows: rows,
        lines: state.lines,
        intensities: intensities,
        lineType: state.lineType));
  }

  // void deletePixel(int x, int y) {
  //   final table = state.table..[x][y] = 0;
  //   emit(FieldState(table: table, count: state.count + 1, stack: state.stack));
  // }

  (bool, int) checkIfSelected(int x, int y) {
    for (int i = 0; i < state.cols.length; i++) {
      if (state.cols[i] == x) {
        if (state.rows[i] == y) {
          return (true, state.intensities[i]);
        }
      }
    }
    return (false, 255);
  }

  void typeChanged(int index) {
    final type = switch (index) {
      0 => LineType.step,
      1 => LineType.dda,
      2 => LineType.brez,
      3 => LineType.circBrez,
      _ => LineType.step,
    };
    emit(GridState(
        cols: state.cols,
        rows: state.rows,
        lines: state.lines,
        intensities: state.intensities,
        lineType: type));
  }

  void draw(int x1, int y1, int x2, int y2) {
    final lines = state.lines;
    lines.add(Line(
        x1: x1 + 1, y1: y1 + 1, x2: x2 + 1, y2: y2 + 1, type: state.lineType));
    emit(GridState(
        cols: state.cols,
        rows: state.rows,
        lineType: state.lineType,
        intensities: state.intensities,
        lines: lines));

    switch (state.lineType) {
      case LineType.step:
        drawLineStepwise(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
      case LineType.dda:
        drawLineDDA(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
      case LineType.brez:
        drawLineBresenham(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
      case LineType.circBrez:
        drawCircleBresenham(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
    }
  }

  void clear() {
    emit(GridState(
        cols: [],
        rows: [],
        lines: [],
        intensities: [],
        lineType: state.lineType));
  }

  // Метод 1. Рисование отрезка с пошаговым алгоритмом
  void drawLineStepwise(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().microsecondsSinceEpoch;
    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int steps = dx > dy ? dx : dy;

    double xIncrement = (x2 - x1) / steps;
    double yIncrement = (y2 - y1) / steps;

    double x = x1.toDouble();
    double y = y1.toDouble();

    for (int i = 0; i <= steps; i++) {
      addPixel(x.round(), y.round(), 0);
      x += xIncrement;
      y += yIncrement;
    }
    final end = DateTime.now().microsecondsSinceEpoch;
    state.time = end - start;
    //print(state.cols);
  }

  // Метод 2. Рисование отрезка с использованием алгоритма ЦДА
  void drawLineDDA(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().microsecondsSinceEpoch;
    double dx = (x2 - x1).toDouble();
    double dy = (y2 - y1).toDouble();
    int steps = (dx.abs() > dy.abs()) ? dx.abs().round() : dy.abs().round();

    double xIncrement = dx / steps;
    double yIncrement = dy / steps;

    double x = x1.toDouble();
    double y = y1.toDouble();

    for (int i = 0; i <= steps; i++) {
      addPixel(x.round(), y.round(), 0);
      x += xIncrement;
      y += yIncrement;
    }
    final end = DateTime.now().microsecondsSinceEpoch;
    state.time = end - start;
  }

  // Метод 3. Рисование отрезка с использованием алгоритма Брезенхема
  void drawLineBresenham(int x1, int y1, int x2, int y2) {
    final start = DateTime.now().microsecondsSinceEpoch;
    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int sx = x1 < x2 ? 1 : -1;
    int sy = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      addPixel(x1, y1, 0);

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
    final end = DateTime.now().microsecondsSinceEpoch;
    state.time = end - start;
  }

  // Метод 4. Рисование окружности с использованием алгоритма Брезенхема
  void drawCircleBresenham(int xc, int yc, int x, int y) {
    final start = DateTime.now().microsecondsSinceEpoch;
    int dx = (x - xc).abs();
    int dy = (y - yc).abs();
    int r = sqrt(dx * dx + dy * dy).round(); // радиус окружности
    int d = 3 - 2 * r;
    int cx = 0, cy = r;

    while (cx <= cy) {
      // Добавляем все восьмеричные симметричные точки
      addPixel(xc + cx, yc + cy, 0);
      addPixel(xc - cx, yc + cy, 0);
      addPixel(xc + cx, yc - cy, 0);
      addPixel(xc - cx, yc - cy, 0);
      addPixel(xc + cy, yc + cx, 0);
      addPixel(xc - cy, yc + cx, 0);
      addPixel(xc + cy, yc - cx, 0);
      addPixel(xc - cy, yc - cx, 0);

      if (d < 0) {
        d = d + 4 * cx + 6;
      } else {
        d = d + 4 * (cx - cy) + 10;
        cy--;
      }
      cx++;
    }
    final end = DateTime.now().microsecondsSinceEpoch;
    state.time = end - start;
  }

  void drawSmoothLineWu(int x1, int y1, int x2, int y2) {
    //print('$x1 $y1');
    int dx = (x2 - x1).abs();
    int sx = x1 < x2 ? 1 : -1;
    int dy = (y2 - y1).abs();
    int sy = y1 < y2 ? 1 : -1;
    int err = dx - dy;
    int e2, x3;
    int ed = dx + dy == 0 ? 1 : sqrt(dx * dx + dy * dy).round();
    while (true) {
      addPixel(x1, y1, (255 * ((err - dx + dy).abs() / ed)).round());
      e2 = err;
      x3 = x1;
      if (2 * e2 >= -dx) {
        if (x1 == x2) break;
        if (e2 + dy < ed) addPixel(x1, y1 + sy, (255 * (e2 + dy) / ed).round());
        err -= dy;
        x1 += sx;
      }
      if (2 * e2 <= dy) {
        if (y1 == y2) break;
        if (dx - e2 < ed) addPixel(x3 + sx, y1, (255 * (dx - e2) / ed).round());
        err += dx;
        y1 += sy;
      }
    }
  }

  // void drawSmoothCircleWu(int xc, int yc, int x, int y) {
  //   int dx = (x - xc).abs();
  //   int dy = (y - yc).abs();
  //   int r = sqrt(dx * dx + dy * dy).round();
  //   double xCenter = xc.toDouble();
  //   double yCenter = yc.toDouble();

  //   for (int angle = 0; angle < 360; angle++) {
  //     double rad = angle * 3.141592653589793 / 180.0;
  //     double xExact = xCenter + r * cos(rad);
  //     double yExact = yCenter + r * sin(rad);
  //     int xFloor = xExact.floor();
  //     int yFloor = yExact.floor();

  //     addPixel(xFloor, yFloor, 255 - (255 * (1 - (xExact - xFloor))).round());
  //     addPixel(xFloor + 1, yFloor, 255 - (255 * ((xExact - xFloor))).round());
  //     addPixel(
  //         xFloor, yFloor + 1, 255 - (255 * (1 - (yExact - yFloor))).round());
  //     addPixel(
  //         xFloor + 1, yFloor + 1, 255 - (255 * ((yExact - yFloor))).round());
  //   }
  // }

  void drawSmoothCircleWu(int xc, int yc, int x2, int y2) {
    double x = sqrt((xc - x2) * (xc - x2) + (yc - y2) * (yc - y2));
    int radius = x.round();
    //double x = radius.toDouble();
    double y = 0.0;

    while (x >= y) {
      plotSymmetricPixels(xc, yc, x, y);
      y += 1;
      x = sqrt(radius * radius - y * y);

      // Интенсивность на основе дробного расстояния
      double fractionalX = x - x.floor();
      int intensity1 = (255 * (1 - fractionalX)).round();
      int intensity2 = (255 * fractionalX).round();

      // Рисуем пиксели с разной интенсивностью
      plotSymmetricPixels(xc, yc, x.floor().toDouble(), y, intensity1);
      plotSymmetricPixels(xc, yc, x.floor() + 1, y, intensity2);
    }
  }

  void plotSymmetricPixels(int xc, int yc, double x, double y,
      [int intensity = 255]) {
    addPixel((xc + x).toInt(), (yc + y).toInt(), 255 - intensity);
    addPixel((xc - x).toInt(), (yc + y).toInt(), 255 - intensity);
    addPixel((xc + x).toInt(), (yc - y).toInt(), 255 - intensity);
    addPixel((xc - x).toInt(), (yc - y).toInt(), 255 - intensity);
    addPixel((xc + y).toInt(), (yc + x).toInt(), 255 - intensity);
    addPixel((xc - y).toInt(), (yc + x).toInt(), 255 - intensity);
    addPixel((xc + y).toInt(), (yc - x).toInt(), 255 - intensity);
    addPixel((xc - y).toInt(), (yc - x).toInt(), 255 - intensity);
  }

  void drawAntialiased() {
    final lines = state.lines;
    clear();
    emit(GridState(cols: [], rows: [], lines: lines, intensities: []));
    for (var line in lines) {
      if (line.type == LineType.circBrez) {
        drawSmoothCircleWu(line.x1, line.y1, line.x2, line.y2);
      } else {
        drawSmoothLineWu(line.x1, line.y1, line.x2, line.y2);
      }
    }
  }

  int getTime() {
    return state.time;
  }
}
