real A;
real B;
real C;

model {
  A + B = B + A;
  A * B = B * A;
  ( A + B ) + C = A + ( B + C );
  ( A * B ) * C = A * ( B * C );
  ( A + B ) * C = A * C + B * C;
  A + 0 = A;
  A * 0 = 0;
  A * 1 = A;
  A + B = 0;
  A * B = 1;
}
