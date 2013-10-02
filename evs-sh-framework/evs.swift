
import files;
import io;
import string;

app (file o) diffev_init()
{
  "./diffev_init.sh" o;
}

app (file o) discus_run(int members, int parameters,
                        int cycle, int member)
{
  "./discus_run.sh" o members parameters cycle member;
}

app (void v) kuplot_run(file discus_output, int members, int parameters,
                        int cycle, int member)
{
  "./kuplot_run.sh" discus_output members parameters cycle member;
}


global const int CYCLES = 3;

main
{
  file init_data<"init.data"> = diffev_init();

  int members;
  string t[] = split(read(init_data), "\n");
  string m[] = split(t[0], " ");
  members = toint(m[1]);
  string p[] = split(t[1], " ");
  parameters = toint(p[1]);
  printf("members: %i parameters: %i", members, parameters);

  void v[];
  v[0] = make_void();
  
  for (int cycle = 0; cycle < CYCLES; cycle = cycle + 1)
  {
    wait (v[cycle])
    {
      foreach member in [0:members-1]
      {
        file discus_output = discus_run(members, parameters, cycle, member);
        v[cycle+1] = kuplot_run(discus_output, members, parameters, cycle, member);
      }
    }
  }
}
