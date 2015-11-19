from utils.features import *
from utils.utils import *

from datetime import datetime
import gzip
from matplotlib import pyplot as plt
import shutil
from sklearn import tree
import sys

global data, options, trainset, testset, storeset, store_features, date_index, models

def get_model():
    return tree.DecisionTreeRegressor()

def extract_instance(line, dataset):
    x = []
    y = []
    store_id = get_field(line, 'Store', dataset)
    date = get_field(line, 'Date', dataset)

    if not options['per_store_training']:
        add_feature(x, store_id)

    features = ['DayOfWeek', 'Promo', 'CompetitionDistance', 'OpenTomorrow']

    for feature in features:
        if feature == 'Assortment':
            add_feature(x, store_features[store_id]['Assortment'])
        elif feature == 'CompetitionDistance':
            add_feature(x, get_competition_distance(store_features, store_id, date))
        elif feature == 'DayOfYear':
            add_feature(x, int(date.strftime('%j')))
        elif feature == 'DayOfWeek':
            add_feature(x, get_field(line, 'DayOfWeek', dataset))
        elif feature == 'MonthOfYear':
            add_feature(x, int(date.strftime('%m')))
        elif feature == 'OpenTomorrow':
            add_feature(x, get_open_tomorrow(date_index, store_id, date, trainset, testset))
        elif feature == 'Promo':
            add_feature(x, get_field(line, 'Promo', dataset))
        elif feature == 'Promo2':
            add_feature(x, get_promo2_distance(store_features, store_id, date))
        elif feature == 'SchoolHoliday':
            add_feature(x, get_field(line, 'SchoolHoliday', dataset))
        elif feature == 'StateHoliday':
            add_feature(x, get_field(line, 'StateHoliday', dataset))
        elif feature == 'StoreType':
            add_feature(x, store_features[store_id]['StoreType'])

    if dataset == Dataset.Train:
        y = get_field(line, 'Sales', dataset)
    return x, y

def extract_train_features():
    X_train = {}
    Y_train = {}
    start = options['validation_limit'] if options['validation'] else 1
    for line in trainset[start:]:
        is_open = get_field(line, 'Open', Dataset.Train)
        store_id = get_field(line, 'Store', Dataset.Train) if options['per_store_training'] else 1
        if not is_open:
            continue
        if not store_id in X_train:
            X_train[store_id] = []
            Y_train[store_id] = []
        x, y = extract_instance(line, Dataset.Train)
        X_train[store_id] += [x]
        Y_train[store_id] += [y]
    return X_train, Y_train

def extract_validation_features():
    X_vali = []
    Y_vali_target = []
    for line in trainset[1:options['validation_limit']]:
        is_open = get_field(line, 'Open', Dataset.Train)
        store_id = get_field(line, 'Store', Dataset.Train) if options['per_store_training'] else 1
        x, y = extract_instance(line, Dataset.Train)
        X_vali += [{
            'store_id': store_id,
            'open': is_open,
            'x': x
        }]
        Y_vali_target += [y]
    return X_vali, Y_vali_target

def extract_test_features():
    X_test = []
    for line in testset[1:]:
        is_open = get_field(line, 'Open', Dataset.Test)
        store_id = get_field(line, 'Store', Dataset.Test) if options['per_store_training'] else 1
        instance_id = get_field(line, 'Id', Dataset.Test)
        x, y = extract_instance(line, Dataset.Test)
        X_test += [{
            'id': instance_id,
            'store_id': store_id,
            'open': is_open,
            'x': x
        }]
    return X_test

def predict_instance(x):
    return 0 if not x['open'] else models[x['store_id']].predict([x['x']])

def main():
    global trainset, testset, storeset, store_features, date_index, models
    data, options = parse_args()

    # Reading datasets
    with task('Reading datasets'):
        with open(data['train'], 'r') as f_train:
            trainset = f_train.readlines()
        with open(data['test'], 'r') as f_test:
            testset = f_test.readlines()
        with open(data['store'], 'r') as f_store:
            storeset = f_store.readlines()

    # Feature extraction
    with task('Extracting features'):
        store_features = build_store_features(storeset)
        date_index = build_date_index(trainset, testset)
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
                Y_vali_pred += [predict_instance(x)]
            rmspe = compute_rmspe(Y_vali_target, Y_vali_pred)
        print "*\tRMSPE on validation data: %.5f" % (rmspe)
        if options['plot']:
            store_id = 1
            Y_plot_target = [y for (x,y) in zip(X_vali, Y_vali_target) if x['store_id'] == store_id]
            Y_plot_pred = [y for (x,y) in zip(X_vali, Y_vali_pred) if x['store_id'] == store_id]
            plt.plot(Y_plot_target, c='blue', ls='-', lw='3')
            plt.plot(Y_plot_pred, c='red', ls='--', marker='o')
            plt.title("Validation plot")
            plt.grid(True)
            plt.show(block=False)

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

    if options['validation'] and options['plot']:
        plt.show(block=True)

if __name__ == '__main__':
    main()
    sys.exit(0)
