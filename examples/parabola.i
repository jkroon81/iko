namespace Parabola {
  real t;
  real[2] x[t];

  t.initial = 0.0;
  t.final = 1.0;
  x[0].initial = 0.0;
  x[1].initial = 0.0;

  der(x[0],t) = x[1];
  der(x[1],t) = 1.0;
}
