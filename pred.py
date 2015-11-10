from utils.features import *
from utils.utils import *

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

global data, options, store_features, models
data, options = parse_args()

def get_model():
    return tree.DecisionTreeRegressor()

def extract_instance(line, data_path, dataset):
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

def extract_train_features():
    with open(data['train'], 'r') as f_train:
        X_train = {}
        Y_train = {}
        start = 1 if not options['validation'] else options['validation_limit']
        for line in f_train.readlines()[start:]:
            is_open = get_field(line, 'Open', Dataset.Train)
            store_id = get_field(line, 'Store', Dataset.Train)
            if not is_open:
                continue
            if not store_id in X_train:
                X_train[store_id] = []
                Y_train[store_id] = []
            x, y = extract_instance(line, data['train'], Dataset.Train)
            X_train[store_id].append(x)
            Y_train[store_id].append(y)
    return X_train, Y_train

def extract_validation_features():
    with open(data['train'], 'r') as f_vali:
        X_vali = []
        Y_vali_target = []
        for line in f_vali.readlines()[1:options['validation_limit']]:
            is_open = get_field(line, 'Open', Dataset.Train)
            store_id = get_field(line, 'Store', Dataset.Train)
            x, y = extract_instance(line, data['train'], Dataset.Train)
            X_vali.append({
                'store_id': store_id,
                'open': is_open,
                'x': x
            })
            Y_vali_target.append(y)
    return X_vali, Y_vali_target

def extract_test_features():
    with open(data['test'], 'r') as f_test:
        X_test = []
        for line in f_test.readlines()[1:]:
            is_open = get_field(line, 'Open', Dataset.Test)
            store_id = get_field(line, 'Store', Dataset.Test)
            instance_id = get_field(line, 'Id', Dataset.Test)
            x, y = extract_instance(line, data['test'], Dataset.Test)
            X_test.append({
                'id': instance_id,
                'store_id': store_id,
                'open': is_open,
                'x': x
                })
    return X_test

def predict_instance(x):
    return 0 if not x['open'] else models[x['store_id']].predict([x['x']])

# Feature extraction
with task('Extracting features'):
    store_features = build_store_features(data['store'])
    X_train, Y_train = extract_train_features()
    if options['validation']:
        X_vali, Y_vali_target = extract_validation_features()
    X_test = extract_test_features()
print "*\tFeatures: %d" % (len(X_train[1][0]))
print "*\tTrain dataset: %d instances" % (reduce(lambda x,y: x+y, [len(X_train[store_id]) for store_id in X_train.keys()]))
if options['validation']:
    print "*\tValidation dataset: %d instances" % (len(X_vali))
print "*\tTest dataset: %d instances" % (len(X_test))

# Training
with task('Training model(s)'):
    models = {}
    for store_id in X_train.keys():
        models[store_id] = get_model()
        models[store_id].fit(X_train[store_id], Y_train[store_id])

# Validation
if options['validation']:
    with task('Testing validation data'):
        Y_vali_pred = []
        for x in X_vali:
            Y_vali_pred.append(predict_instance(x))
        rmspe = compute_rmspe(Y_vali_target, Y_vali_pred)
    print "*\tRMSPE on validation data: %.5f" % (rmspe)

# Prediction
with task('Predicting test data'), open(data['pred'], 'w+') as f_pred:
    f_pred.write('"Id","Sales"\n')
    for x in X_test:
        f_pred.write("%s,%.8f\n" % (x['id'], predict_instance(x)))
print "*\tPredictions saved to '%s'" % (data['pred'])
if options['compress']:
    with open(data['pred'], 'r') as f_pred, gzip.open(data['pred_gz'], 'w') as f_gz:
        shutil.copyfileobj(f_pred, f_gz)
    print "*\tPredictions gzipped to '%s'" % (data['pred_gz'])
