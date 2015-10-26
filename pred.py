from utils.utils import task, parse_args, to_int

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

data, options = parse_args()

state_holiday_map = {
    '0': 0,
    'a': 1,
    'b': 2,
    'c': 3
}

field_idx = {
    'Id': {
        'test': 0,
        'parse': (lambda field: field)
    },
    'Store': {
        'train': 0,
        'test': 1,
        'parse': to_int
    },
    'DayOfWeek': {
        'train': 1,
        'test': 2,
        'parse': to_int
    },
    'Date': {
        'train': 2,
        'test': 3
    },
    'Sales': {
        'train': 3,
        'parse': (lambda field: float(field))
    },
    'Customers': {
        'train': 4,
        'parse': to_int
    },
    'Open': {
        'train': 5,
        'test': 4,
        'parse': (lambda field: 1 if field == '' else to_int(field))
    },
    'Promo': {
        'train': 6,
        'test': 5,
        'parse': to_int
    },
    'StateHoliday': {
        'train': 7,
        'test': 6,
        'parse': (lambda field: state_holiday_map[field.strip('"')])
    },
    'SchoolHoliday': {
        'train': 8,
        'test': 7,
        'parse': (lambda field: int(field.rstrip('\n').strip('"')))
    }
}

def get_model():
    return neighbors.KNeighborsRegressor(30, 'distance')

def get_raw_field(line, field, dataset):
    return line.split(',')[field_idx[field][dataset]]

def get_field(line, field, dataset):
    return field_idx[field]['parse'](get_raw_field(line, field, dataset))

features = ['Store', 'DayOfWeek', 'Promo', 'StateHoliday', 'SchoolHoliday']

with task('Training'), open(data['train'], 'r') as f_in:
    f_in.readline()
    X_train = []
    Y_train = []
    for line in f_in:
        is_open = get_field(line, 'Open', 'train')
        if not is_open:
            continue
        x = []
        for feature in features:
            x.append(get_field(line, feature, 'train'))
        X_train.append(x)
        Y_train.append(float(line.split(',')[3]))
    model = get_model()
    model.fit(X_train, Y_train)

with task('Test prediction'), open(data['test'], 'r') as f_in, open(data['pred'], 'w+') as f_out:
    f_in.readline()
    f_out.write('"Id","Sales"\n')
    for line in f_in:
        is_open = get_field(line, 'Open', 'test')
        if is_open:
            X_test = [[]]
            for feature in features:
                X_test[0].append(get_field(line, feature, 'test'))
            Y_test = model.predict(X_test)[0]
        else:
            Y_test = 0
        f_out.write("%s,%.8f\n" % (get_field(line, 'Id', 'test'), Y_test))

if options['compress']:
    with task('GZip compression'), open(data['pred'], 'r') as f_in, gzip.open(data['pred_gz'], 'w') as f_out:
        shutil.copyfileobj(f_in, f_out)
