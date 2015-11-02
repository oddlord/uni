from utils import to_int

class Dataset:
    Train, Test = range(2)

state_holiday_map = {
    '0': 0,
    'a': 1,
    'b': 2,
    'c': 3
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
        'parse': (lambda field: 1 if field == '' else to_int(field))
    },
    'Promo': {
        Dataset.Train: 6,
        Dataset.Test: 5,
        'parse': to_int
    },
    'StateHoliday': {
        Dataset.Train: 7,
        Dataset.Test: 6,
        'parse': (lambda field: state_holiday_map[field.strip('"')])
    },
    'SchoolHoliday': {
        Dataset.Train: 8,
        Dataset.Test: 7,
        'parse': (lambda field: int(field.rstrip('\n').strip('"')))
    }
}

def get_raw_field(line, field, dataset):
    return line.split(',')[fields[field][dataset]]

def get_field(line, field, dataset):
    return fields[field]['parse'](get_raw_field(line, field, dataset))
