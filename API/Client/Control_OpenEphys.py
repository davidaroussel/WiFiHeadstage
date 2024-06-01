from Send_Directory import upload_experiment

import time

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl


if __name__ == '__main__':
    directory_path = r"C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\2024-04-25_13-17-49 (Very Good - In cage)"
    User_Name = "david.roussel"
    Password = "<PASSWORD>"
    experiment_name = "Experiment A"
    subject_name = "Monkey A"
    device_name = "Headstage V1"
    url = "http://127.0.0.1:8000/upload/"

    channel = 5
    state = 1

    gui_starter = OpenEphysHTTPServer(address='localhost')
    gui_ttl = NetworkControl(ip_address='localhost', port=5556)

    response = gui_starter.get_processors()

    ephys_socket_processor = None
    for processor in response:
        if processor['name'] == 'Ephys Socket':
            ephys_socket_processor = processor
            break

    response = gui_starter.message("ES DISCONNECT")
    print("DISCONNECTING", response)
    if ephys_socket_processor is None:
        print("Ephys Socket processor not found.")
    else:
        processor_id = ephys_socket_processor['id']

        commands = [
            "ES SCALE 1.0",
            "ES OFFSET 100.0",
            "ES PORT 12345",
            "ES FREQUENCY 30000"
        ]

        # Send each command to the Ephys Socket processor
        for command in commands:
            response = gui_starter.config(processor_id, command)
            print(f"Set {command} result:", response)






    # Run the experiment cycle three times
    for i in range(3):
        gui_starter.set_base_text(f"TESTING {i}")
        gui_starter.acquire()
        gui_starter.record()
        print("RECORDING")
        print(gui_starter.get_recording_info())

        counter = 0
        while counter < 10:  # Loop for 10 seconds (0.5s * 20 iterations)
            gui_ttl.send_ttl(line=channel, state=state)
            time.sleep(1)
            state = not state
            counter += 1

        gui_starter.idle()
        print("STOPPING RECORDING")
        upload_experiment(directory_path, experiment_name, subject_name, device_name, url)
        print("UPLOAD COMPLETE")