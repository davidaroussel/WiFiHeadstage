# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/04/2023


import time
from threading import Thread

class Toolkit():
    def __init__(self, data_queue):
        self.data_queue = data_queue
        self.toolkit_Flag = False
        self.toolkit_Thread = Thread(target=self.fillDataQueue, args=(self.data_queue,))

    def startThread(self):
        self.toolkit_Thread.start()

    # Stop the server
    def stopThread(self):
        if self.toolkit_Flag:
            self.toolkit_Thread.join()

    def fillDataQueue(self, q_queue):
        while True:
            item = q_queue.get()
            # check for stop
            if item is None:
                break
            print("FROM INPUT  ", item)
            time.sleep(1)