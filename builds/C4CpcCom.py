#!/usr/bin/python3
import sys
import glob
import getopt
import os
import struct
import time
import serial
from C4Cpc import C4Cpc
from cpr import Cpr

def serialPorts():
    """Lists serial ports

    :raises EnvironmentError:
        On unsupported or unknown platforms
    :returns:
        A list of available serial ports
    """
    if sys.platform.startswith('win'):
        ports = ['COM' + str(i + 1) for i in range(256)]

    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this is to exclude your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')

    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')

    else:
        raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result


def main(argv):


    inFile = ''
    port   = ''

    #Get options
    try:
        opts, args = getopt.getopt(argv,"hp:",["port="])
    except getopt.GetoptError:
        print('test.py -p port <cprfile|binfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -p port <cprfile|binfile>')
            sys.exit()
        elif opt in ("-p", "--port"):
            port = arg
  
    if len(args)<1:
        print('no file given')
        print(args)
        sys.exit(1)

    inFile = args[0]

    if inFile == '':
        print('no file to load')
        sys.exit(1)

    if port == '':
        # set default serial port
        if os.name == 'nt':
            port = "COM6"
        else:
            port = "/dev/ttyACM0"
        print(list(serialPorts()))

    print('Using port :', port)

    # Open inFile cpr
    workCpr = Cpr(inFile)
    print(inFile, 'is a', workCpr.size(), "bytes CPR", "with", workCpr.pageCnt(), "page(s)")
    
    # Open C4CPC
    C4CpcLink = C4Cpc(port)

    # Get bus owner
    BusOwner = C4CpcLink.busOwner()

    # Write Cpr to C4CPC
    uploadsz = workCpr.size()
    C4CpcLink.takeBus()

    start = time.perf_counter()
    for page in workCpr.pages():
        print(format(page.idx * 16384, '05X'), "-",format(page.idx * 16384+len(page.data)-1, '05X'))
        C4CpcLink.dataWrite(page.idx * 16384, page.data)

    print(format(uploadsz/(time.perf_counter() - start)/1024, '5.5'), "kB/s")
      
    # Release bus or Go according to BusOwner
    if BusOwner == 1:
        # AVR own the bus, CPC is waiting for CMD_GO, enable reboot
        C4CpcLink.enableWarmBoot()
        C4CpcLink.go()
    else:
        # CPC was running or OFF, just release the bus
        C4CpcLink.releaseBus()





if __name__ == "__main__":
   main(sys.argv[1:])
