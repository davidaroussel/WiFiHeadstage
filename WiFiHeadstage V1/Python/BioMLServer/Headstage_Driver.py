import time
import math


class HeadstageDriver:
    def __init__(self):
        self.cutoff_menu = None

    def getMenu(self, socket):
        socket.sendall(b"0")
        print(socket.recv(1024).decode("cp1252"))

    def getHeadstageID(self, socket):
        command = b"1"
        socket.sendall(command)
        headstage_id = socket.recv(1024).decode("cp1252'")
        return headstage_id

    def verifyIntanChip(self, socket, p_id):
        command = b"2"
        socket.sendall(command)
        socket.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        intanResponse = socket.recv(8)
        return intanResponse

    def configureNumberChannel(self, socket, num_channels):
        command = b"3"
        time.sleep(1)
        print(f"Setting number of channels to : {num_channels}")
        b_num_channels = num_channels.to_bytes(1, byteorder='big')
        socket.sendall(command + b_num_channels)
        time.sleep(0.001)

    def configureSamplingFreq(self, socket, sample_freq):
        command = b"4"
        time.sleep(1)
        high_byte = (sample_freq >> 8) & 0xFF
        low_byte = sample_freq & 0xFF
        data1 = high_byte.to_bytes(1, 'big')
        data2 = low_byte.to_bytes(1, 'big')
        print(f"Setting sampling frequency to: {sample_freq}Hz")
        socket.sendall(command + data1 + data2)
        time.sleep(0.001)

    def configureIntanChip(self, socket):
        socket.sendall(b"5")
        try:
            recv_message = socket.recv(1024)
            self.cutoff_menu = recv_message.decode("utf-8")
        except UnicodeDecodeError:
            # Handle the decoding error here, for example:
            print("Error decoding received data")
            return
        print(self.cutoff_menu)

        input1 = "M"
        choice_lowfreq = self.findCutoffChoice(input1, "high")
        print("Low-pass selection:")
        print(choice_lowfreq)

        input2 = "0"
        choice_highfreq = self.findCutoffChoice(input2, "low")
        print("High-pass selection:")
        print(choice_highfreq)
        socket.sendall(b"" + bytes(input1, 'ascii') + bytes(input2, 'ascii'))

        # This version will call socket.recv as long as the buffer is not filled (was not necessary, seems to work with the 1ms sleep)


    def stopDataFromIntan(self, socket):
        socket.sendall(b"B")  # Stop Intan Timer
        time.sleep(0.1)
        socket.sendall(b"B")  # Stop Intan Timer
        # EMPTY SOCKET BUFFER
        trash_bufsize = 128
        packet = socket.recv(trash_bufsize)
        print("Closed Intan Sampling")

    def restartDevice(self, socket):
        socket.sendall(b"B")
        time.sleep(1.0)
        socket.sendall(b"B")

    def findCutoffChoice(self, input, cutoff):
        cutoff_value = None
        if cutoff == 'high':
            choice_index = self.cutoff_menu.find(input + '-')
            retline_index = self.cutoff_menu[choice_index:].find("\r\n") + choice_index
            choice_cutoff = self.cutoff_menu[choice_index:retline_index]
            midpoint = len(choice_cutoff) // 2
            cutoff_value = choice_cutoff[:midpoint].strip()
        elif cutoff == 'low':
            choice_index = self.cutoff_menu.rfind(input + '-')
            retline_index = self.cutoff_menu[choice_index:].find("\r\n") + choice_index
            cutoff_value = self.cutoff_menu[choice_index:retline_index]
        return cutoff_value

    def calculateSamplingLoops(self, samp_time, samp_freq, num_channels, buffer_size):
        BYTES_PER_CHANNEL = 2
        BYTES_PER_SEC = samp_freq * BYTES_PER_CHANNEL * num_channels
        TOTAL_NUMBER_OF_BYTES = BYTES_PER_SEC * samp_time
        # Number of times we want to receive data from the Headstage before plotting the results
        LOOPS = math.floor(TOTAL_NUMBER_OF_BYTES / buffer_size)
        REAL_SAMPLING_TIME = (LOOPS * buffer_size) / BYTES_PER_SEC
        print("Will sample for ", REAL_SAMPLING_TIME, "sec representing", LOOPS, " loops for a total of", TOTAL_NUMBER_OF_BYTES, " bytes")

        return LOOPS
