import string;
import python;
import location;
import io;
import files;
import stats;
import sys;

//
// Define interface functions to python
//

//
// DIFFEV_KOMMANDO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Send a general command to diffev

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

//
// DIFFEV_INIT ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Start DIFFEV and initialize the population

(string s) diffev_init(string command, location L)
{
   template =
----
from diffev import *
from wrappers import *
repr(diffev_init('%s'))
----;
   code = sprintf(template, command);
   s = @location=L python(code);
}

//
// DIFFEV_TRIAL +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Get the current trial parameters from DIFFEV

(string p) diffev_trial(int children, int parameters, float current, location L)
{
   template =
----
from diffev import *
from wrappers import *
repr(diffev_trial('%d', '%d', '%f'))
----;
   code = sprintf(template, children, parameters, current);
   p = @location=L python(code);
}

//
// DIFFEV_RVALUE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Send a single rvalue to DIFFEV

(string c) diffev_rvalue(int kid, string rvalue, location L)
{
   template =
----
from diffev import *
from wrappers import *
repr(diffev_rvalue('%d', %s))
----;
   code = sprintf(template, kid, rvalue);
   c = @location=L python(code);
}

//
// DIFFEV_COMPARE +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Perform the DIFFEV compare command

(string c) diffev_compare(int generation, int all_kids, location L)
{
   template =
----
from diffev import *
from wrappers import *
repr(diffev_compare('%d', '%d'))
----;
   code = sprintf(template, generation, all_kids );
   c = @location=L python(code);
}

//
// DISCUS_CALC ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Perform a single DISCUS calculation for child "kid" and individual "indiv"

(string p) discus_calc(int generation, int member, int children,
                       int parameters, int kid,    int indiv,
                       string trial_kid )
{
   template =
----
from discus import *
from wrappers import *
repr(discus_calc('%d', '%d', '%d', '%d', '%d', '%d', '%s'))
----;
   code = sprintf(template, generation,member,children,
                            parameters, kid, indiv,
                            trial_kid );
   p = python(code);
}

//
// KUPLOT_RVALUE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Calculate the R-Value = Cost function for child "kid"

(string p) kuplot_rvalue(int generation, int member, int children,
                         int parameters, int kid   , int nindiv,
                         int discus_kid )
{
   template =
----
from kuplot import *
from wrappers import *
repr(kuplot_rvalue('%d', '%d', '%d', '%d', '%d', '%d',  '%s' ))
----;
   code = sprintf(template, generation,member,children,
                            parameters,kid, nindiv, discus_kid);
   p = python(code);
}

//
// KUPLOT_SEL +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Run the backup of the current best solution

(int kuplot_bck) kuplot_sel(int children, int diffev_res[])
{
   template =
----
from kuplot import *
from wrappers import *
repr(kuplot_sel('%d', '%d'))
----;
   int all_kids    = sum_integer(diffev_res);
   code = sprintf(template, children, all_kids);
   string erg = python(code);
   kuplot_bck = toint(substring(erg,1,strlen(erg)-2));
}

//
// DISCUS_RUN *****************************************************************
//
// Loop over all children and individual repetitions
// ????????????????????????????????????????????????????????????????????????????
// To synchronize to kuplot _rvalue I collect the return value for all
// individual repetitions into array "col" and sum up this array into entry
// "kid" in the result function discus_res[]
// It seems to ensure that kuplot_res is started after an entry discus_res[kid]
// is set.
// As all individual repetitions receive the same trial values, "line" is done
// once in the "kid" loop

(int discus_res[]) discus_run(int generation, int member, int children,
                              int parameters, int nindiv, string trial_array[])
{
    foreach kid in [0:children-1]
    {
       int col[];
       line = substring(trial_array[kid],1,strlen(trial_array[kid])-1);
       foreach indiv in [0:nindiv-1]
       {
          string erg[];
          erg [indiv] = discus_calc(generation, member, children,
                                    parameters, kid+1, indiv+1,line);
          col [indiv] = toint(substring(erg[indiv],1,strlen(erg[indiv])-2));
       }
       discus_res[kid] = sum_integer(col);
    }
}

//
// KUPLOT_RUN *****************************************************************
//
// Loop over all children "kid" to calculate the cost function==R-value
// for this kid.

(string kuplot_res[]) kuplot_run(int generation, int member, int children,
                                 int parameters, int nindiv, int discus_res[])
{
    foreach kid in [0:children-1]
    {
       kuplot_res[kid] = kuplot_rvalue(generation, member, children,
                                       parameters, kid+1, nindiv,
                                       discus_res[kid]);
    }
}

//
// DIFFEV_RUN *****************************************************************
//
// Loop over all children "kid" to send the cost function values received from
// kuplot to diffev.
//?????????????????????????????????????????????????????????????????????????????
// I had to choose a loop, as I did not find a SWIFT way to convert the array
// "kuplot_res" into a single string and hand down this string to python,
// respectively DIFFEV, where the string might be broken down at compiler spped
// JMW: Try string_join()? Cf ./example.swift

(int    diffev_res[]) diffev_run(int children, string kuplot_res[], location L)
{
    foreach kid in [0:children-1]
    {
       string erg[];
       line            = kuplot_res[kid];
       erg[kid]        = diffev_rvalue  (kid, line, L);
       diffev_res[kid] = toint(substring(erg[kid],1,strlen(erg[kid])-2));
    }
}

//
// DIFFEV_CMP *****************************************************************
//
// Do the diffev "compare" command
// ????????????????????????????????????????????????????????????????????????????
// Here it is probably more efficient to integrate the function
// "diffev_compare" directly at this location rather than to have a seperate
// function... This just grew...
//

(float  cost        ) diffev_cmp(int generation, int kuplot_bck, location L)
{
    string erg      = diffev_compare (generation, kuplot_bck, L);
          cost      = tofloat(substring(erg,1,strlen(erg)-2));
}

//
// DO_CYCLE *******************************************************************
//
// This function performs all tasks required to be performed within one
// refinement cycle.
// Steps are:
//            get current trial values
//            perform the discus calculations
//            calculate cost function == rvalue via kuplot
//            send r-values to diffev
//            make a backup of current best solutions via kup.select.mac
//            perform diffev 'compare' command
// Return value:  best == lowest R-value
//
// ????????????????????????????????????????????????????????????????????????????
// I took this out of main, to "ease" synchronization. do_cycle returns the
// current best r-value, which I use within the loop in main for
// synchronization

(float best ) do_cycle( int generation, int member, int children,
                        int parameters, int nindiv, float current,
                        location diffev_process)
{
       string trials = diffev_trial(children, parameters, current,
                                    diffev_process);

       string trial_array[] = split(
                                    substring( trials, 1, strlen(trials)-1),
                                    "D"
                                   );

       int    discus_res[];
       string kuplot_res[];
       int    diffev_res[];
       discus_res  = discus_run(generation, member, children, parameters,
                                nindiv, trial_array);
       kuplot_res  = kuplot_run(generation, member, children, parameters,
                                nindiv, discus_res);
       diffev_res  = diffev_run(children,   kuplot_res, diffev_process);
       kuplot_bck  = kuplot_sel(children,   diffev_res);
              best = diffev_cmp(generation, kuplot_bck, diffev_process);
}

//  END definition of Swift composite functions


main
{
//  int generation;    // In line comment
  int member;
  int children;
  int parameters;
  int CYCLES = toint(argv("cycles"));
  // RBN: turbine complaines if I add a "-cycles=4" to the line in run.sh
  // JMW: Arguments to this Swift program have to be after refine.tcl

  // Define "diffev_process" as location of DIFFEV, needs to refer to this
  // process all the time
  location diffev_process = location_from_rank(1);

  // Initialize DIFFEV, currently with fixed macro file name
  // Returns a Python tuple with (gen, mem, child, para)
  //
  printf("PYTHONPATH: %s", getenv("PYTHONPATH"));

  string population = diffev_init("@diffev_start.mac", diffev_process);
  printf(" POPULATION %s \n",population);

  string g[]  = split(
                      substring(population, 1, strlen(population)-1),
                       "D"
                     );

//  generation  = toint( g[0]) ;
  member      = toint( g[1]) ;
  children    = toint( g[2]) ;
  parameters  = toint( g[3]) ;
  nindiv      = toint( g[4]) ;

  printf("member:   %i", member);
  printf("children: %i", children);

  // Here the loop over all refinement cycles begins
  // Tasks in each cycle are:
  //    get current parameters from diffev
  //    run all CHILDRENxNINDIV discus slaves in parallel
  //    run kuplot to work on all indivs for each child
  //    do DIFFEV "compare" command
  //
  // ??????????????????????????????????????????????????????????????????????????
  // I get the synchronization by feeding the current best R-value into
  // the "do_cycle" function and placing the result into the next entry
  // of the "rvalues[]" array.
  //

  float rvalues[];
  rvalues[0] = 1.0E9;
  for (int generation =0; generation < CYCLES; generation = generation + 1)
  {
       float current = rvalues[generation];
       float bestr   = do_cycle(generation, member, children, parameters,
                                nindiv, current, diffev_process);
       rvalues[generation+1] = bestr;
       printf(" DID Generation %d %f",generation,bestr);
  }
}

