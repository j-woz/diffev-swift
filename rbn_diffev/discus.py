import numpy
import lib_discus as discus

#
# PYTHON function discus_calc
#
# Sends the population info, and the trial parameters to discus.
# It then runs discus for kid and indiv
# A standardized macro "discus_swift.mac" is executed for the run
# Return value is the kid number
#
def discus_calc(generation, member, children, parameters, kid, indiv,trial_kid ):
    sender = numpy.array([generation, member, children, parameters, kid, indiv ])
    ier = discus.discus.send_i(sender,201,206)
#
    line = trial_kid.split('P',int(parameters))
    line = map(float,line)
    trials = numpy.array(line)
    ier = discus.discus.send_r(trials,201,200+int(parameters))
#
    command = "@discus_swift.mac"
    discus.discus.command(command)
    return str(kid)

