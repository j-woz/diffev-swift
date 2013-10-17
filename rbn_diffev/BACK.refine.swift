import string;
import python;
import location;
import io;
import files;


(string s) diffev_kommando(string command, location L)
{
   template =
----
from diffev import *
repr(diffev_kommando('%s'))
----;
   code = sprintf(template, command);
   s = @location=L python(code);
}

(string s) diffev_init(string command, location L)
{
   template =
----
from diffev import *
repr(diffev_init('%s'))
----;
   code = sprintf(template, command);
   s = @location=L python(code);
}

(string p) diffev_trial(int children, int parameters , location L)
{
   template =
----
from diffev import *
repr(diffev_trial('%d', '%d'))
----;
   code = sprintf(template, children, parameters);
   p = @location=L python(code);
}

(string c) diffev_rvalue(int kid, string rvalue, location L)
{
   template =
----
from diffev import *
repr(diffev_rvalue('%d', %s))
----;
   code = sprintf(template, kid, rvalue);
   c = @location=L python(code);
}

(string c) diffev_compare(int generation, string rvalue[], location L)
{
   template =
----
from diffev import *
repr(diffev_compare('%d'))
----;
   code = sprintf(template, generation );
   c = @location=L python(code);
}

(string p) discus_kommando(int generation, int member, int children, 
                           int parameters, int kid,    int indiv,
                           string trial_kid )
{
   template =
----
from discus import *
repr(discus_kommando('%s', '%s', '%s', '%s', '%s', '%s', '%s'))
----;
   code = sprintf(template, generation,member,children,
                            parameters, kid, indiv,
                            trial_kid );
   p = python(code);
}

(string p) kuplot_rvalue(int generation, int member, int children,
                         int parameters, int kid, string discus_kid )
{
   template =
----
from kuplot import *
repr(kuplot_rvalue('%s', '%s', '%s', '%s', '%s', %s))
----;
   code = sprintf(template, generation,member,children,
                            parameters,kid, discus_kid);
   p = python(code);
}

main
{
  int generation;    // In line comment
  int member;
  int children;
  int parameters;

  // Define "diffev_process" as location of DIFFEV, needs to refer to this
  // Process all the time
  location diffev_process = location_from_rank(1);

  // Initialise DIFFEV, currently with fixed macro file name
  // Returns a Python tuple with (gen, mem, child, para)
  //
  string population = diffev_init("@diffev_start.mac", diffev_process);

  string g[]  = split(
                      substring(population, 1, strlen(population)-1),
                       "D" 
                     );

  generation  = toint( g[0]) ;
  member      = toint( g[1]) ;
  children    = toint( g[2]) ;
  parameters  = toint( g[3]) ;
  

  // Here the loop over all refinement cycles will begin
  // Tasks in each cycle are:
  //    get current parameters from diffev
  //    run all CHILDRENxNINDIV discus slaves in parallel
  //    run kuplot to work on all indivs for each child
  //    do DIFFEV "compare" command
  //
  // Right now DIFFEV, DISCUS and KUPLOT actually communicate via files,
  // Later on all data flow should be through swift 

  
       string trials = diffev_trial(children, parameters, diffev_process);
     
       string trial_array[] = split( 
                                    substring( trials, 1, strlen(trials)-1),
                                    "D"
                                   );
  
       // Loop over the children in this generation
       //
       string diffev_res[];
       float cost;
       foreach kid in [0:children-1]
       {
          string discus_res[];
          string rvalue[];
          line            = substring(trial_array[kid],1,strlen(trial_array[kid])-1);
          discus_res[kid] = discus_kommando(generation, member, children, parameters, kid+1, 1,line);
          rvalue[kid]     = kuplot_rvalue(  generation, member, children, parameters, kid+1, discus_res[kid]);
          diffev_res[kid] = diffev_rvalue(  kid, rvalue[kid], diffev_process);
       }

       wait(diffev_res){
       string comp = diffev_compare(generation, diffev_res, diffev_process);
       printf(" AFTER DIFFEV_COMPARE %s",comp);
       }
 // }
}

