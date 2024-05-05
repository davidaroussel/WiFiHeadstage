import requests

device_id = 1
message_data = {"field1": "value1", "field2": "value2"}  # Example message data

url = "http://127.0.0.1:8000/api/log/"


payload = {"user_id": device_id}

response = requests.post(url, json=payload)

print(response.status_code)  # Check if the request was successful
