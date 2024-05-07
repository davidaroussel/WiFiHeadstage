import os
import json
import requests

def get_directory_structure(directory_path):
    structure = {}
    top_directory = os.path.basename(directory_path)
    for root, dirs, files in os.walk(directory_path):
        if os.path.basename(root) != top_directory:
            current_dir = structure
            for dir_name in root.split(os.path.sep)[len(directory_path.split(os.path.sep)):]:
                current_dir = current_dir.setdefault(dir_name, {})
            for file_name in files:
                current_dir[file_name] = None
    return structure

def send_directory_structure(directory_structure, experiment_name, subject_name, device_name, url):
    data = {
        'ExperimentName': experiment_name,
        'Subject': subject_name,
        'Device': device_name,
        'DirectoryStructure': directory_structure
    }
    response = requests.post(url, json=data)
    if response.status_code == 200:
        print("Directory structure sent successfully.")
    else:
        print(f"Failed to send directory structure. Status code: {response.status_code}")

def send_files(directory_path, experiment_name, subject_name, device_name, url):
    directory_structure = get_directory_structure(directory_path)
    send_directory_structure(directory_structure, experiment_name, subject_name, device_name, url)

    # Iterate over all files and subdirectories in the directory
    for root, dirs, files in os.walk(directory_path):
        for filename in files:
            sending_file_path = os.path.relpath(os.path.join(root, filename), directory_path)
            file_path = os.path.join(root, filename)
            # Ensure that the file is a regular file (not a directory)
            if os.path.isfile(file_path):
                with open(file_path, 'rb') as file:
                    # Create a dictionary containing the file with 'data_file' as the key
                    files = {'data_file': (filename, file)}
                    # Include ExperimentName, subject name, device name, and full file path in the request payload
                    data = {
                        'ExperimentName': experiment_name,
                        'Subject': subject_name,
                        'Device': device_name,
                        'FilePath': sending_file_path
                    }
                    # Send the file using a POST request
                    response = requests.post(url, files=files, data=data)
                    # Check the response status
                    if response.status_code == 200:
                        print(f"File {filename} sent successfully.")
                    else:
                        print(f"Failed to send file {filename}. Status code: {response.status_code}")

# Example usage:
if __name__ == '__main__':
    directory_path = r"C:\Users\david\Documents\Open Ephys\2024-04-25_13-17-49 (Very Good - In cage)"
    experiment_name = "Experiment A"  # Replace with the actual experiment name
    subject_name = "Monkey A"  # Replace with the actual subject name
    device_name = "Headstage V1"  # Replace with the actual device name
    url = "http://127.0.0.1:8000/upload/"  # Replace with your upload endpoint
    send_files(directory_path, experiment_name, subject_name, device_name, url)
