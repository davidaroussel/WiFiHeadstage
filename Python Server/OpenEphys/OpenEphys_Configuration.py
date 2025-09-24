import requests
import re
import zmq

class OpenEphys_Configuration:
    def __init__(self, ip_addr='localhost'):
        self.OE_port = 37497
        self.ip_addr = ip_addr
        self.gui_url = f"http://{self.ip_addr}:{self.OE_port}/api"
        self.session = requests.Session()
        self.NetworkEvent_url = f"tcp://{self.ip_addr}:{5556}"
        self.recording_node = None
        self.EphysSocket_id = None
        self.socket = None

    def Network_Events_Connect(self):
        context = zmq.Context()  # Store context in self to keep it alive
        self.socket = context.socket(zmq.REQ)  # Create REQ socket
        self.socket.RCVTIMEO = int(0.5 * 1000)  # Timeout in milliseconds
        self.socket.connect(self.NetworkEvent_url)  # Connect to the network events URL

    def GUI_Start_Acquisition(self):
        if self.socket != None:
            self.socket.send_string('StartAcquisition')
            retVal = self.socket.recv()
            # print("StartAcquisition: ", retVal)
            return retVal
        else:
            print("Socket Not Connected !!")
            exit()

    def GUI_Stop_Acquisition(self):
        if self.socket != None:
            self.socket.send_string('StopAcquisition')
            retVal = self.socket.recv()
            # print("StopAcquisition: ", retVal)
            return retVal
        else:
            print("Socket Not Connected !!")
            exit()

    def GUI_Start_Recording(self):
        if self.socket != None:
            self.socket.send_string('StartRecord')
            retVal = self.socket.recv()
            # print("StartRecord: ", retVal)
            return retVal
        else:
            print("Socket Not Connected !!")
            exit()

    def GUI_Stop_Recording(self):
        if self.socket != None:
            self.socket.send_string('StopRecord')
            retVal = self.socket.recv()
            # print("StopRecord: ", retVal)
            return retVal
        else:
            print("Socket Not Connected !!")
            exit()

    def get_GUI_Acquisition_status(self):
        self.socket.send_string('IsAcquiring')
        retVal = self.socket.recv()
        # print("IsAcquiring:", retVal)
        return retVal

    def get_GUI_Recording_status(self):
        self.socket.send_string('IsRecording')
        retVal = self.socket.recv()
        # print("IsRecording:", retVal)
        return retVal

    def get_GUI_status(self):
        r = self.session.get(f"{self.gui_url}/status")
        # print(r.json())
        status = r.json()["mode"]
        retVal = f"GUI Status: {status}"
        # print(retVal)
        return retVal

    def get_GUI_recording_node(self):
        r = self.session.get(f"{self.gui_url}/recording")
        # print(r.json())
        if "record_nodes" in r.json():
            self.recording_node = r.json()["record_nodes"][0]["node_id"]
            retVal = f"Recording Node: {self.recording_node}"
        else:
            print("")
            print("No Recording Nodes in the acquisition chaine !!")
            exit()
        # print(retVal)
        return retVal

    def get_GUI_recording_path(self):
        r = self.session.get(
            f"{self.gui_url}/recording")
        retVal = f"Recording DIR path: {r.json()['parent_directory']}"
        if r.json()["record_nodes"]:
            path = r.json()["record_nodes"][0]["parent_directory"]
            retVal = f"Recording path: {path}"
        # print(retVal)

        return retVal

    def set_GUI_recording_path(self, path):
        r = self.session.put(
            f"{self.gui_url}/recording/{self.recording_node}",
            json={"parent_directory": path})
        # print(r.json())
        retVal = f"Recording Path set to: {path}"
        # print(retVal)
        return retVal

    def get_ES_processor_id(self):
        found_ES = False
        r = self.session.get(f"{self.gui_url}/processors")
        for processor in r.json()["processors"]:
            processor_name = processor["name"]
            if processor_name == "Ephys Socket":
                self.EphysSocket_id = processor["id"]
                found_ES = True
        if found_ES:
            retVal = f"EphysSocket processor id: {self.EphysSocket_id}"
            # print(retVal)
            return retVal
        else:
            print(" ")
            print("!! EPHYS SOCKET PLUGIN NOT FOUND IN ACQUISITION CHAINE !!")
            exit()

    def get_ES_info(self):
        r = self.session.put(
            f"{self.gui_url}/processors/{self.EphysSocket_id}/config",
            json={"text": "ES INFO"})
        current_info = r.json()["info"]

        # print(r.json())

        port = re.search(r'Port\s*=\s*(\d+)', current_info)
        sample_rate = re.search(r'Sample rate\s*=\s*(\d+)', current_info)
        scale = re.search(r'Scale\s*=\s*([\d.]+)', current_info)
        offset = re.search(r'Offset\s*=\s*(\d+)', current_info)

        port_value = int(port.group(1)) if port else None
        sample_rate_value = int(sample_rate.group(1)) if sample_rate else None
        scale_value = float(scale.group(1).rstrip('.')) if scale else None
        offset_value = int(offset.group(1)) if offset else None

        retVal = f"EphysSocket Info: Port: {port_value} | Sample rate: {sample_rate_value} | Scale: {scale_value} | Offset: {offset_value}"
        # print(retVal)
        return retVal


    def set_ES_scale(self, scale_value):
        r = self.session.put(
            f"{self.gui_url}/processors/{self.EphysSocket_id}/config",
            json={"text": f"ES SCALE {scale_value}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES SCALE DIDNT WORK !!")
        else:
            retVal = f"New ES SCALE: {scale_value}"
            # print(retVal)
            return retVal

    def set_ES_offset(self, offset_value):
        r = self.session.put(
            f"{self.gui_url}/processors/{self.EphysSocket_id}/config",
            json={"text": f"ES OFFSET {offset_value}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES OFFSET DIDNT WORK !!")
        else:
            retVal = f"New ES OFFSET: {offset_value}"
            # print(retVal)
            return retVal

    def set_ES_port(self, port):
        r = self.session.put(
            f"{self.gui_url}/processors/{self.EphysSocket_id}/config",
            json={"text": f"ES PORT {port}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES PORT DIDNT WORK !!")
        else:
            retVal = f"New ES PORT: {port}"
            # print(retVal)
            return retVal

    def set_ES_frequency(self, frequency):
        r = self.session.put(
            f"{self.gui_url}/processors/{self.EphysSocket_id}/config",
            json={"text": f"ES FREQUENCY {frequency}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES FREQUENCY DIDNT WORK !!")
        else:
            retVal = f"New ES FREQUENCY: {frequency}"
            # print(retVal)
            return retVal
