import sys
import getopt
import os
import struct
import time
import serial

import cpr


cAck = b"Ok\r\n"
cLs  = b"ls\n"
cCd  = b"cd \n"
cBt  = b"BT\r\n"
cBr  = b"BR\r\n"
cWr  = b"WR\r\n"
cWb  = b"WB\r\n"
cGo  = b"GO\r\n"
cGb  = b"GB\r\n"

class C4Cpc:
    #Initialise C4CPC interface
    def __init__(self, comPort):
        try:
            self.__link     = serial.Serial(port = comPort, timeout = 1)
        except:
            sys.exit(1)

    #Send commmand and check for loopback
    def __Ok(self):
        rb = self.__link.readline()
        if  (rb != cAck):
            print(rb)
            raise IOError("C4CPC not ready")

    def __cmd(self, Command):
        self.__link.write(Command)
        rb = self.__link.readline()
        if (rb != Command):
            print(rb)
            raise IOError("C4CPC no echo")

    def takeBus(self):
        self.__cmd(cBt)
        self.__Ok()

    def releaseBus(self):
        self.__cmd(cBr)
        self.__Ok()

    def enableWarmBoot(self):
        self.__cmd(cWb)
        self.__Ok()

    def go(self):
        self.__cmd(cGo)
        self.__Ok()

    def busOwner(self):
        self.__cmd(cGb)
        bus = self.__link.read()
        self.__Ok()
        if bus == b"0":
            return 0
        else:
            return 1

    def dataWrite(self, addr, data):
        maxWriteByte = 250
        startIndex = 0
        dataCnt = len(data)
        targetAddr = addr

        while dataCnt :
            # Adjust nmber of byte to send on this command
            byteCnt = dataCnt
            if dataCnt > maxWriteByte:
                byteCnt = maxWriteByte
            
                
            # Convert args
            # one byte cnt
            byteCntBin = bytes([byteCnt & 255])
            # three byte address
            targetAddrBin = bytes([targetAddr & 255, int(targetAddr / 256) & 255, int(targetAddr/(256*256)) & 255])
            
            # Send Command
            self.__cmd(cWr)
            # Send byte count
            self.__link.write(  b"".join([byteCntBin,targetAddrBin,data[startIndex:startIndex+byteCnt]] ))

            #self.__link.write(byteCntBin)
            # Send address
            #self.__link.write(targetAddrBin)
            # Send payload
            #self.__link.write(data[startIndex:startIndex+byteCnt])
            # expect Ack
            self.__Ok()

            startIndex += byteCnt
            targetAddr += byteCnt
            dataCnt -=  byteCnt


