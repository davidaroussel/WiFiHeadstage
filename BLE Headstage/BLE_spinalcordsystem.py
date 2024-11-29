import asyncio
from queue import Queue
import bleak.exc
from bleak import discover
from bleak import BleakClient
from bleak import BleakScanner
import time
import threading
import os, sys
import struct


# Class for communicating with the BLE device
class SpinalCordSystem_BLE:

    def __init__(self, p_name, p_queue_raw_data=Queue(), p_channels=None, p_buffer_factor=None):
        self.queue_raw = p_queue_raw_data
        self.channels = p_channels
        self.buffer_factor = p_buffer_factor
        self.first_response = False
        self._devices = []
        self._packets_to_send = []
        self._m_client = 0
        self._m_BLE_Thread = 0
        self._tx_charac = '6e400003-b5a3-f393-e0a9-e50e24dcca9e'
        self._rx_charac = '6e400002-b5a3-f393-e0a9-e50e24dcca9e'
        self._connected = False
        self._request_deconnection = False
        self.device_name = p_name
        self.data_counter = 0

    def __del__(self):
        self.disconnect()

    # ----------Public methods----------
    def startBLE_Thread(self):
        print("Starting BLE Host Thread")
        if self._m_BLE_Thread == 0:
            self._m_BLE_Thread = threading.Thread(target=self.__connect_to_BLEbetween_callback)
            self._m_BLE_Thread.start()
        elif not self._m_BLE_Thread.is_alive():
            self._m_BLE_Thread = threading.Thread(target=self.__connect_to_BLEbetween_callback)
            self._m_BLE_Thread.start()

    def stopThread(self):
        self._m_BLE_Thread.join()

    # Function to send the initiation header: tt 0 xx yy c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16
    def sendInitiationPacket(self, ble_power=8, channel_mode=4, channels=None):
        if channel_mode not in (16, 8, 4):
            print("Invalid channel mode. Must be 16, 8, or 4.")
            return

        # Automatically configure channels based on the selected mode
        channels = list(range(1, channel_mode + 1))

        # Adjust channel mode field: 0 for 16, 1 for 8, 2 for 4
        channel_mode_field = {16: 0, 8: 1, 4: 2}[channel_mode]

        tt = 3 + channel_mode  # Total size of the package in bytes (tt variable depending on channel mode used)
        package = [tt, 0, ble_power, channel_mode_field] + channels
        self.__sendDataPacket(package)

    def stopRecording(self):
        print("SENDING STOP")
        package = [2, 1]  # Command to stop tt, 1 (tt=2)
        self.__sendDataPacket(package)

    def disconnect(self):
        if self._connected:
            self._request_deconnection = True
            self._m_BLE_Thread.join()
            loop = asyncio.new_event_loop()
            loop.run_until_complete(self.__disconnected_callback())
            self._request_deconnection = False

    # ----------End public methods----------

    # ----------Private methods----------

    def __sendDataPacket(self, p_data):
        self._packets_to_send.append(bytes(p_data))

    async def __scan(self):
        self._devices = []
        dev = await BleakScanner.discover()
        for i in range(0, len(dev)):
            self._devices.append(dev[i])

    # Callback function for received BLE data. Decodes the data package :
    #   - First byte: Channel ID (0–15)
    #   - 2nd and 3rd bytes: Number of lost bytes (uint16)
    #   - Remaining bytes: Channel data (2 bytes per sample)

    def __callback(self,sender, p_data):
        self.first_response = True
        if len(p_data) != 227:
            print(f"Invalid package size: {len(p_data)} bytes. Expected 227 bytes.")
            return

        # Decode the channel ID
        channel_id = p_data[0]

        # Decode the number of lost bytes (2nd and 3rd bytes as uint16)
        lost_bytes = struct.unpack('<H', p_data[1:3])[0]

        # Decode the data (remaining bytes, 2 bytes per sample)
        channel_data = []
        for i in range(3, len(p_data), 2):
            sample = struct.unpack('<h', p_data[i:i + 2])[0]
            channel_data.append(sample)

        # Print the decoded information
        # print(f"Channel: {channel_id}, Lost Bytes: {lost_bytes}, Data Samples: {channel_data}, Tpye: {type(channel_data)}")
        self.queue_raw.put((channel_id, channel_data))
        self.data_counter += 1

    # Function that disconnects the BLE device
    async def __disconnected_callback(self):
        if self._m_client != 0:
            try:
                await self._m_client.disconnect()
                print("Disconnected")
            except:
                pass

    # Function that verifies if the device with the correct name is within range ("p_name" in the constructer). DO NOT MODIFY
    def __connect_to_BLEbetween_callback(self):
        print("BLE device scan in progress... Please wait.")
        loop = asyncio.new_event_loop()

        retry_count = 5  # Number of attempts to retry
        retry_delay = 2  # Delay in seconds between retries
        device_not_found = 0

        while retry_count > 0:
            try:
                loop.run_until_complete(self.__scan())
            except bleak.exc.BleakError:
                print("A BLE Module needs to be connected to host module")
                print("Please Try Again ")
                quit()

            index = -1
            if len(self._devices) == 0:
                print('No BLE device detected')
            else:
                print("\r")
                for i in range(0, len(self._devices), 1):
                    if self.device_name == self._devices[i].name:
                        print(f"Device: {self.device_name} found!")
                        index = i
                        break

            if index >= 0:
                try:
                    loop.run_until_complete(self.__connect_to_BLE(self._devices[index].address, loop))
                    break  # Exit retry loop if successful
                except Exception as e:
                    print(f"Attempt failed: {e}. Retrying... ({retry_count} attempts left)")
                    retry_count -= 1
                    if retry_count > 0:
                        print(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                    else:
                        print("Unable to connect after several attempts.")
                        break
            else:
                if device_not_found == 0:
                    print("Unable to connect, device not found. Give it a sec ")

                if device_not_found == 1:
                    print("Unable to connect, device not found. Humm weird...  ")

                if device_not_found >= 2:
                    print("Unable to connect, device not found. Alright unplug and replug the device")

                retry_count -= 1  # Decrease retry count for the next attempt
                if retry_count > 0:
                    print(f"Retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)
                else:
                    print("Unable to connect after several attempts.")
                    break
                device_not_found += 1

        loop.close()


    # Function that connects to BLE devices and waits to transmit data. DO NOT MODIFY
    async def __connect_to_BLE(self, address, loop):

        async with BleakClient(address, loop=loop) as client:
            if (not client.is_connected):
                raise "client not connected"

            self._m_client = client
            services = client.services
            service_found = False
            for ser in services:
                if ser.description == 'Nordic UART Service':
                    print(f'Device is connected')
                    # print('Ready to receive commands')
                    service_found = True
                    await self._m_client.start_notify(self._tx_charac, self.__callback)
                    self._connected = True
                    while not (self._request_deconnection):
                        await asyncio.sleep(0.01)
                        #await self._m_client.stop_notify(self._tx_charac)
                        while len(self._packets_to_send) > 0:
                            await self._m_client.write_gatt_char(self._rx_charac, self._packets_to_send.pop(0))
                        #time.sleep(0.01)

                    self._connected = False
                    return
            if service_found == False:
                print('Wrong device, BLE service not found, please retry')


# ----------End private methods----------
if __name__ == "__main__":
    counter = 0
    SIMULATOR = True

    test = SpinalCordSystem_BLE("SpinalCordSystem")

    test.startBLE_Thread()

    while not test._connected:
        time.sleep(1)

    test.sendInitiationPacket() #SENDING THAT COMMAND TWICE ?? Doing it in startBLE_Thread() ... __connect_to_BLE()
                                # The other command was redundant
    while not test.first_response:
        counter += 1
    time.sleep(1)

    print(f"Number of data BEFORE stop : {test.data_counter}")

    test.stopRecording()

    test.disconnect()
    test.stopThread()
    print(f"Number of data AFTER stop : {test.data_counter}")








