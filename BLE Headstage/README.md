# WiFi Headstage

1. Create a virtual environment to install dependencies.

2. Copy and paste the following list after opening the environment (`ENV`):

    ```
    python -m pip install bleak
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
