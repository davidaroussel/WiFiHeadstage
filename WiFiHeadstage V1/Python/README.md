# WiFi Headstage

1. Create a virtual environment to install dependencies.

2. Copy and paste the following list after opening the environment (`ENV`):

    ```
    python -m pip install websockets
    python -m pip install numpy
    python -m pip install matplotlib
   ython -m pip install tqdm
    ```

3. Verify that your IDE is using the proper interpreter (ENV).

4. Connect to the BioML_Headstage WiFi.

5. Perform sampling:

    5.1. Open Ephys - Continuous:

        OpenEphysServer.py

    5.2. Use Python IDE - Fixed time period:

        PythonServer.py
