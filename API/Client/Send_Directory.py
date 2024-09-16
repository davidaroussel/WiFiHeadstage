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

    try:
        response = requests.post(server_url, data=data, files=files, timeout=120)
        print(response.text)
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")



if __name__ == '__main__':
    directory_path = r"C:\Users\david\Desktop\WiFi Headstage\API\media\Experiment A\Monkey A\Headstage V1\2024-05-21_19-15-00"
    User_Name = "david.roussel"
    Password = "<PASSWORD>"
    experiment_name = "Experiment A"
    subject_name = "Monkey A"
    device_name = "Headstage A"
    url = "http://10.63.56.1:10006/upload/"

    upload_experiment(directory_path, experiment_name, subject_name, device_name, url)
