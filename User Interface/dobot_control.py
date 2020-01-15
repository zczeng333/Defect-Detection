import threading
import dobot_dll_type as dType

def MoveRight():
    CON_STR = {
        dType.DobotConnect.DobotConnect_NoError:  "DobotConnect_NoError",
        dType.DobotConnect.DobotConnect_NotFound: "DobotConnect_NotFound",
        dType.DobotConnect.DobotConnect_Occupied: "DobotConnect_Occupied"}

    #Load Dll
    api = dType.load()

    #Connect Dobot
    state = dType.ConnectDobot(api, "COM3", 115200)[0]
    print("Connect status:",CON_STR[state])

    if (state == dType.DobotConnect.DobotConnect_NoError):

        #Clean Command Queued
        dType.SetQueuedCmdClear(api)

        #Async Motion Params Setting
        dType.SetHOMEParams(api, 250, 0, 50, 0, isQueued = 1)
        dType.SetPTPJointParams(api, 200, 200, 200, 200, 200, 200, 200, 200, isQueued = 1)
        dType.SetPTPCommonParams(api, 100, 100, isQueued = 1)

        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 130, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, -48, 0, isQueued=1)[0]
        dType.SetQueuedCmdStartExec(api)
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(10)
        suction_return = dType.SetEndEffectorSuctionCup(api, 1, 1)
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 200, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 200, -48, 0, isQueued=1)[0]
        dType.SetQueuedCmdStartExec(api)
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(10)
        dType.dSleep(200)
        suction_return = dType.SetEndEffectorSuctionCup(api, 1, 0)
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 200, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 200, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 130, 0, 0, 0, isQueued=1)[0]

        #Start to Execute Command Queued
        dType.SetQueuedCmdStartExec(api)

        #Wait for Executing Last Command
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(100)

        #Stop to Execute Command Queued
        dType.SetQueuedCmdStopExec(api)

    #Disconnect Dobot
    dType.DisconnectDobot(api)

def MoveLeft():
    CON_STR = {
        dType.DobotConnect.DobotConnect_NoError: "DobotConnect_NoError",
        dType.DobotConnect.DobotConnect_NotFound: "DobotConnect_NotFound",
        dType.DobotConnect.DobotConnect_Occupied: "DobotConnect_Occupied"}

    # Load Dll
    api = dType.load()

    # Connect Dobot
    state = dType.ConnectDobot(api, "COM3", 115200)[0]
    print("Connect status:", CON_STR[state])

    if (state == dType.DobotConnect.DobotConnect_NoError):

        # Clean Command Queued
        dType.SetQueuedCmdClear(api)

        # Async Motion Params Setting
        dType.SetHOMEParams(api, 250, 0, 50, 0, isQueued=1)
        dType.SetPTPJointParams(api, 200, 200, 200, 200, 200, 200, 200, 200, isQueued=1)
        dType.SetPTPCommonParams(api, 100, 100, isQueued=1)

        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 130, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, -48, 0, isQueued=1)[0]
        dType.SetQueuedCmdStartExec(api)
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(10)
        suction_return = dType.SetEndEffectorSuctionCup(api, 1, 1)
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 250, 0, 0, 0, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 55, -235, 0, 25, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 55, -235, -48, 25, isQueued=1)[0]
        dType.SetQueuedCmdStartExec(api)
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(10)
        dType.dSleep(200)
        suction_return = dType.SetEndEffectorSuctionCup(api, 1, 0)
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 55, -235, 0, 25, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 55, -235, 0, 25, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 210, -55, 0, 35, isQueued=1)[0]
        lastIndex = dType.SetPTPCmd(api, dType.PTPMode.PTPMOVLXYZMode, 130, 0, 0, 0, isQueued=1)[0]

        # Start to Execute Command Queued
        dType.SetQueuedCmdStartExec(api)

        # Wait for Executing Last Command
        while lastIndex > dType.GetQueuedCmdCurrentIndex(api)[0]:
            dType.dSleep(100)

        # Stop to Execute Command Queued
        dType.SetQueuedCmdStopExec(api)

    # Disconnect Dobot
    dType.DisconnectDobot(api)
