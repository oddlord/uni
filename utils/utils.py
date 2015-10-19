from config import data

from contextlib import contextmanager
import getopt
from os.path import isfile
import sys
import time

@contextmanager
def task(task_name):
    sys.stdout.write("%s started... " % (task_name))
    sys.stdout.flush()
    start_time = time.clock()
    yield
    sys.stdout.write("[Done] (%.4f s.)\n" % (time.clock() - start_time))
    sys.stdout.flush()

def parse_args():
    usage_str = 'pred.py [-r <train_file>] [-e <test_file>] [-p <prediction_file>] [-c]'
    help_str = 'Training script for the Rossman Store Sales competition on Kaggle.\n' \
                + 'Author: Tommaso Papini, tommaso.papini1@stud.unifi.it\n' \
                + 'Usage:\n' \
                + '\t' + usage_str + '\n' \
                + 'Options:\n' \
                + '\t-h|--help:\tprint this help message.\n' \
                + '\t-r|--train:\ttrain dataset to be used.\n' \
                + '\t-e|--test:\ttest dataset to be used.\n' \
                + '\t-p|--pred:\tpath to the prediction .csv output file.\n' \
                + '\t-c|--compress:\tenable output compression to a gzip archive.'
    compress = False
    try:
        opts, args =  getopt.getopt(sys.argv[1:], 'hr:e:p:c', ['help', 'train=', 'test=', 'pred=', 'compress'])
    except getopt.GetoptError:
        print help_str
        sys.exit(1)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            print help_str
            sys.exit()
        elif opt in ('-r', '--train'):
            data['train'] = arg
        elif opt in ('-e', '--test'):
            data['test'] = arg
        elif opt in ('-p', '--pred'):
            data['pred'] = arg
        elif opt in ('-c', '--compress'):
            compress = True
    check_data(data)
    return data, compress

def check_data(data):
    if not isfile(data['train']):
        print "Train dataset '%s' not found!" % (data['train'])
        sys.exit(2)
    if not isfile(data['test']):
        print "Test dataset '%s' not found!" % (data['test'])
        sys.exit(2)
