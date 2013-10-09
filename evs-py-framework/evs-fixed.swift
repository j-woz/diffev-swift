
import files;
import io;
import location;
import python;
import string;

app (file o) touch()
{
  "touch" o;
}

(string value) python_getkey(string python_dict, string key)
{
  // Escape ' characters for Python evaluation
  escaped_dict = replace_all(python_dict, "'", "\\'", 0);
  template =
----
_d = eval(\"%s\")
repr(_d['%s'])
----;
  code = sprintf(template, escaped_dict, key);
  value = python(code);
}

(string o) diffev_init()
{
  o = python(
----
from diffev import * 
repr(diffev_init())
----
);
}

(string s) diffev_komando(string command)
{
  template =
----
from diffev import *
repr(diffev_komando('%s'))
----;
  code = sprintf(template, command);
  s = python(code);
}

(string s) diffev_komando_location(string command, location L)
{
  template =
----
from diffev import *
repr(diffev_komando('%s'))
----;
  code = sprintf(template, command);
  s = @location=L python(code);
}

(string s) discus_run(int members, int parameters,
                      int cycle, int member)
{
  template =
----
from diffev import *
repr(discus(%s,%s,%s,%s))
----;
  code = sprintf(template, members, parameters, cycle, member);
  s = python(code);
}

(string s) kuplot_run(string discus_output, int members, int parameters,
                        int cycle, int member)
{
   template =
----
from diffev import *
repr(kuplot(%s,%s,%s,%s,%s))
----;
   // discus_output,
   code = sprintf(template, discus_output, members, parameters, cycle, member);
   s = python(code);
}

app (file o) summarize(string kuplot_outputs[])
{
  "./kuplot_summarize.sh" o kuplot_outputs;
}

global const int CYCLES = 3;

// main
// {
//   location compare_process = location_from_rank(1);
//   diffev_komando("@add.mac", compare_process) =>
//     diffev_komando("eval i[0]", location_from_rank(2)); // compare_process);
// }


main
{
  string init_data = diffev_init();
  // printf("init_data: %s", init_data);

  int members = toint(python_getkey(init_data, "members"));
  int parameters = toint(python_getkey(init_data, "parameters"));
  // printf("members: %i parameters: %i", members, parameters);

  void v[];
  v[0] = make_void();
  for (int cycle = 0; cycle < CYCLES; cycle = cycle + 1)
  {
    wait (v[cycle])
    {
      string kuplot_outputs[];
      foreach member in [0:members-1]
      {
       string discus_output = discus_run(members, parameters, cycle, member);
       kuplot_outputs[member] =
          kuplot_run(discus_output, members, parameters, cycle, member);
      }
      wait(kuplot_outputs) { v[cycle+1] = make_void(); }
    }
  }
  // write_state();
}

