
# wrappers.py

# Goes through each module and wraps all application functions
# with logging/profiling information

import os
from datetime import datetime, timedelta

import discus
import kuplot
import diffev

def wrap_log(msg):
    print "python_wrap:", msg

if os.getenv("DIFFEV_WRAPPERS") == "1":
    wrap_log("applying python wrappers...")
    template = """
def %s(*args):
        print "in wrapper"
        func = %s
        name = func.__name__
        start = datetime.now()
        wrap_log("running:" + name)
        result = func(*args)
        stop = datetime.now()
        duration = (stop-start).total_seconds()
        wrap_log("{:s}: duration: {:0.3f}".format(name, duration))
        return result
    """
    for m in [ discus, kuplot, diffev ]:
        module_name = m.__name__
        for function_name in m.__dict__.keys():
            if (function_name.find(module_name) == 0 and
                function_name != module_name):
                wrap_log("wrapping function: " + function_name)
                impl_name = function_name+"_impl"
                exec impl_name+"="+module_name+"."+function_name
                code = template % (function_name,
                                   impl_name)
                exec code
#                 print code
#                 exec "print " + impl_name
