
import io;
import string;

app (file o) echo(string s)
{
  "./echo.sh" s @stdout=o;
}

app (file o) cat_array(file f[])
{
  "cat" f @stdout=o;
}

main {
  int X=3;
  int Y=4;

  file F[][];

  foreach x in [0:X-1] {
    file f[];
    foreach y in [0:Y-1] {
        string name = sprintf("hello.%i.%i.txt", x, y);
        file o<name> = echo(sprintf("HELLO %i %i", x, y));
        f[y] = o;
    }
    F[x] = f;
  }

  foreach x in [0:X-1] {
    file summary<sprintf("summary-%i.txt",x)> = cat_array(F[x]);
  }
}
