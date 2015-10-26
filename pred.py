from utils.utils import task, parse_args

import gzip
from numpy import mean, ceil
import shutil
from sklearn import neighbors

data, options = parse_args()

state_holiday_map = {
    '0': 0,
    'a': 1,
    'b': 2,
    'c': 3
}

with task('Training'), open(data['train'], 'r') as f_in:
    f_in.readline()
    sales = []
    observations = []
    for line in f_in:
        is_open = int(line.split(',')[5])
        if not is_open:
            continue
        observation = []
        observation.append(int(line.split(',')[0])) # Store
        observation.append(int(line.split(',')[1])) # DayOfWeek
        observation.append(int(line.split(',')[6])) # Promo
        observation.append(state_holiday_map[line.split(',')[7].strip('"')]) # StateHoliday
        observation.append(int(line.split(',')[8].rstrip('\n').strip('"'))) # SchoolHoliday
        observations.append(observation)
        sales.append(float(line.split(',')[3])) # Sales
    model = neighbors.KNeighborsRegressor(30, 'distance')
    model.fit(observations, sales)

with task('Test prediction'), open(data['test'], 'r') as f_in, open(data['pred'], 'w+') as f_out:
    f_in.readline()
    f_out.write('"Id","Sales"\n')
    for line in f_in:
        is_open = 1 if line.split(',')[4] == '' else int(line.split(',')[4])
        if is_open:
            test_observation = [[]]
            test_observation[0].append(int(line.split(',')[1])) # Store
            test_observation[0].append(int(line.split(',')[2])) # DayOfWeek
            test_observation[0].append(int(line.split(',')[5])) # Promo
            test_observation[0].append(state_holiday_map[line.split(',')[6].strip('"')]) # StateHoliday
            test_observation[0].append(int(line.split(',')[7].rstrip('\n').strip('"'))) # SchoolHoliday
            predicted_sales = model.predict(test_observation)[0]
        else:
            predicted_sales = 0
        f_out.write("%s,%.8f\n" % (line.split(',')[0], predicted_sales))

if options['compress']:
    with task('GZip compression'), open(data['pred'], 'r') as f_in, gzip.open(data['pred_gz'], 'w') as f_out:
        shutil.copyfileobj(f_in, f_out)
