from contextlib import contextmanager
import sys
import time

@contextmanager
def task(task_name):
    sys.stdout.write("%s started..." % (task_name))
    start_time = time.clock()
    yield
    sys.stdout.write(" [Done] (%.4f s.)\n" % (time.clock() - start_time))
