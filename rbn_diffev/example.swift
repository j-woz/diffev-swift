
import io;
import string;

main
{
  string A[];
  A[1] = "hello";
  A[40] = "goodbye";
  printf("A: %s", string_join(A, "-"));
}
