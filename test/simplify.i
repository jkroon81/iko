real a, b, c, d, e, f;

model {
  -a = 0;
  a - b = 0;

  ( a + b ) + c = 0;
  ( a * b ) * c = 0;
  a + b + c + d = 0;
  ( ( ( a + b ) + c ) + d ) = 0;
  ( a + b ) + ( c + d ) = 0;

  ( a / b ) / c = 0;
  a / ( b / c ) = 0;
  a * (b / c ) = 0;
  a * ( b / c ) * ( d / e ) * f = 0;
}
