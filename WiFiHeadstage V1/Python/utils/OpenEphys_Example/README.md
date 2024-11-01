# WiFi Headstage

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

