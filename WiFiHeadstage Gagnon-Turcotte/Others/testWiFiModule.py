import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

#Coded by G. Gagnon-Turcotte at SiFiLabs
#Original version 6/22/2023

class WiFiServer(BaseException):

#Public
    
    #p_port: Port to listen on (non-privileged ports are > 1023)
    #p_host_addr: Standard loopback interface address (localhost)
    def __init__(self, p_port, p_host_addr = ""):
        BaseException.__init__(self)
        self.m_port = p_port
        self.m_conn = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.serverThread)
        self.dummy_buffer_for_test = []
        self.m_connected = False

    #Start the server to receive the data
    def startServer(self):
        self.m_serverThread.start()

    #Stop the server
    def stopServer(self):
        if self.m_thread_socket:
            self.m_thread_socket.shutdown(socket.SHUT_RDWR)
            self.m_serverThread.join()

#End public

#Private

    def readMenu(self):
        self.m_conn.sendall(b"0")
        print(self.m_conn.recv(1024).decode("cp1252'"))

    def configureIntanChip(self):
        self.m_conn.sendall(b"A")
        print(self.m_conn.recv(1024).decode("utf-8"))
        print("Low-pass selection:")
        input1 = input()
        print("High-pass selection:")
        input2 = input()
        self.m_conn.sendall(b""+bytes(input1, 'ascii')+bytes(input2, 'ascii'))

    def receiveDataTest(self):
        command = b"B"
        channels = [0, 1, 2, 3, 32, 33, 46, 47]
        for ch in channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_conn.sendall(command)#Start Intan Timer
        time.sleep(1)
        
        data = self.m_conn.recv(512*30)
        k = []
        converted_array = []
        j = 0
        for i in range(0, len(data), 16):
            k.append(j)
            j = j + 1
            converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed = True)
            converted_array.append(converted_data*0.000000195)
        

        self.m_conn.sendall(b"C")#Stop Intan Timer
        time.sleep(0.1)

        plt.gca().cla()
        plt.plot(k, converted_array)
        plt.show()

        bufsize = 4096
        while True:
            packet = self.m_conn.recv(bufsize)
            if len(packet) < bufsize:
                break
        
        
    def serverThread(self):
        print("IN THREAD")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((self.m_host_addr, self.m_port))
            s.listen()
            conn, addr = s.accept()
            self.m_conn = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True

    def getID(self, p_id):
        self.m_conn.sendall(b"9")
        self.m_conn.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        print(self.m_conn.recv(8))

#end private

#How to use, simply reimplement the functions
#Example

if __name__ == "__main__":
    tmp = WiFiServer(5000, p_host_addr="192.168.1.132") #Port 5000, localhost
    tmp.startServer()

    while not(tmp.m_connected):
        time.sleep(1)

    # tmp.getID(0)
    # tmp.getID(1)
    # tmp.getID(2)
    tmp.receiveDataTest()




