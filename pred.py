from config import *
from utils.utils import task

import gzip
from numpy import mean, ceil
import shutil

with task('Training'):
    with open(train, 'r') as f_in:
        f_in.readline()
        stores = {}
        for line in f_in:
            store_id = int(line.split(',')[0])
            if not store_id in stores:
                stores[store_id] = {
                    'sales': 0.0,
                    'n': 0
                }
            is_open = int(line.split(',')[5])
            if is_open:
                customers = int(line.split(',')[4])
                stores[store_id]['sales'] += float(line.split(',')[3]) * customers
                stores[store_id]['n'] += customers
        for store_id  in stores:
            stores[store_id]['mean'] = stores[store_id]['sales']/stores[store_id]['n']

with task('Prediction'):
    with open(test, 'r') as f_in, open(predictions, 'w+') as f_out:
        f_in.readline()
        f_out.write('"Id","Sales"\n')
        for line in f_in:
            store_id = int(line.split(',')[1])
            is_open = 1 if line.split(',')[4] is '' else int(line.split(',')[4])
            sales = stores[store_id]['mean'] if is_open else 0
            f_out.write("%s,%.10f\n" % (line.split(',')[0], sales))

with task('GZip compression'):
    with open(predictions, 'r') as f_in, gzip.open(predictions_gz, 'w') as f_out:
        shutil.copyfileobj(f_in, f_out)
