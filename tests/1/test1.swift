
app () diffev_setup()
{
  "diffev" "-macro" "diffev_setup.mac";
}

app () discus()
{
  "discus" "-macro" "nano.zno.mac" "." "1" "1";
}

(int x, int b, float q) f(int y) ; 

main
{
  (x, b, q) = f(3);
  
  
  foreach i in [1:1]
  {
    discus(x, b, q);
  }
}
