from config import data, options

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

def compute_rmspe(Y_target, Y_pred):
    rmspe = math.sqrt(numpy.mean([pow((y_t-y_p)/y_t, 2) for y_t, y_p in zip(Y_target, Y_pred) if y_t != 0]))
    return rmspe

def print_rmspe(Y_target, Y_pred, dataset):
    rmspe = compute_rmspe(Y_target, Y_pred)
    best_rmspe = rmspe
    if isfile(data['rmspe'][dataset]):
        with open(data['rmspe'][dataset], 'r') as f_rmspe:
            best_rmspe = float(f_rmspe.readline())
    delta_rmspe = float("%.5f" % (rmspe)) - best_rmspe
    start_format = ''
    end_format = ''
    sign = '+-'
    if delta_rmspe <= 0:
        with open(data['rmspe'][dataset], 'w+') as f_rmspe:
            f_rmspe.write("%.5f" % (rmspe))
    if delta_rmspe < 0:
        start_format = '\033[1m\033[92m'
        end_format = '\033[0m'
        sign = ''
    elif delta_rmspe > 0:
        start_format = '\033[1m\033[91m'
        end_format = '\033[0m'
        sign = '+'
    print "*\tRMSPE on %s data: %s%.5f%s (%s%.5f)" % (dataset, start_format, rmspe, end_format, sign, delta_rmspe)

def week_toordinal(date):
    return (date.toordinal()-1)/7

@contextmanager
def task(task_name):
    sys.stdout.write("*\n* %s... " % (task_name))
    sys.stdout.flush()
    start_time = time.clock()
    yield
    sys.stdout.write("[Done] (%.4f s.)\n" % (time.clock() - start_time))

def parse_args():
    usage_str = 'Usage:\n\tpred.py [-r <train_file>] [-s <store_file>] [-e <test_file>] [-p <prediction_file>] [-c] [-v [-l]]'
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
                + '\t-v|--validation:\tenable validation on a subset of the train dataset.\n'
                + '\t-l|--plot:\t\tshow validation plot.')
    try:
        opts, args =  getopt.getopt(sys.argv[1:], 'hr:s:e:p:cvl', ['help', 'train=', 'store=', 'test=', 'pred=', 'compress', 'validation', 'plot'])
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
        elif opt in ('-l', '--plot'):
            options['plot'] = True
    data['pred_gz'] = data['pred'] + '.gz'
    check_data(data)
    print "* GZip compression: %s" % (on_off[options['compress']])
    print "* Validation: %s" % (on_off[options['validation']])
    if options['validation']:
        print "* Plot: %s" % (on_off[options['plot']])
    sys.stdout.flush()
    return data, options

def check_data(data):
    if not isfile(data['train']):
        print "Train dataset '%s' not found!" % (data['train'])
        sys.exit(2)
    if not isfile(data['test']):
        print "Test dataset '%s' not found!" % (data['test'])
        sys.exit(2)
