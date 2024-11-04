import 'dart:math';

class SparsePixelField {
  List<int> cols = [];
  List<int> rows = [];

  void addPixel(int x, int y) {
    cols.add(x);
    rows.add(y);
  }

  // Метод 1. Рисование отрезка с пошаговым алгоритмом
  void drawLineStepwise(int x1, int y1, int x2, int y2) {
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
  }

  // Метод 2. Рисование отрезка с использованием алгоритма ЦДА
  void drawLineDDA(int x1, int y1, int x2, int y2) {
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
  }

  // Метод 3. Рисование отрезка с использованием алгоритма Брезенхема
  void drawLineBresenham(int x1, int y1, int x2, int y2) {
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
  }

  // Метод 4. Рисование окружности с использованием алгоритма Брезенхема
  void drawCircleBresenham(int xc, int yc, int x, int y) {
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
  }
}
