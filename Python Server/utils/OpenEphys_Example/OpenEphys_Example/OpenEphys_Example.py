import csv
import os
os.environ["OMP_NUM_THREADS"] = "1"
from datetime import datetime
import numpy as np

from scipy.interpolate import make_interp_spline
from open_ephys.analysis import Session

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


# Define the directory for analysis results
src_directory = r'analysis_results/'

# Define the directory for raw data in Open Ephys format
base_directory = r'../Raw Signals/DOSSIER ANALYSE'
current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
# Define the save directory with the current date and time
save_directory = os.path.join(src_directory, current_time)
if not os.path.exists(save_directory):
    os.makedirs(save_directory)
# Path for experiments folders in Open Ephys format
experiment_directories = [os.path.join(base_directory, directory) for directory in os.listdir(base_directory) if
                          os.path.isdir(os.path.join(base_directory, directory))]

experiment_data = {}
for experiment_directory in experiment_directories:
    directory_name = os.path.basename(experiment_directory)
    print(f"\nProcessing Experiment Directory: {directory_name}")
    session = Session(experiment_directory)
    recordnode = session.recordnodes[0]
    recording = recordnode.recordings[0]
    continuous = recording.continuous[0]
    start_sample_index = 0
    # Get the length of the continuous data
    num_samples_continuous = continuous.samples.shape[0]
    print(f"{num_samples_continuous} of samples")

    # data = continuous.get_samples(10000, 30000)
    data = continuous.get_samples(start_sample_index, num_samples_continuous)
    num_samples, num_channels = data.shape
    fs = continuous.metadata['sample_rate']
    print(f"Signal Sampling Freq : {fs}Hz")


