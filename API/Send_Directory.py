import time

import requests
import os
import zipfile
from django.http import HttpResponse
import tempfile

def upload_experiment(directory_to_zip, experiment_name, subject_name, device_name, server_url):
    temp_dir = tempfile.mkdtemp()
    zip_file_path = os.path.join(temp_dir, "experiment.zip")

    with zipfile.ZipFile(zip_file_path, 'w') as zipf:
        for root, dirs, files in os.walk(directory_to_zip):
            for file in files:
                file_path = os.path.join(root, file)
                zipf.write(file_path, os.path.relpath(file_path, directory_to_zip))

    data = {
        'ExperimentName': experiment_name,
        'Subject': subject_name,
        'Device': device_name,
    }

    files = {'zip_file': open(zip_file_path, 'rb')}

    response = requests.post(server_url, data=data, files=files)
    print(response.text)



if __name__ == '__main__':
    directory_path = r"C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\2024-04-25_13-17-49 (Very Good - In cage)"
    User_Name = "david.roussel"
    Password = "<PASSWORD>"
    experiment_name = "Experiment A"
    subject_name = "Monkey B"
    device_name = "Headstage V1"
    url = "http://127.0.0.1:8000/upload/"

    upload_experiment(directory_path, experiment_name, subject_name, device_name, url)