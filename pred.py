from config import *
from utils.utils import start_clock, end_clock

import gzip
from numpy import mean, ceil
import shutil

clock = start_clock('Training')
with open(train, 'r') as f_in:
    header = f_in.readline()
    mean = ceil(mean([float(line.split(',')[3]) for line in f_in]))
end_clock(clock)

clock = start_clock('Prediction')
with open(test, 'r') as f_in, open(predictions, 'w+') as f_out:
    header = f_in.readline()
    f_out.write('"Id","Sales"\n')
    for line in f_in:
        f_out.write("%s,%d\n" % (line.split(',')[0], mean))
end_clock(clock)

clock = start_clock('GZip compression')
with open(predictions, 'r') as f_in, gzip.open(predictions_gz, 'w') as f_out:
    shutil.copyfileobj(f_in, f_out)
end_clock(clock)
