data = {
    'train': 'data/train.csv',
    'store': 'data/store.csv',
    'test': 'data/test.csv',
    'pred': 'data/predictions.csv',
    'rmspe': {
        'training': 'rmspe_train.tmp',
        'validation': 'rmspe_vali.tmp'
    }
}

options = {
    'compress': False,
    'validation': False,
    'validation_limit': 68016,  # last two months
    'per_store_training': True,
    'plot': False
}
