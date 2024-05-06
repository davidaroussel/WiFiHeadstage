import requests

BASE_URL = "http://127.0.0.1:8000/"

def get_subjects(subject_name=None):
    url = BASE_URL + 'subjects/'
    params = {'SubjectName': subject_name} if subject_name else {}
    response = requests.get(url, params=params)
    return response.json()

def create_subject(subject_name):
    url = BASE_URL + 'subjects/'
    data = {'SubjectName': subject_name}
    response = requests.post(url, data=data)
    return response.json()

def update_subject(subject_id, updated_name):
    url = BASE_URL + 'subjects/'
    data = {'SubjectId': subject_id, 'SubjectName': updated_name}
    response = requests.put(url, data=data)
    return response.json()

def delete_subject(subject_id):
    url = BASE_URL + 'subjects/'
    data = {'SubjectId': subject_id}
    response = requests.delete(url, data=data)
    return response.json()

# Device API functions

def get_devices(device_name=None):
    url = BASE_URL + 'devices/'
    params = {'DeviceName': device_name} if device_name else {}
    response = requests.get(url, params=params)
    return response.json()

def create_device(device_name):
    url = BASE_URL + 'devices/'
    data = {'DeviceName': device_name}
    response = requests.post(url, data=data)
    return response.json()

def update_device(device_id, updated_name):
    url = BASE_URL + 'devices/'
    data = {'DeviceId': device_id, 'DeviceName': updated_name}
    response = requests.put(url, data=data)
    return response.json()

def delete_device(device_id):
    url = BASE_URL + 'devices/'
    data = {'DeviceId': device_id}
    response = requests.delete(url, data=data)
    return response.json()

# Experiment API functions

def get_experiments(experiment_name=None):
    url = BASE_URL + 'experiments/'
    params = {'ExperimentName': experiment_name} if experiment_name else {}
    response = requests.get(url, params=params)
    return response.json()

def create_experiment(experiment_data):
    url = BASE_URL + 'experiments/'
    response = requests.post(url, data=experiment_data)
    return response.json()

def update_experiment(experiment_id, updated_name):
    url = BASE_URL + 'experiments/'
    data = {'ExperimentId': experiment_id, 'ExperimentName': updated_name}
    response = requests.put(url, data=data)
    return response.json()

def delete_experiment(experiment_id):
    url = BASE_URL + 'experiments/'
    data = {'ExperimentId': experiment_id}
    response = requests.delete(url, data=data)
    return response.json()


if __name__ == '__main__':
    print(get_subjects())
    create_subject("Monkey Python")
    print(get_subjects())
