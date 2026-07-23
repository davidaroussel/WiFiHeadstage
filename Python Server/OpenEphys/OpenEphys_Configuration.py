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

    def configure_Socket_Plugin(self, OPENEPHYS_PORT, FREQUENCY):
        retVal_list = []
        try:
            retVal_list.append(self.get_GUI_status())
            retVal_list.append(self.get_GUI_recording_node())
            retVal_list.append(self.set_GUI_recording_path(r"C:\Users\david\Documents\Open Ephys\TESTING"))
            retVal_list.append(self.get_ES_processor_id())
            retVal_list.append(self.get_ES_info())
            retVal_list.append(self.set_ES_scale(0.195))
            retVal_list.append(self.set_ES_offset(32768))
            retVal_list.append(self.set_ES_port(OPENEPHYS_PORT))
            retVal_list.append(self.set_ES_frequency(FREQUENCY))
            retVal_list.append(self.get_ES_info())
        except Exception as e:
            print("[WARNING] OpenEphys Needs to be Started to configure EphysSocket")
            exit()
        return retVal_list

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
        ES_process_found = 0
        self.EphysSocket_id = []
        r = self.session.get(f"{self.gui_url}/processors")
        for processor in r.json()["processors"]:
            processor_name = processor["name"]
            if processor_name == "Ephys Socket":
                self.EphysSocket_id.append(processor["id"])
                found_ES = True
                ES_process_found += 1
        if found_ES:
            # print(f"[OPENEPHYS] FOUND {ES_process_found} EPHYS SOCKET Processor ")
            retVal = f"EphysSocket processor id: {self.EphysSocket_id}"
            # print(retVal)
            return retVal
        else:
            print(" ")
            print("!! EPHYS SOCKET PLUGIN NOT FOUND IN ACQUISITION CHAINE !!")
            exit()

    def get_ES_info(self, processor_id):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
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

    def get_GUI_recording_info(self):
        r = self.session.get(f"{self.gui_url}/recording")
        data = r.json()

        self.recording_node = data["record_nodes"][0]["node_id"]
        self.recording_path = data["record_nodes"][0]["parent_directory"]

        return data

    def set_ES_scale(self,processor_id, scale_value):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES SCALE {scale_value}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES SCALE DIDNT WORK !!")
        else:
            retVal = f"New ES SCALE: {scale_value}"
            # print(retVal)
            return retVal

    def set_ES_offset(self,processor_id, offset_value):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES OFFSET {offset_value}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES OFFSET DIDNT WORK !!")
        else:
            retVal = f"New ES OFFSET: {offset_value}"
            # print(retVal)
            return retVal

    def set_ES_port(self, processor_id, port):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES PORT {port}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES PORT DIDNT WORK !!")
        else:
            retVal = f"New ES PORT: {port}"
            # print(retVal)
            return retVal

    def set_ES_frequency(self, processor_id, frequency):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES FREQUENCY {frequency}"})
        # print(r.json())
        success = r.json()["info"]
        if success != "SUCCESS":
            print("SET ES FREQUENCY DIDNT WORK !!")
        else:
            retVal = f"New ES FREQUENCY: {frequency}"
            # print(retVal)
            return retVal

    def get_ES_Connection_Status(self, processor_id):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES CONNECTION_STATUS"})
        status = r.json()["info"]
        return status


    def CONNECT_ES(self, processor_id):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES CONNECT"})
        status = r.json()["info"]
        return status

    def DISCONNECT_ES(self, processor_id):
        r = self.session.put(
            f"{self.gui_url}/processors/{processor_id}/config",
            json={"text": f"ES DISCONNECT"})
        status = r.json()["info"]
        return status


    def OE_INIT_PLUGIN(self, OE_config, PRINT_OE_INFO, CONFIGURE_OPENEPHYS, OE_SOCKET_PORT, OPENEPHYS_SCALE, SAMPLING_FREQ, OPENEPHYS_OFFSET):
        retVal_list = []
        try:
            if CONFIGURE_OPENEPHYS:
                needed_config = False
                # retVal_list.append(OE_config.get_GUI_status())
                OE_config.get_GUI_recording_node()
                # OE_config.set_GUI_recording_path(r"C:\Users\david\Documents\Open Ephys\TESTING")
                OE_config.get_ES_processor_id()

                # TO PRINT RETURNED VALUE FROM OPEN EPHYS
                # retVal_list.append(OE_config.get_GUI_recording_node())
                # retVal_list.append(OE_config.set_GUI_recording_path(r"C:\Users\david\Documents\Open Ephys\TESTING"))
                # retVal_list.append(OE_config.get_ES_processor_id())
                for idx, processor_id in enumerate(OE_config.EphysSocket_id):
                    current_val = OE_config.get_ES_info(processor_id)
                    parts = current_val.split(":", 1)[1].split("|")
                    data = {}
                    for part in parts:
                        key, value = part.strip().split(":", 1)
                        data[key.strip()] = float(value.strip())
                    # retVal_list.append("BEFORE: " + current_val)
                    if data["Port"] != OE_SOCKET_PORT[idx]:
                        retVal_list.append(OE_config.set_ES_port(processor_id, OE_SOCKET_PORT[idx]))
                        needed_config = True
                    if data["Scale"] != OPENEPHYS_SCALE:
                        retVal_list.append(OE_config.set_ES_scale(processor_id, OPENEPHYS_SCALE))
                        needed_config = True
                    if data["Sample rate"] != SAMPLING_FREQ[idx]:
                        retVal_list.append(OE_config.set_ES_frequency(processor_id, SAMPLING_FREQ[idx]))
                        needed_config = True
                    if data["Offset"] != OPENEPHYS_OFFSET:
                        retVal_list.append(OE_config.set_ES_offset(processor_id, OPENEPHYS_OFFSET))
                        needed_config = True
                    # retVal_list.append("AFTER: " + OE_config.get_ES_info(processor_id))
                if not needed_config:
                    print("[OPENEPHYS] EPHYS SOCKET ALREADY SETUP")

                if PRINT_OE_INFO:
                    for retVal in retVal_list:
                        print(retVal)
                    print("\n")
        except Exception as e:
            print("[WARNING] OpenEphys Needs to be Started to configure EphysSocket")
            print(e)
            exit()