namespace StiffPendulum {
  float C;
  float lambda;
  real t;
  real[4] x[t];

  t.initial = 0.0;
  t.final = 10.0;
  x[0].initial = 0.9;
  x[1].initial = 0.1;
  x[2].initial = 0.0;
  x[3].initial = 0.0;

  C = 1000.0;
  lambda = C*(sqrt(x[0]^2+x[1]^2)-1)/sqrt(x[0]^2+x[1]^2);
  der(x[0],t) = x[2];
  der(x[1],t) = x[3];
  der(x[2],t) = -lambda*x[0];
  der(x[3],t) = -lambda*x[1] - 1.0;
}
