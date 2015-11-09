from config import data

from contextlib import contextmanager
import getopt
import math
import numpy
from os.path import isfile
import sys
import time

on_off = {
    True: '\033[1m\033[92mON\033[0m',
    False: '\033[1m\033[91mOFF\033[0m'
}

options = {
    'compress': False,
    'validation': False,
    'validation_limit': 68015   # last two months
}

def to_int(string):
    return int(string)

def compute_rmspe(Y_target, Y_pred):
    rmspe = math.sqrt(numpy.mean([pow((y_t-y_p)/y_t, 2) for y_t, y_p in zip(Y_target, Y_pred) if y_t != 0]))
    return rmspe

@contextmanager
def task(task_name):
    sys.stdout.write("*\n* %s... " % (task_name))
    sys.stdout.flush()
    start_time = time.clock()
    yield
    sys.stdout.write("[Done] (%.4f s.)\n" % (time.clock() - start_time))

def parse_args():
    usage_str = 'Usage:\n\tpred.py [-r <train_file>] [-s <store_file>] [-e <test_file>] [-p <prediction_file>] [-c]'
    help_str = ('Training script for the Rossman Store Sales competition on Kaggle.\n'
                + 'Author: Tommaso Papini, tommaso.papini1@stud.unifi.it\n'
                + usage_str + '\n'
                + 'Options:\n'
                + '\t-h|--help:\t\tprint this help message.\n'
                + '\t-r|--train:\t\ttrain dataset to be used.\n'
                + '\t-s|--store:\t\tstore dataset with additional info.\n'
                + '\t-e|--test:\t\ttest dataset to be used.\n'
                + '\t-p|--pred:\t\tpath to the prediction .csv output file.\n'
                + '\t-c|--compress:\t\tenable output compression to a gzip archive.\n'
                + '\t-v|--validation:\tenable validation on a subset of the train dataset.')
    try:
        opts, args =  getopt.getopt(sys.argv[1:], 'hr:s:e:p:cv', ['help', 'train=', 'store=', 'test=', 'pred=', 'compress', 'validation'])
    except getopt.GetoptError:
        print usage_str
        sys.exit(1)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            print help_str
            sys.exit()
        elif opt in ('-r', '--train'):
            data['train'] = arg
        elif opt in ('-s', '--store'):
            data['store'] = arg
        elif opt in ('-e', '--test'):
            data['test'] = arg
        elif opt in ('-p', '--pred'):
            data['pred'] = arg
        elif opt in ('-c', '--compress'):
            options['compress'] = True
        elif opt in ('-v', '--validation'):
            options['validation'] = True
    data['pred_gz'] = data['pred'] + '.gz'
    check_data(data)
    print "* GZip compression: %s" % (on_off[options['compress']])
    print "* Validation: %s" % (on_off[options['validation']])
    sys.stdout.flush()
    return data, options

def check_data(data):
    if not isfile(data['train']):
        print "Train dataset '%s' not found!" % (data['train'])
        sys.exit(2)
    if not isfile(data['test']):
        print "Test dataset '%s' not found!" % (data['test'])
        sys.exit(2)
