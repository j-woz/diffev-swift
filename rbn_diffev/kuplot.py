import numpy
import lib_kuplot as kuplot
import wrappers

#
# PYTHON function kuplot_rvalue
#
# Sends the population info to kuplot.
# It then calculates the cost function for this kid
# Return value is the cost function value
#
def kuplot_rvalue(generation, member, children, parameters, kid, nindiv,discus_kid):
    sender = numpy.array([generation, member, children, parameters, kid, nindiv ])
    ier = kuplot.kuplot.send_i(sender,201,206)
#
    command = "@kuplot_swift.mac"
    kuplot.kuplot.command(command)
#
    rvalue = numpy.array(kuplot.kuplot.get_r(201,201))
    s = str(rvalue[0])
    return s
#
# PYTHON function kuplot_sel
#
# Interface to the standardized macro "kup.select.mac" that does a
# backup of the current best solutions
#
def kuplot_sel(children, diffev_res):
    command = "@kup.select.mac"
    ier = kuplot.kuplot.command(command)
    return str(diffev_res)

import wrappers
