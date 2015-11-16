from datetime import datetime
import sys

class Dataset:
    Train, Test, Store = range(1, 4)

def field_strip(field):
    return field.rstrip('\n').strip('"')

def get_field(line, field, dataset):
    delim = fields[field]['delim'] if 'delim' in fields[field] else ','
    field_str = field_strip(line.split(delim)[fields[field][dataset]])
    return fields[field]['default'] if field_str == '' else fields[field]['parse'](field_str)

def add_feature(x, feature):
    x.append(feature)

def build_store_features(store_path):
    store_features = {}
    with open(store_path, 'r') as f_store:
        headers = f_store.readline().replace('"', '').replace('Store,', '').rstrip('\n').split(',')
        for line in f_store:
            store_id = get_field(line, 'Store', Dataset.Store)
            store_features[store_id] = {}
            for field in headers:
                store_features[store_id][field] = get_field(line, field, Dataset.Store)
    return store_features

def map_category(cat):
    categories_map = {
        '0': 0,
        'a': 1,
        'b': 2,
        'c': 3,
        'd': 4
    }
    return categories_map[cat]

fields = {
    'Id': {
        Dataset.Test: 0,
        'parse': int
    },
    'Store': {
        Dataset.Train: 0,
        Dataset.Test: 1,
        Dataset.Store: 0,
        'parse': int
    },
    'DayOfWeek': {
        Dataset.Train: 1,
        Dataset.Test: 2,
        'parse': int
    },
    'Date': {
        Dataset.Train: 2,
        Dataset.Test: 3,
        'parse': (lambda field: datetime.strptime(field, "%Y-%m-%d"))
    },
    'Sales': {
        Dataset.Train: 3,
        'parse': float
    },
    'Customers': {
        Dataset.Train: 4,
        'parse': int
    },
    'Open': {
        Dataset.Train: 5,
        Dataset.Test: 4,
        'default': 1,
        'parse': int
    },
    'Promo': {
        Dataset.Train: 6,
        Dataset.Test: 5,
        'parse': int
    },
    'StateHoliday': {
        Dataset.Train: 7,
        Dataset.Test: 6,
        'default': 0,
        'parse': map_category
    },
    'SchoolHoliday': {
        Dataset.Train: 8,
        Dataset.Test: 7,
        'default': 0,
        'parse': int
    },
    'StoreType': {
        Dataset.Store: 1,
        'parse': map_category
    },
    'Assortment': {
        Dataset.Store: 2,
        'parse': map_category
    },
    'CompetitionDistance': {
        Dataset.Store: 3,
        'default': sys.maxint,
        'parse': int
    },
    'CompetitionOpenSinceMonth': {
        Dataset.Store: 4,
        'default': 1,
        'parse': int
    },
    'CompetitionOpenSinceYear': {
        Dataset.Store: 5,
        'default': 2013,
        'parse': int
    },
    'Promo2': {
        Dataset.Store: 6,
        'parse': int
    },
    'Promo2SinceWeek': {
        Dataset.Store: 7,
        'default': -1,
        'parse': int
    },
    'Promo2SinceYear': {
        Dataset.Store: 8,
        'default': -1,
        'parse': int
    },
    'PromoInterval': {
        Dataset.Store: 5,
        'delim': '"',
        'default': '',
        'parse': (lambda field: field)
    }
}
