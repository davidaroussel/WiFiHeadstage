# Open Ephys Data Extraction Example

1. Create a virtual environment to install dependencies.

2. ```
    conda create --name CustomEnv -y
    conda activate CustomEnv
    conda install python -y
    ```


2. Copy and paste the following list after opening the environment (`ENV`):

    ```
    python -m pip install open-ephys-python-tools
    python -m pip install numpy
    python -m pip install matplotlib
    python -m pip install pyopenephys
    python -m pip install scikit-learn

    ```

3. Verify that your IDE is using the proper interpreter (ENV).

4. 1. Run All The Files: Verify that the base_directory on line 20 is ../Raw Signals
4. 2. Run Specific Files: COPY/PASTE The Select Folder Inside ../Raw Signals/DOSSIER ANALYSE and 
Verify that the base_directory on line 20 is ../Raw Signals/DOSSIER ANALYSE


5. Add to modifications (plot, filter, etc...) to OpenEphys_Example.py

6. Run OpenEphys_Example.py
