namespace Step {
  real t;
  real[2] x[t];

  t.initial = 0.0;
  t.final = 20.0;
  x[0].initial = 0.0;
  x[1].initial = 0.0;
  der(x[0],t) = x[1];
  der(x[1],t) = - x[0] - x[1] + 1.0;
}
