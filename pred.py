from utils.features import *
from utils.utils import *

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

data, options = parse_args()

def get_model():
    return tree.DecisionTreeRegressor()

def extract_instance(data_path, dataset, line):
    x = []
    y = []
    store_id = get_field(line, 'Store', dataset)
    x.append(store_features[store_id]['StoreType'])
    x.append(store_features[store_id]['Assortment'])
    x.append(get_field(line, 'DayOfWeek', dataset))
    x.append(get_field(line, 'Promo', dataset))
    x.append(get_field(line, 'StateHoliday', dataset))
    x.append(get_field(line, 'SchoolHoliday', dataset))
    if dataset == Dataset.Train:
        y = get_field(line, 'Sales', dataset)
    return x, y

def extract_train_features(data_path, validation):
    with open(data_path, 'r') as f_data:
        X_train = {}
        Y_train = {}
        X_vali = []
        Y_vali_target = []
        f_data.readline()
        line_count = 1
        for line in f_data:
            is_open = get_field(line, 'Open', Dataset.Train)
            store_id = get_field(line, 'Store', Dataset.Train)
            if not validation and not is_open:
                continue
            if not store_id in X_train:
                X_train[store_id] = []
                Y_train[store_id] = []
            x, y = extract_instance(data_path, Dataset.Train, line)
            if validation and line_count < options['validation_limit']:
                X_vali.append({
                    'store_id': store_id,
                    'open': is_open,
                    'x': x
                })
                Y_vali_target.append(y)
            else:
                X_train[store_id].append(x)
                Y_train[store_id].append(y)
            line_count += 1
    return X_train, Y_train, X_vali, Y_vali_target

def extract_test_features(data_path):
    with open(data_path, 'r') as f_data:
        X_test = []
        f_data.readline()
        for line in f_data:
            is_open = get_field(line, 'Open', Dataset.Test)
            store_id = get_field(line, 'Store', Dataset.Test)
            instance_id = get_field(line, 'Id', Dataset.Test)
            x, y = extract_instance(data_path, Dataset.Test, line)
            X_test.append({
                'id': instance_id,
                'store_id': store_id,
                'open': is_open,
                'x': x
                })
    return X_test

# Feature extraction
with task('Feature extraction'):
    store_features = build_store_features(data['store'])
    X_train, Y_train, X_vali, Y_vali_target = extract_train_features(data['train'], options['validation'])
    X_test = extract_test_features(data['test'])
print "*\tFeatures: %d" % (len(X_train[1][0]))
print "*\tTrain dataset: %d instances" % (reduce(lambda x,y: x+y, [len(X_train[store_id]) for store_id in X_train.keys()]))
if options['validation']:
    print "*\tValidation dataset: %d instances" % (len(X_vali))
print "*\tTest dataset: %d instances" % (len(X_test))

# Training
with task('Training model'):
    models = {}
    for store_id in X_train.keys():
        models[store_id] = get_model()
        models[store_id].fit(X_train[store_id], Y_train[store_id])
if options['validation']:
    Y_vali_pred = []
    for x in X_vali:
        Y_vali_pred.append(0 if not x['open'] else models[x['store_id']].predict([x['x']]))
    rmspe = compute_rmspe(Y_vali_target, Y_vali_pred)
    print "*\tRMSPE on validation data: %.5f" % (rmspe)

# Prediction
with task('Test prediction'), open(data['pred'], 'w+') as f_pred:
    f_pred.write('"Id","Sales"\n')
    for x in X_test:
        y = 0 if not x['open'] else models[x['store_id']].predict([x['x']])
        f_pred.write("%s,%.8f\n" % (x['id'], y))
print "*\tPredictions saved to '%s'" % (data['pred'])
if options['compress']:
    with open(data['pred'], 'r') as f_pred, gzip.open(data['pred_gz'], 'w') as f_gz:
        shutil.copyfileobj(f_pred, f_gz)
    print "*\tPredictions gzipped to '%s'" % (data['pred_gz'])
