# WiFi Headstage

1. Create a virtual environment to install dependencies.

2. Copy and paste the following list after opening the environment (`ENV`):

    ```
    python -m pip install websockets
    python -m pip install open-ephys-python-tools
    python -m pip install numpy
    python -m pip install matplotlib
    python -m pip install tqdm
    python -m pip install pyopenephys
    python -m pip install scikit-learn
    python -m pip install kneed

    ```

3. Verify that your IDE is using the proper interpreter (ENV).

4. Connect to the BioML_Headstage WiFi.

5. Perform sampling:

    5.1. Open Ephys - Continuous:

        OpenEphysServer.py

    5.2. Use Python IDE - Fixed time period:

        PythonServer.py


altgraph==0.17.4
asgiref==3.8.1
bleak==0.22.3
certifi==2024.2.2
charset-normalizer==3.3.2
colorama==0.4.6
contourpy==1.2.1
cycler==0.12.1
Django==5.0.4
django-cors-headers==4.3.1
djangorestframework==3.15.1
fonttools==4.51.0
h5py==3.11.0
idna==3.7
joblib==1.4.2
keyboard==0.13.5
kiwisolver==1.4.5
kneed==0.8.5
matplotlib==3.8.4
mysqlclient==2.2.4
natsort==8.4.0
numpy==1.26.4
open-ephys-python-tools==0.1.7
packaging==24.0
pandas==2.2.2
pefile==2023.2.7
pillow==10.3.0
pyinstaller==6.6.0
pyinstaller-hooks-contrib==2024.5
pyopenephys==1.2.0
pyparsing==3.1.2
python-dateutil==2.9.0.post0
pytz==2024.1
pywin32-ctypes==0.2.2
PyYAML==6.0.1
pyzmq==26.0.3
quantities==0.15.0
requests==2.31.0
scikit-learn==1.5.0
scipy==1.13.0
setuptools==68.2.2
six==1.16.0
sqlparse==0.5.0
threadpoolctl==3.5.0
tqdm==4.66.2
tzdata==2024.1
urllib3==2.2.1
websockets==12.0
wheel==0.41.2
winrt-runtime==2.3.0
winrt-Windows.Devices.Bluetooth==2.3.0
winrt-Windows.Devices.Bluetooth.Advertisement==2.3.0
winrt-Windows.Devices.Bluetooth.GenericAttributeProfile==2.3.0
winrt-Windows.Devices.Enumeration==2.3.0
winrt-Windows.Foundation==2.3.0
winrt-Windows.Foundation.Collections==2.3.0
winrt-Windows.Storage.Streams==2.3.0
xmltodict==0.13.0
zmq==0.0.0
