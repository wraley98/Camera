"""
Flight Test
William Raley
29 Jan 24

Test for location of flying crazyflie.
"""

# Python imports
import logging
import sys
import time
from threading import Event
import numpy as np
#import matlab.engine



# Crazyflie imports
import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.positioning.position_hl_commander import PositionHlCommander
from cflib.utils import uri_helper
from cflib.crazyflie.syncLogger import SyncLogger


URI = uri_helper.uri_from_env(default='radio://0/80/2M/E7E7E7E702')
deck_atttached_event = Event()

logging.basicConfig(level=logging.ERROR)

# Storage for location data

timeStampList = []
xLocation = []
yLocation = []
zLocation = []

firstPass = True
tInitial = 0

position_estimate = [0 , 0 , 0]

# Creates log
def createLog(scf):
        # prepares log data
        logconf = LogConfig(name = 'Position', period_in_ms=32)
       
        logconf.add_variable('kalman.stateX' , 'float')
        logconf.add_variable('kalman.stateY' , 'float')
        logconf.add_variable('kalman.stateZ' , 'float')
        """
        logconf.add_variable('stateEstimate.x' , 'float')
        logconf.add_variable('stateEstimate.y' , 'float')
        logconf.add_variable('stateEstimate.z' , 'float')
        """
        scf.cf.log.add_config(logconf)
        # prints position data
        logconf.data_received_cb.add_callback(log_pos_callback)
        #logconf.data_received_cb.add_callback(log_stab_callback)
        # logs position data for graphing
        #logconf.data_received_cb.add_callback(log_stab_callback)

        return logconf

# Sets the current position
def setPos(logConf , scf):
     print("Setting Position")
     # Starts the log
     logConf.start()
     time.sleep(0.1)
     logConf.stop()
     logConf.delete()
    
     return createLog(scf)

def hold(pc , logConf , speed):
     # Sets Position
    pc._x = position_estimate[0]
    pc._y = position_estimate[1]
    pc._z = position_estimate[2]
    
    x = pc._x
    y = pc._y
    z = pc._z

    # Sets flying status to off
    pc._is_flying = False

    # Take Off
    print("Taking Off")
    #pc.take_off(height=1.0 , velocity = speed)
    pc.go_to(x , y , z + .2  , velocity = 0.1)
    time.sleep(2)
    pc.up( .2 , velocity = 0.1)
    time.sleep(2)
    pc.go_to(x  , y + .7 , z  , velocity = 0.1)
    time.sleep(2)
    pc._is_flying = True
    pc.land(velocity = 0.1)

# Sets location to current estimate
def log_pos_callback(timestamp, data, logconf):
    
    if firstPass:
         tInitial = timestamp
         firstPass = False
   
    position_estimate[0] = data['kalman.stateX']
    position_estimate[1] = data['kalman.stateY']
    position_estimate[2] = data['kalman.stateZ']
    """
    position_estimate[0] = data['stateEstimate.x']
    position_estimate[1] = data['stateEstimate.y']
    position_estimate[2] = data['stateEstimate.z']
    """

    #print(f"{timestamp} {position_estimate[0]} {position_estimate[1]} {position_estimate[2]} ")

    timeStampList.append(timestamp - tInitial)
    xLocation.append(position_estimate[0])
    yLocation.append(position_estimate[1])
    zLocation.append(position_estimate[2])   



# Checks to ensure deck is attached
def param_deck_flow(_, value_str):
    value = int(value_str)
    print(value)
    if value:
        deck_atttached_event.set()
        print('Deck is attached!')
    else:
         print('Deck is NOT attached!')


# Driver block of code
if __name__ == '__main__':
    
    cflib.crtp.init_drivers()
    
    with SyncCrazyflie(URI, cf=Crazyflie(rw_cache='./cache')) as scf:
    
        # print("Starting up")
        # checks to see if deck is attached 
        scf.cf.param.add_update_callback(group='deck', name='bcLoco', cb=param_deck_flow)
        
        time.sleep(1)
        
        firstPass = True
        
        # creates log for determining position
        logConf = createLog(scf)        
        
        # if deck is not attached, run will fail 
        if not deck_atttached_event.wait(timeout=5):
            print('No Flow deck detected!')
            sys.exit(1)
        
        # sets controller and estimator
        scf.cf.param.set_value('stabilizer.controller' , '0')
        scf.cf.param.set_value('stabilizer.estimator' , '3')
        
        # Sets speed
        speed = 0.1
        logConf = setPos(logConf , scf)
        print(position_estimate)
        logConf.start()
        
        with PositionHlCommander(scf) as pc:
            hold(pc , logConf , speed)
        
        # Stop Logging Data
        logConf.stop()
        
        returnLog = np.array([np.array(timeStampList) , np.array(xLocation) , np.array(yLocation) ,np.array(zLocation)])
    
    

        
    
    
    

