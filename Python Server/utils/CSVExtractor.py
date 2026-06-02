import os
import csv
import matplotlib.pyplot as plt
from tqdm import tqdm


def plot_csv_data(directory):
    # Get a list of all CSV files in the directory
    files = [f for f in os.listdir(directory) if f.endswith('.csv')]

    # Iterate over each CSV file with a progress bar
    for file in tqdm(files, desc='Processing CSV files'):
        file_path = os.path.join(directory, file)

        with open(file_path, 'r') as csv_file:
            reader = csv.reader(csv_file, delimiter='\t')

            # Extract column names from the first row
            columns = next(reader)

            # Read and plot each column
            for i, column_name in enumerate(columns):
                data = []
                for row in reader:
                    if row:  # Skip empty rows
                        values = row[0].split('\t')
                        data.append(values[i])

                plt.figure()
                plt.plot(range(len(data)), data)
                plt.title(f'{file}: {column_name}')
                plt.xlabel('Index')
                plt.ylabel('Value')
                plt.grid(True)
                plt.show()


# Example usage:
directory = 'C://Users//david//Desktop//WiFi Headstage//WiFiHeadstage V1//Python//realtime data//2024-04-25_12-47-45'
plot_csv_data(directory)
