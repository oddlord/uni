import sys
import time

def start_clock(task_name):
    sys.stdout.write("%s started..." % (task_name))
    return time.clock()

def end_clock(start_time):
    sys.stdout.write(" [Done] (%.4f s.)\n" % (time.clock() - start_time))
