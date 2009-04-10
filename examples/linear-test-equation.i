namespace LinearTestEquation {
  real t;
  real x[t];

  model {
    t.initial = 0.0;
    t.final = 1.0;
    x.initial = 1.0;
    der(x,t) = -1.0;
  }
}
