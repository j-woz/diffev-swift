import numpy
import lib_diffev as diffev

#
# PYTHON function diffev_kommando
#
# A generic function to send the command "command" to DIFFEV.
#
def diffev_kommando(command):
    ier = diffev.diffev.command(command)
    return str(ier)

#
# PYTHON function diffev_init
#
# Executes the standardized macro "diffev_start.mac" to define
# the population, and to initialize the trial parameters
# Next the function tests for "setup.mac", in order to determine
# the number of individual repetitions
#
# Return value is the string of population parameters
#
def diffev_init(command):
    command = "@diffev_start.mac"
    ier = diffev.diffev.command(command)
    pop = numpy.array(diffev.diffev.pop())
    s = " "
    for i in [0,1,2,3]:
       s = s + str(pop[i]) + " D "

    command ='fexist setup.mac'
    ier = diffev.diffev.command(command)
    command ='i[201] = nint(res[1])'
    ier = diffev.diffev.command(command)
    result = numpy.array(diffev.diffev.get_i(201,201))
    if result == 1:
       command = '@setup.mac'
       ier     = diffev.diffev.command(command)
       command ='i[201] = nindiv'
       ier     = diffev.diffev.command(command)
       nindiv  = numpy.array(diffev.diffev.get_i(201,201))
       s = s + str(nindiv[0]) + " D"
    else:
       nindiv = 1
       s = s + str(nindiv) + " D"
    return s

#
# PYTHON function diffev_trial
#
# Gets the current trial parameters from DIFFEV
#
# Return value is a string of trial parameters
# A single "D" separates the children, 
# a single "P" the parameters within a child
#
def diffev_trial(children,parameters, current):
    trial = numpy.array(diffev.diffev.send_trial(children, parameters))
    s = "  "
    for kid in range(int(children)):
       for par in range(int(parameters)):
          s = s + str(trial[kid][par]) + " P"
       s = s[:-1] + " D "
    return s

#
# PYTHON function diffev_rvalue
#
# Send the current cost function value "rvalue" for
# child "kid" to diffev.
#
# Returns the kid number
#
def diffev_rvalue(kid, rvalue):
    command = 'child_val['+str(kid)+'+1] = ' + rvalue
    ier = diffev.diffev.command(command)
    return str(kid)

#
# PYTHON function diffev_compare
#
# Performs the DIFFEV command 'compare' in silent mode
#
# The rvalues must have been sent to diffev prior to this
# function
# 
# Returns the current best rvalue
#
# Commented line are for debugging to ensure that the cylcles
# are run consecutively
#
def diffev_compare(generation, all_kids):
#   sender  = numpy.array([generation])
#   ier = diffev.diffev.send_i(sender, 200,200)
#   command = 'i[201] = pop_gen[0]'
#   ier     = diffev.diffev.command(command)
#   actual  = numpy.array(diffev.diffev.get_i(201,201))
    ier = diffev.diffev.command("compare silent")
    command = 'r[201] = bestr[1]'
    ier     = diffev.diffev.command(command)
    bestr   = numpy.array(diffev.diffev.get_r(201,201))
#   ier = diffev.diffev.command("fopen 1, cycles.logfile, append")
#   ier = diffev.diffev.command("fput  1, i[200], i[201], r[201]")
#   ier = diffev.diffev.command("fclose 1")
    return str(bestr[0])
