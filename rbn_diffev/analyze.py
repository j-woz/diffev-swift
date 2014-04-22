#!/usr/bin/env python

# ANALYZE.PY
# For post-processing DIFFEV output
# Reports number of calls to each Python function and
#     average call time

import re
import sys

if len(sys.argv) != 2:
    print "requires log file!"
    exit(1)

logfile = sys.argv[1]

print "logfile: " + logfile

with open(logfile) as f:
    content = f.readlines()

stats = dict()

rank_pattern = re.compile("\[\\d*\]")

for line in content:
    # print "line: " + line
    rank = ""
    offset = 0
    words = line.split()
    if len(words) < 2:
        continue
    # line may contain leading rank annotation
    if rank_pattern.match(words[0]) != None:
        rank = words[0]
        line = re.sub(rank_pattern, "", line)
        words = line.split()
    # print "line: " + line
    # print "words[offset] " + str(offset) + " " + words[offset]
    if words[offset] != "python_wrap:":
        # print "not python_wrap:"
        continue
    if words [offset+1] != "function:":
        # print "not function:"
        continue
    funcname = words[offset+2]
    # print "funcname: " + funcname
    duration = words[offset+4]
    # line may also end with mangled rank annotation
    p = duration.find("[")
    if p != -1:
        duration = duration[0:p]
    try:
        d = float(duration)
        print "stat: %s %-25s %f" % (rank, funcname, d)
    except ValueError:
        pass
    if not funcname in stats:
        stats[funcname] = []
    stats[funcname].append(d)

print "TOTALS:"
for f in stats:
    count = len(stats[f])
    print "%-25s %2i  %0.5f" % (f, count, sum(stats[f])/count)
