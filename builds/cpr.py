#!/usr/bin/python3
import sys
import getopt
import os
import os.path
import struct
import time

class Page:
    #Single rom page
    def __init__(self, idx, data):
        self.idx   = idx
        self.data  = data
        self.size  = len(data)
        
class Cpr:
    #Initialise cpr
    def __init__(self, cprfile=""):
        self.__pages = []
        if cprfile=="":
            #new empty cpr
            raise Exception("empty cpr not supported")
        else:
            try:
                self.__readCpr(cprfile)
            except:
                raise

    #read file cpr
    def __readCpr(self, cprfile):
        try:
            cpr = open(cprfile, "rb")
        except:
            raise Exception("Cannot open "+cprfile)
            
        # Check we have a RIFF file
        riff = cpr.read(8)
        if riff[0:4] != b"RIFF":
            raise Exception(cprfile + "is not a RIFF file")
            
        riffLength = int.from_bytes(riff[4:8], byteorder='little')

        # Check we have a CPR RIFF file
        if cpr.read(4) != b"AMS!":
            raise Exception(cprfile + "is not a CPR file")

        riffLength -= 4;
     
        # Read chuncks
        while riffLength > 0 :
            chunkId = cpr.read(4).decode("ascii")
            chunkSz = int.from_bytes(cpr.read(4), byteorder='little')

            riffLength -= chunkSz + 8
            if chunkId[0:2] != "cb":
                # ignore
                cpr.read(chunkSz)
            else :
                chunkId = int(chunkId[2:4], base = 10)
                self.__pages.append(Page(chunkId, cpr.read(chunkSz)))

        cpr.close()
        
    def write(self, cprfile):
        try:
            cpr = open(cprfile, "wb")
        except:
            raise Exception("Cannot create "+cprfile)
            
        # Get overall file size
        #            AMS! + (cbxx + int32)   + payload
        rLen =  4   + self.pageCnt()*8 + self.size()

        # RIFF file header
        cpr.write(b"RIFF")
        # RIFF file size
        cpr.write(bytes([rLen & 255, int(rLen / 256) & 255, int(rLen/(256*256)) & 255, int(rLen/(256*256*256)) & 255]))
        
        # AMS! file header
        cpr.write(b"AMS!")
        
        for page in self.__pages:
            # chunk id
            cpr.write(b"cb")
            s = "%02d" % page.idx
            cpr.write(s.encode('ascii'))
            # chunk size
            l = len(page.data)
            cpr.write(   bytes([l & 255, int(l/256) & 255, int(l/(256*256)) & 255, int(l/(256*256*256)) & 255]))
            # chunk data
            cpr.write(page.data)

        cpr.close()

    #overall page size
    def size(self):
        size = 0
        for page in self.__pages:
            size += page.size
        return size

    #number of pages
    def pageCnt(self):
        return len(self.__pages)

    #remove page
    def delPage(self, pageid):
        for idx in pageid:
            for i in range(len(self.__pages)):
                if self.__pages[i].idx == idx :
                    self.__pages.pop(i)
                    break

    #get all pages
    def pages(self):
        for i in range(len(self.__pages)):
            yield self.__pages[i]
            
    
