
def f(m,p):
    print('python: members:' + str(m))
    return "VALUE"

def diffev_init():
    print('diffev_init()')
    return {'members':3,'parameters':4}

def discus(members, parameters, cycle, member):
    print('discus: ' + str(cycle) + ' ' + str(member))
    return "DISCUS VALUE: " + str(cycle) + ' ' + str(member)
 
def kuplot(discus_output, members, parameters, cycle, member):
    print('kuplot: '  + discus_output )
    return "KUPLOT VALUE"

