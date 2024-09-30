class ColorState {
  int r;
  int g;
  int b;
  int h;
  int s;
  int v;
  int c;
  int m;
  int y;
  int k;

  ColorState({
    required this.r,
    required this.g,
    required this.b,
    required this.c,
    required this.m,
    required this.y,
    required this.k,
    required this.h,
    required this.s,
    required this.v,
  });

  factory ColorState.copyWith({
    required ColorState prevState,
    int? r,
    int? g,
    int? b,
    int? c,
    int? m,
    int? y,
    int? k,
    int? h,
    int? s,
    int? v,
  }) {
    return ColorState(
      r: r ?? prevState.r,
      g: g ?? prevState.g,
      b: b ?? prevState.b,
      c: c ?? prevState.c,
      m: m ?? prevState.m,
      y: y ?? prevState.y,
      k: k ?? prevState.k,
      h: h ?? prevState.h,
      s: s ?? prevState.s,
      v: v ?? prevState.v,
    );
  }
}
