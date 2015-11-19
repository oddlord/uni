from datetime import datetime, timedelta
import sys

class Dataset:
    Train, Test, Store = range(1, 4)

def field_strip(field):
    return field.rstrip('\n').strip('"')

def get_field(line, field, dataset):
    delim = fields[field]['delim'] if 'delim' in fields[field] else ','
    field_str = field_strip(line.split(delim)[fields[field][dataset]])
    return fields[field]['default'] if field_str == '' else fields[field]['parse'](field_str)

def get_competition_distance(store_features, store_id, date):
    c_month = store_features[store_id]['CompetitionOpenSinceMonth']
    c_year = store_features[store_id]['CompetitionOpenSinceYear']
    c_open_since = datetime(c_year, c_month, 1)
    c_distance = store_features[store_id]['CompetitionDistance'] if date >= c_open_since else sys.maxint
    return c_distance

def get_promo2_distance(store_features, store_id, date):
    year = int(date.strftime('%Y'))
    month = int(date.strftime('%m'))
    promo2 = store_features[store_id]['Promo2']
    promo2_distance = sys.maxint
    if promo2:
        promo2_week = store_features[store_id]['Promo2SinceWeek']
        promo2_year = store_features[store_id]['Promo2SinceYear']
        promo2_since = datetime.strptime("%d-%d-0" % (promo2_year, promo2_week), '%Y-%W-%w')
        if date >= promo2_since:
            promo2_interval = store_features[store_id]['PromoInterval']
            promo2_starts = [datetime(year - 1, promo2_interval[3], 1)]
            promo2_starts += [datetime(year, month, 1) for month in promo2_interval]
            promo2_starts += [datetime(year + 1, promo2_interval[0], 1)]
            for i in range(0, len(promo2_starts) - 1):
                if date >= promo2_starts[i] and date < promo2_starts[i+1]:
                    promo2_distance = (date - promo2_starts[i]).days
                    break
    return promo2_distance

def get_open_tomorrow(date_index, store_id, date, trainset, testset):
    tomorrow = date + timedelta(days=1)
    open_default = fields['Open']['default']
    tmr_info = date_index[tomorrow.toordinal()] if tomorrow.toordinal() in date_index.keys() else None
    if tmr_info is None:
        return open_default
    tmr_at = tmr_info['dataset']
    tmr_index = tmr_info[store_id] if store_id in tmr_info.keys() else None
    if tmr_index is None:
        return open_default
    line = trainset[tmr_index] if tmr_at == Dataset.Train else testset[tmr_index]
    tmr_open = get_field(line, 'Open', tmr_at)
    return tmr_open

def add_feature(x, feature):
    x.append(feature)

def build_store_features(storeset):
    store_features = {}
    headers = storeset[0].replace('"', '').replace('Store,', '').rstrip('\n').split(',')
    for line in storeset[1:]:
        store_id = get_field(line, 'Store', Dataset.Store)
        store_features[store_id] = {}
        for field in headers:
            store_features[store_id][field] = get_field(line, field, Dataset.Store)
    return store_features

def build_date_index(trainset, testset):
    first_train_date = datetime(2013, 1, 1)
    last_train_date = datetime(2015, 7, 31)
    first_test_date = datetime(2015, 8, 1)
    last_test_date = datetime(2015, 9, 17)
    date_index = {}
    for (lines, dataset) in [(trainset, Dataset.Train), (testset, Dataset.Test)]:
        line_count = 0
        for line in lines[1:]:
            line_count += 1
            store_id = get_field(line, 'Store', dataset)
            date = get_field(line, 'Date', dataset).toordinal()
            if date not in date_index.keys():
                date_index[date] = {}
                date_index[date]['dataset'] = dataset
            date_index[date][store_id] = line_count
    return date_index

def map_category(cat):
    categories_map = {
        '0': 0,
        'a': 1,
        'b': 2,
        'c': 3,
        'd': 4
    }
    return categories_map[cat]

def parse_promo_interval(promo_interval):
    months_map = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sept': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12
    }
    intervals = []
    months = promo_interval.split(',')
    for month in months:
        intervals += [months_map[month]]
    return intervals

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
        'default': 1,
        'parse': int
    },
    'Promo2SinceYear': {
        Dataset.Store: 8,
        'default': 2013,
        'parse': int
    },
    'PromoInterval': {
        Dataset.Store: 5,
        'delim': '"',
        'default': '',
        'parse': parse_promo_interval
    }
}
