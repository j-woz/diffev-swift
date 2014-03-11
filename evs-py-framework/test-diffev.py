
import numpy
from lib_diffev import *

# A = numpy.array([ [ 1 , 2 ] , [ 3, 4 ] ]);
# print(A)

# print(A*2)

diffev_interface.interactive()

print dir(diffev_interface)

diffev_interface.command("eval 4")

diffev_interface.f()

print 'ok'
