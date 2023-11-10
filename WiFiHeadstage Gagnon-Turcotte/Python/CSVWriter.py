import os
import csv
from threading import Thread
import time
import queue

class CSVWriter():
    def __init__(self, queue_csv_data, p_channels, p_buffer_size, p_buffer_factor):
        self.queue_csv_data = queue_csv_data
        self.num_channels = len(p_channels)
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.m_csvwritingThread = Thread(target=self.writeData)
        self.csv_file = None  # Initialize the CSV file as None

    def create_directory(self):
        # Create a new directory with a unique name based on the current time
        current_time = time.strftime("%Y-%m-%d_%H-%M-%S", time.localtime())
        self.data_directory = os.path.join("realtime_data", current_time)
        os.makedirs(self.data_directory)

    def startThread(self):
        self.create_directory()  # Create a new directory when starting the thread
        self.m_csvwritingThread.start()

    def stopThread(self):
        self.m_csvwritingThread.join()

    def writeData(self):
        start_time = time.time()
        while True:
            if not os.path.exists(self.data_directory):
                self.create_directory()  # Create a new directory if it doesn't exist

            # Create a new CSV file with the current time as the name (hour-minute-second.csv)
            current_time = time.strftime("%H-%M-%S", time.localtime())
            csv_file_path = os.path.join(self.data_directory, f"{current_time}.csv")

            if self.csv_file is not None:
                self.csv_file.close()  # Close the previous file

            self.csv_file = open(csv_file_path, mode='w', newline='')
            csv_writer = csv.writer(self.csv_file)

            # Write the header row with channel numbers
            channel_numbers = [f'Channel {i}' for i in range(self.num_channels)]
            csv_writer.writerow(channel_numbers)

            data_to_write = [[] for _ in range(self.num_channels)]  # Initialize empty lists for each channel

            start_time = time.time()

            while True:
                data = self.queue_csv_data.get()  # Wait for up to 10 seconds to get data
                for i in range(self.num_channels):
                    data_to_write[i].extend(data[i])  # Append the data to the respective channel list
                if time.time() - start_time >= 10:
                    break  # Break the loop after 10 seconds of no data

            # Transpose the data to write it in columns
            transposed_data = list(zip(*data_to_write))

            # Write all the accumulated data to the CSV file
            for data_row in transposed_data:
                csv_writer.writerow(data_row)

            self.csv_file.close()  # Close the file for this period
            self.csv_file = None  # Reset the CSV file reference

            # Reset the start time for the next period
            start_time = time.time()
