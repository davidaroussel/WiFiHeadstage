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


# This file may be used to create an environment using:
# $ conda create --name <env> --file <this file>
# platform: win-64
altgraph=0.17.4=pypi_0
asgiref=3.8.1=pypi_0
bleak=0.22.3=pypi_0
bzip2=1.0.8=h2bbff1b_5
ca-certificates=2024.3.11=haa95532_0
certifi=2024.2.2=pypi_0
charset-normalizer=3.3.2=pypi_0
colorama=0.4.6=pypi_0
contourpy=1.2.1=pypi_0
cycler=0.12.1=pypi_0
django=5.0.4=pypi_0
django-cors-headers=4.3.1=pypi_0
djangorestframework=3.15.1=pypi_0
expat=2.5.0=hd77b12b_0
fonttools=4.51.0=pypi_0
h5py=3.11.0=pypi_0
idna=3.7=pypi_0
joblib=1.4.2=pypi_0
keyboard=0.13.5=pypi_0
kiwisolver=1.4.5=pypi_0
kneed=0.8.5=pypi_0
libffi=3.4.4=hd77b12b_0
matplotlib=3.8.4=pypi_0
mysqlclient=2.2.4=pypi_0
natsort=8.4.0=pypi_0
numpy=1.26.4=pypi_0
open-ephys-python-tools=0.1.7=pypi_0
openssl=3.0.13=h2bbff1b_0
packaging=24.0=pypi_0
pandas=2.2.2=pypi_0
pefile=2023.2.7=pypi_0
pillow=10.3.0=pypi_0
pip=23.3.1=py312haa95532_0
pyinstaller=6.6.0=pypi_0
pyinstaller-hooks-contrib=2024.5=pypi_0
pyopenephys=1.2.0=pypi_0
pyparsing=3.1.2=pypi_0
python=3.12.2=h1d929f7_0
python-dateutil=2.9.0.post0=pypi_0
pytz=2024.1=pypi_0
pywin32-ctypes=0.2.2=pypi_0
pyyaml=6.0.1=pypi_0
pyzmq=26.0.3=pypi_0
quantities=0.15.0=pypi_0
requests=2.31.0=pypi_0
scikit-learn=1.5.0=pypi_0
scipy=1.13.0=pypi_0
setuptools=68.2.2=py312haa95532_0
six=1.16.0=pypi_0
sqlite=3.41.2=h2bbff1b_0
sqlparse=0.5.0=pypi_0
threadpoolctl=3.5.0=pypi_0
tk=8.6.12=h2bbff1b_0
tqdm=4.66.2=pypi_0
tzdata=2024.1=pypi_0
urllib3=2.2.1=pypi_0
vc=14.2=h21ff451_1
vs2015_runtime=14.27.29016=h5e58377_2
websockets=12.0=pypi_0
wheel=0.41.2=py312haa95532_0
winrt-runtime=2.3.0=pypi_0
winrt-windows-devices-bluetooth=2.3.0=pypi_0
winrt-windows-devices-bluetooth-advertisement=2.3.0=pypi_0
winrt-windows-devices-bluetooth-genericattributeprofile=2.3.0=pypi_0
winrt-windows-devices-enumeration=2.3.0=pypi_0
winrt-windows-foundation=2.3.0=pypi_0
winrt-windows-foundation-collections=2.3.0=pypi_0
winrt-windows-storage-streams=2.3.0=pypi_0
xmltodict=0.13.0=pypi_0
xz=5.4.6=h8cc25b3_0
zlib=1.2.13=h8cc25b3_0
zmq=0.0.0=pypi_0
