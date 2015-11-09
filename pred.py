from utils.features import *
from utils.utils import *

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

data, options = parse_args()

model = tree.DecisionTreeRegressor()
store_features = ['StoreType', 'Assortment']
dataset_features = ['Store', 'DayOfWeek', 'Promo', 'StateHoliday', 'SchoolHoliday']

def build_store_features():
    with open(data['store'], 'r') as f_store:
        parsed_store_features = {}
        f_store.readline()
        for line in f_store:
            store_id = get_field(line, store_fields, 'Store')
            parsed_store_features[store_id] = {}
            for field in [field for field in store_fields.keys() if field not in ['Store', 'PromoInterval']]:
                parsed_store_features[store_id][field] = get_field(line, store_fields, field)
            parsed_store_features[store_id]['PromoInterval'] = store_fields['PromoInterval']['parse'](field_strip(line.split('"')[5]))
    return parsed_store_features

def extract_train_features():
    with open(data['train'], 'r') as f_train:
        X_train = []
        Y_train = []
        f_train.readline()
        for line in f_train:
            is_open = get_field(line, fields, 'Open', Dataset.Train)
            if not is_open:
                continue
            x = []
            store_id = get_field(line, fields, 'Store', Dataset.Train)
            for feature in store_features:
                x.append(parsed_store_features[store_id][feature])
            for feature in dataset_features:
                x.append(get_field(line, fields, feature, Dataset.Train))
            X_train.append(x)
            Y_train.append(get_field(line, fields, 'Sales', Dataset.Train))
    return X_train, Y_train

def setup_validation(X_train, Y_train):
    X_vali = X_train[0:options['validation_limit']]
    Y_vali_target = Y_train[0:options['validation_limit']]
    X_train = X_train[options['validation_limit']:]
    Y_train = Y_train[options['validation_limit']:]
    return X_vali, Y_vali_target, X_train, Y_train

def extract_test_features():
    with open(data['test'], 'r') as f_test:
        X_test = []
        f_test.readline()
        for line in f_test:
            x = []
            store_id = get_field(line, fields, 'Store', Dataset.Test)
            for feature in store_features:
                x.append(parsed_store_features[store_id][feature])
            for feature in dataset_features:
                x.append(get_field(line, fields, feature, Dataset.Test))
            X_test.append(x)
    return X_test

# Feature extraction
with task('Feature extraction'):
    parsed_store_features = build_store_features()
    X_train, Y_train = extract_train_features()
    if options['validation']:
        X_vali, Y_vali_target, X_train, Y_train = setup_validation(X_train, Y_train)
    X_test = extract_test_features()
print "*\tFeatures: %d" % (len(store_features)+len(dataset_features))
print "*\tTrain dataset: %d instances" % (len(X_train))
if options['validation']:
    print "*\tValidation dataset: %d instances" % (len(X_vali))
print "*\tTest dataset: %d instances" % (len(X_test))

# Training
with task('Training model'):
    model.fit(X_train, Y_train)
if options['validation']:
    Y_vali_pred = model.predict(X_vali)
    rmspe = compute_rmspe(Y_vali_target, Y_vali_pred)
    print "*\tRMSPE on validation data: %.5f" % (rmspe)

# Prediction
with task('Test prediction'), open(data['test'], 'r') as f_test, open(data['pred'], 'w+') as f_pred:
    f_test.readline()
    f_pred.write('"Id","Sales"\n')
    Y_test = model.predict(X_test)
    for line in f_test:
        y_id = get_field(line, fields, 'Id', Dataset.Test)
        is_open = get_field(line, fields, 'Open', Dataset.Test)
        y = Y_test[y_id-1] if is_open else 0
        f_pred.write("%s,%.8f\n" % (y_id, y))
print "*\tPredictions saved to '%s'" % (data['pred'])
if options['compress']:
    with open(data['pred'], 'r') as f_pred, gzip.open(data['pred_gz'], 'w') as f_gz:
        shutil.copyfileobj(f_pred, f_gz)
    print "*\tPredictions gzipped to '%s'" % (data['pred_gz'])
