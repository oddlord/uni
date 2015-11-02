from utils.fields import *
from utils.utils import *

import gzip
from numpy import mean, ceil
import shutil
from sklearn import *

data, options = parse_args()

def get_model():
    return tree.DecisionTreeRegressor()

features = ['Store', 'DayOfWeek', 'Promo', 'StateHoliday', 'SchoolHoliday']

with task('Feature extraction'):
    with open(data['train'], 'r') as f_train:
        f_train.readline()
        X_train = []
        Y_train = []
        for line in f_train:
            is_open = get_field(line, 'Open', Dataset.Train)
            if not is_open:
                continue
            x = []
            for feature in features:
                x.append(get_field(line, feature, Dataset.Train))
            X_train.append(x)
            Y_train.append(get_field(line, 'Sales', Dataset.Train))
    if options['validation']:
        X_vali = X_train[0:options['validation_limit']]
        Y_vali_target = Y_train[0:options['validation_limit']]
        X_train = X_train[options['validation_limit']:]
        Y_train = Y_train[options['validation_limit']:]
    with open(data['test'], 'r') as f_test:
        f_test.readline()
        X_test = []
        for line in f_test:
            x = []
            for feature in features:
                x.append(get_field(line, feature, Dataset.Test))
            X_test.append(x)
print "*\tFeatures: %d" % (len(features))
print "*\tTrain dataset: %d instances" % (len(X_train))
if options['validation']:
    print "*\tValidation dataset: %d instances" % (len(X_vali))
print "*\tTest dataset: %d instances" % (len(X_test))

with task('Training model'):
    model = get_model()
    model.fit(X_train, Y_train)
if options['validation']:
    Y_vali_pred = model.predict(X_vali)
    rmspe = compute_rmspe(Y_vali_target, Y_vali_pred)
    print "*\tRMSPE on validation data: %.8f" % (rmspe)

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
