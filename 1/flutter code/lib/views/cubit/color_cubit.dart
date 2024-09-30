import 'dart:math';
import 'dart:ui';

import 'package:cg_lab1/views/cubit/color_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit()
      : super(
          ColorState(
            r: 0,
            g: 0,
            b: 0,
            c: 0,
            m: 0,
            y: 0,
            k: 100,
            h: 0,
            s: 0,
            v: 0,
          ),
        );

  void rChanged(int rr) {
    int h, s, v;
    double r = rr / 255;
    double g = state.g / 255;
    double b = state.b / 255;
    double cmax = max(max(r, g), b);
    double cmin = min(min(r, g), b);
    double delta = cmax - cmin;
    if (delta > 0) {
      if (cmax == r) {
        h = (60 * (((g - b) / delta) % 6)).toInt();
      } else if (cmax == g) {
        h = (60 * (((b - r) / delta) + 2)).toInt();
      } else {
        h = (60 * (((r - g) / delta) + 4)).toInt();
      }
      if (cmax == 0) {
        s = 0;
      } else {
        s = ((delta / cmax) * 100).toInt();
      }
      v = (cmax * 100).toInt();
    } else {
      h = 0;
      s = 0;
      v = (max(r, max(g, b)) * 100).toInt();
    }
    double k = (1 - max(rr, max(state.g, state.b)) / 255) * 100;
    double c = ((1 - rr / 255 - k / 100) / (1 - k / 100)) * 100;
    double m = ((1 - state.g / 255 - k / 100) / (1 - k / 100)) * 100;
    double y = ((1 - state.b / 255 - k / 100) / (1 - k / 100)) * 100;
    emit(ColorState.copyWith(
      prevState: state,
      r: rr,
      h: h,
      s: s,
      v: v,
      k: k.toInt(),
      c: c.toInt(),
      y: y.toInt(),
      m: m.toInt(),
    ));
  }

  void gChanged(int gg) {
    int h, s, v;
    double r = state.r / 255;
    double g = gg / 255;
    double b = state.b / 255;
    double cmax = max(max(r, g), b);
    double cmin = min(min(r, g), b);
    double delta = cmax - cmin;
    if (delta > 0) {
      if (cmax == r) {
        h = (60 * (((g - b) / delta) % 6)).toInt();
      } else if (cmax == g) {
        h = (60 * (((b - r) / delta) + 2)).toInt();
      } else {
        h = (60 * (((r - g) / delta) + 4)).toInt();
      }
      if (cmax == 0) {
        s = 0;
      } else {
        s = ((delta / cmax) * 100).toInt();
      }
      v = (cmax * 100).toInt();
    } else {
      h = 0;
      s = 0;
      v = (max(r, max(g, b)) * 100).toInt();
    }
    double k = (1 - max(state.r, max(gg, state.b)) / 255) * 100;
    double c = ((1 - state.r / 255 - k / 100) / (1 - k / 100)) * 100;
    double m = ((1 - gg / 255 - k / 100) / (1 - k / 100)) * 100;
    double y = ((1 - state.b / 255 - k / 100) / (1 - k / 100)) * 100;
    emit(ColorState.copyWith(
      prevState: state,
      g: gg,
      h: h,
      s: s,
      v: v,
      k: k.toInt(),
      c: c.toInt(),
      y: y.toInt(),
      m: m.toInt(),
    ));
  }

  void bChanged(int bb) {
    int h, s, v;
    double r = state.r / 255;
    double g = state.g / 255;
    double b = bb / 255;
    double cmax = max(max(r, g), b);
    double cmin = min(min(r, g), b);
    double delta = cmax - cmin;
    if (delta > 0) {
      if (cmax == r) {
        h = (60 * (((g - b) / delta) % 6)).toInt();
      } else if (cmax == g) {
        h = (60 * (((b - r) / delta) + 2)).toInt();
      } else {
        h = (60 * (((r - g) / delta) + 4)).toInt();
      }
      if (cmax == 0) {
        s = 0;
      } else {
        s = ((delta / cmax) * 100).toInt();
      }
      v = (cmax * 100).toInt();
    } else {
      h = 0;
      s = 0;
      v = (max(r, max(g, b)) * 100).toInt();
    }
    double k = (1 - max(state.r, max(state.g, bb)) / 255) * 100;
    double c = ((1 - state.r / 255 - k / 100) / (1 - k / 100)) * 100;
    double m = ((1 - state.g / 255 - k / 100) / (1 - k / 100)) * 100;
    double y = ((1 - bb / 255 - k / 100) / (1 - k / 100)) * 100;
    emit(ColorState.copyWith(
      prevState: state,
      b: bb,
      h: h,
      s: s,
      v: v,
      k: k.toInt(),
      c: c.toInt(),
      y: y.toInt(),
      m: m.toInt(),
    ));
  }

  void colorChanged(Color color) {
    int rr = color.red;
    int gg = color.green;
    int bb = color.blue;
    double k = (1 - max(rr, max(gg, bb)) / 255) * 100;
    double c = ((1 - rr / 255 - k / 100) / (1 - k / 100)) * 100;
    double m = ((1 - gg / 255 - k / 100) / (1 - k / 100)) * 100;
    double y = ((1 - bb / 255 - k / 100) / (1 - k / 100)) * 100;
    int h, s, v;
    double r = rr / 255;
    double g = gg / 255;
    double b = bb / 255;
    double cmax = max(max(r, g), b);
    double cmin = min(min(r, g), b);
    double delta = cmax - cmin;
    if (delta > 0) {
      if (cmax == r) {
        h = (60 * (((g - b) / delta) % 6)).toInt();
      } else if (cmax == g) {
        h = (60 * (((b - r) / delta) + 2)).toInt();
      } else {
        h = (60 * (((r - g) / delta) + 4)).toInt();
      }
      if (cmax == 0) {
        s = 0;
      } else {
        s = ((delta / cmax) * 100).toInt();
      }
      v = (cmax * 100).toInt();
    } else {
      h = 0;
      s = 0;
      v = (max(r, max(g, b)) * 100).toInt();
    }

    emit(
      ColorState.copyWith(
        prevState: state,
        r: color.red,
        g: color.green,
        b: color.blue,
        c: c.toInt(),
        m: m.toInt(),
        y: y.toInt(),
        k: k.toInt(),
        h: h,
        s: s,
        v: v,
      ),
    );
  }

  void cmykChanged(int c, int m, int y, int k) {
    c = max(c, 0);
    m = max(m, 0);
    y = max(y, 0);
    k = max(k, 0);
    final rr = 255 * (1 - c / 100) * (1 - k / 100);
    final gg = 255 * (1 - m / 100) * (1 - k / 100);
    final bb = 255 * (1 - y / 100) * (1 - k / 100);
    int h, s, v;
    double r = rr / 255;
    double g = gg / 255;
    double b = bb / 255;
    double cmax = max(max(r, g), b);
    double cmin = min(min(r, g), b);
    double delta = cmax - cmin;
    if (delta > 0) {
      if (cmax == r) {
        h = (60 * (((g - b) / delta) % 6)).toInt();
      } else if (cmax == g) {
        h = (60 * (((b - r) / delta) + 2)).toInt();
      } else {
        h = (60 * (((r - g) / delta) + 4)).toInt();
      }
      if (cmax == 0) {
        s = 0;
      } else {
        s = ((delta / cmax) * 100).toInt();
      }
      v = (cmax * 100).toInt();
    } else {
      h = 0;
      s = 0;
      v = (max(r, max(g, b)) * 100).toInt();
    }
    emit(
      ColorState.copyWith(
        prevState: state,
        r: rr.toInt(),
        g: gg.toInt(),
        b: bb.toInt(),
        c: c,
        m: m,
        y: y,
        k: k,
        h: h,
        s: s,
        v: v,
      ),
    );
  }

  void hsvChanged(int h1, int ss, int vv) {
    int h = max(h1, 0);
    double s = max(ss / 100, 0);
    double v = max(vv / 100, 0);
    print('$h $s $v');
    double c = (v * s);
    double hh = h / 60;
    double x = c * (1 - (hh % 2 - 1).abs());
    double m = v - c;
    double r, g, b;
    switch (hh) {
      case >= 0 && < 1:
        r = c + m;
        g = x + m;
        b = m;
        break;
      case >= 1 && < 2:
        r = x + m;
        g = c + m;
        b = m;
        break;
      case >= 2 && < 3:
        r = m;
        g = c + m;
        b = x + m;
        break;
      case >= 3 && < 4:
        r = m;
        g = x + m;
        b = c + m;
        break;
      case >= 4 && < 5:
        r = x + m;
        g = m;
        b = c + m;
      default:
        r = c + m;
        g = m;
        b = x + m;
    }
    r *= 255;
    g *= 255;
    b *= 255;
    print('$r $g $b');
    double kk = (1 - max(r, max(g, b)) / 255) * 100;
    double cc = ((1 - r / 255 - kk / 100) / (1 - kk / 100)) * 100;
    double mm = ((1 - g / 255 - kk / 100) / (1 - kk / 100)) * 100;
    double yy = ((1 - b / 255 - kk / 100) / (1 - kk / 100)) * 100;
    emit(
      ColorState.copyWith(
        prevState: state,
        r: r.toInt(),
        g: g.toInt(),
        b: b.toInt(),
        h: h1,
        s: ss,
        v: vv,
        c: cc.toInt(),
        k: kk.toInt(),
        m: mm.toInt(),
        y: yy.toInt(),
      ),
    );
  }
}
