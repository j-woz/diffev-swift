
import numpy
from lib_diffev import *

def diffev_init():
    print('diffev_init()')
    return {'members':3,'parameters':4}

def discus(members, parameters, cycle, member):
    print('discus: ' + str(cycle) + ' ' + str(member))
    return "DISCUS VALUE: " + str(cycle) + ' ' + str(member)

def diffev_komando(command):
    print('diffev komando: ' + command)
    diffev_interface.command(command)
    return "KOMANDO VALUE:"
 
def kuplot(discus_output, members, parameters, cycle, member):
    print('kuplot: '  + discus_output )
    return "KUPLOT VALUE"

