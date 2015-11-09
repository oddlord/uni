from utils.features import *
from utils.utils import *

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

data, options = parse_args()

model = tree.DecisionTreeRegressor()

def extract_features(data_path, dataset):
    with open(data_path, 'r') as f_data:
        X = []
        Y = []
        f_data.readline()
        for line in f_data:
            is_open = get_field(line, 'Open', dataset)
            if dataset == Dataset.Train and not is_open:
                continue
            x = []
            store_id = get_field(line, 'Store', dataset)
            x.append(store_features[store_id]['StoreType'])
            x.append(store_features[store_id]['Assortment'])
            x.append(get_field(line, 'Store', dataset))
            x.append(get_field(line, 'DayOfWeek', dataset))
            x.append(get_field(line, 'Promo', dataset))
            x.append(get_field(line, 'StateHoliday', dataset))
            x.append(get_field(line, 'SchoolHoliday', dataset))
            X.append(x)
            if dataset == Dataset.Train:
                Y.append(get_field(line, 'Sales', dataset))
    return X, Y

def setup_validation(X_train, Y_train):
    X_vali = X_train[0:options['validation_limit']]
    Y_vali_target = Y_train[0:options['validation_limit']]
    X_train = X_train[options['validation_limit']:]
    Y_train = Y_train[options['validation_limit']:]
    return X_vali, Y_vali_target, X_train, Y_train

# Feature extraction
with task('Feature extraction'):
    store_features = build_store_features(data['store'])
    X_train, Y_train = extract_features(data['train'], Dataset.Train)
    if options['validation']:
        X_vali, Y_vali_target, X_train, Y_train = setup_validation(X_train, Y_train)
    X_test = extract_features(data['test'], Dataset.Test)[0]
print "*\tFeatures: %d" % (len(X_train[0]))
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
        y_id = get_field(line, 'Id', Dataset.Test)
        is_open = get_field(line, 'Open', Dataset.Test)
        y = Y_test[y_id-1] if is_open else 0
        f_pred.write("%s,%.8f\n" % (y_id, y))
print "*\tPredictions saved to '%s'" % (data['pred'])
if options['compress']:
    with open(data['pred'], 'r') as f_pred, gzip.open(data['pred_gz'], 'w') as f_gz:
        shutil.copyfileobj(f_pred, f_gz)
    print "*\tPredictions gzipped to '%s'" % (data['pred_gz'])
