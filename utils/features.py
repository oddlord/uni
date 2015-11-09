from utils import to_int

class Dataset:
    Train, Test = range(1, 3)

def field_strip(field):
    return field.rstrip('\n').strip('"')

def get_raw_field(line, field_dict, field, dataset=None):
    where = dataset if dataset else 'at'
    return line.split(',')[field_dict[field][where]]

def get_field(line, field_dict, field, dataset=None):
    field_str = field_strip(get_raw_field(line, field_dict, field, dataset))
    return field_dict[field]['default'] if field_str == '' else field_dict[field]['parse'](field_str)

def map_category(cat):
    categories_map = {
        '0': 0,
        'a': 1,
        'b': 2,
        'c': 3,
        'd': 4
    }
    return categories_map[cat]

store_fields = {
    'Store': {
        'at': 0,
        'parse': to_int
    },
    'StoreType': {
        'at': 1,
        'parse': map_category
    },
    'Assortment': {
        'at': 2,
        'parse': map_category
    },
    'CompetitionDistance': {
        'at': 3,
        'default': -1,
        'parse': to_int
    },
    'CompetitionOpenSinceMonth': {
        'at': 4,
        'default': -1,
        'parse': to_int
    },
    'CompetitionOpenSinceYear': {
        'at': 5,
        'default': -1,
        'parse': to_int
    },
    'Promo2': {
        'at': 6,
        'parse': to_int
    },
    'Promo2SinceWeek': {
        'at': 7,
        'default': -1,
        'parse': to_int
    },
    'Promo2SinceYear': {
        'at': 8,
        'default': -1,
        'parse': to_int
    },
    'PromoInterval': {
        'at': 9,
        'parse': (lambda field: field)
    }
}

fields = {
    'Id': {
        Dataset.Test: 0,
        'parse': to_int
    },
    'Store': {
        Dataset.Train: 0,
        Dataset.Test: 1,
        'parse': to_int
    },
    'DayOfWeek': {
        Dataset.Train: 1,
        Dataset.Test: 2,
        'parse': to_int
    },
    'Date': {
        Dataset.Train: 2,
        Dataset.Test: 3
    },
    'Sales': {
        Dataset.Train: 3,
        'parse': (lambda field: float(field))
    },
    'Customers': {
        Dataset.Train: 4,
        'parse': to_int
    },
    'Open': {
        Dataset.Train: 5,
        Dataset.Test: 4,
        'default': 1,
        'parse': to_int
    },
    'Promo': {
        Dataset.Train: 6,
        Dataset.Test: 5,
        'parse': to_int
    },
    'StateHoliday': {
        Dataset.Train: 7,
        Dataset.Test: 6,
        'parse': map_category
    },
    'SchoolHoliday': {
        Dataset.Train: 8,
        Dataset.Test: 7,
        'parse': to_int
    }
}
