
import assert;
import io;
import location;
import python;
import string;

(string s) i2s(int i)
{
  s = sprintf("\"%i\"", i);
}

f(location L, int i)
{
  printf(@location=L python(i2s(i)));
}

main
{
  assert(turbine_workers() >= 4, "Must have at least 4 workers!");

  L1 = location_from_rank(1);
  L2 = location_from_rank(2);
  L3 = location_from_rank(3);
  L4 = location_from_rank(4);

  printf("HELLO");
  printf(@location=L2 python("\"2\""));
  printf(@location=L3 python("\"3\""));

  f(L4, 4);
}
