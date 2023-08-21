* @ValidationCode : MjotNTgwNjM4MjY0OlVURi04OjE2OTI2MDYwOTg4NzE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Aug 2023 13:51:38
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TESTAPAP
*------------------------------------------------------------------------------
PROGRAM TAFC.MENU.ACCESS.OPERATIONS
*------------------------------------------------------------------------------
* Description: This program is used by operators to access the menu from backend.
*      It mainly aims to restrict the user from jshell and execute programs from menu.
*
*  jcompile -v -I../../GLOBUS.BP TAFC.MENU.ACCESS.OPERATIONS.b sig_test1.c
*  mv TAFC.MENU.ACCESS.OPERATIONS ../apapbin/
*  mv TAFC.MENU.ACCESS.OPERATIONS.so ../apapbin/
*  mv TAFC.MENU.ACCESS.OPERATIONS.so.el ../apapbin/
*
*  Normal Compilation without signl handling i.e. sig_test1.c
*  BASIC -v <LOCAL.BP> TAFC.MENU.ACCESS.OPERATIONS.b
*  CATALOG -v <LOCAL.BP> TAFC.MENU.ACCESS.OPERATIONS.b
*
*jcompile -v -I../../GLOBUS.BP -c TAFC.MENU.ACCESS.OPERATIONS.b sig_test.c
*cc  -g0 -Ae +Z -mt +u4 +W612 +DD64 -D_LARGEFILE_SOURCE +W4232 -c  -I/T24/areas/tafc.r09SP25.qa5mock1/include -I/opt/java6/include -I/opt/java6/include/hp-ux -DJBC_OPTLEVEL2 -I../../GLOBUS.BP sig_test.c
*
*cc  -Ae +Z -mt +u4 +W612 +DD64 -D_LARGEFILE_SOURCE +W4232 TAFC.MENU.ACCESS.OPERATIONS.o sig_test.o /T24/areas/tafc.r09SP25.qa5mock1/bin/jmainfunction.o -L/T24/areas/tafc.r09SP25.qa5mock1/lib -lTAFCfrmwrk -lTAFCutil -lTAFCjee  -lpthread -lcurses -lstd_v2 -lCsup -lunwind -lm  -oTAFC.MENU.ACCESS.OPERATIONS
*cc  -g0 -Ae +Z -mt +u4 +W612 +DD64 -D_LARGEFILE_SOURCE +W4232 TAFC.MENU.ACCESS.OPERATIONS.o sig_test.o /T24/areas/tafc.r09SP25.qa5mock1/bin/jmainfunction.o -L/T24/areas/tafc.r09SP25.qa5mock1/lib -lTAFCfrmwrk -lTAFCutil -lTAFCjee  -lpthread -lcurses -lstd_v2 -lCsup -lunwind -lm  -oTAFC.MENU.ACCESS.OPERATIONS
*
*
*------------------------------------------------------------------------------
* Modification History :
*  DATE               NAME                       REFERENCE                           DESCRIPTION
* 21 AUG 2023    Narmadha V                    Manual R22 Conversion                  No Changes
*-----------------------------------------------------------------------------
*    DEFC jshansighandler()

*    jshansighandler()
    EXECUTE 'BREAK-KEY-OFF'

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TAFC.MENU.ACCESS
    $INSERT JBC.h

    EQU jedlogger.routine.name TO 1, jedlogger.record.key TO 2,
    jedlogger.dateandtime      TO 3, jedlogger.datapart   TO 4,
    jedlogger.loginid          TO 5, jedlogger.ipaddress  TO 6,
    jedlogger.hostname         TO 7, jedlogger.terminal   TO 8,
    jedlogger.environment      TO 9


*------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB MAIN.MENU.DISPLAY

RETURN

*------------------------------------------------------------------------------
INITIALISE:
*----------

* PHNO=1 ; CALL OVERLAY.EX ; CALL S.INITIALISE.COMMON

    REC.NO = 0      ;* first call - initialise the var
    MYREQUEST = '' ; MYRESPONSE = '' ; REQCOM = ''

    CALL T24.INITIALISE

    FN.VOC = 'VOC'
    F.VOC = ''
    OPEN FN.VOC TO F.VOC ELSE CRT 'Unable to Open VOC' ; STOP


    FN.OFS.SOURCE = "F.OFS.SOURCE"
    F.OFS.SOURCE = ""
    CALL OPF(FN.OFS.SOURCE,F.OFS.SOURCE)

    FN.TAFC.MENU = 'F.TAFC.MENU.ACCESS'
    F.TAFC.MENU = ''
    CALL OPF(FN.TAFC.MENU, F.TAFC.MENU)

    OPEN 'F.TAFC.AUDIT.LOG' TO F.TAFC.AUDIT.LOG ELSE
        CRT 'Unable to open F.TAFC.AUDIT.LOG'
        STOP
    END


    GOSUB GET.USER.PASS

*    PRINT 'Enter T24 user Company : ':
*    INPUT T24COMP
*    IF NOT(T24COMP) THEN
*        T24COMP = 'DO0010001'
*    END

*    service_request = 'TSA.SERVICE,/I/PROCESS,':T24USER:'/':T24PASS:'/:'T24COMP:',SVC.ID,SERVICE.CONTROL:1:1='
*    check_request = 'TSA.SERVICE,/S/PROCESS,':T24USER:'/':T24PASS:'/':T24COMP:','
*    phantom_start_request = 'EB.PHANTOM,/V/PROCESS,':T24USER:'/':T24PASS:'/':T24COMP:',SVC.ID'
*    phantom_stop_request = 'EB.PHANTOM,/I/PROCESS,':T24USER:'/':T24PASS:'/':T24COMP:',SVC.ID,PHANT.STOP.REQ:1:1=STOP'

* General_Request = 'APPLICATION,VERSION/FUNCTION/PROCESS,T24USER/T24PASS,APPL.ID,APPL.FLD=APPL.FLD.VAL'
    General_Request = 'APPLICATION,VERSION/FUNCTION/PROCESS,':T24USER:'/':T24PASS:',APPL.ID,APPL.FLDS'

*    service_request = 'TSA.SERVICE,T24OPERATOR/I/PROCESS,':T24USER:'/':T24PASS:',SVC.ID,SERVICE.CONTROL:1:1='
*    check_request = 'TSA.SERVICE,/S/PROCESS,':T24USER:'/':T24PASS:','
*    phantom_start_request = 'EB.PHANTOM,/V/PROCESS,':T24USER:'/':T24PASS:',SVC.ID'
*    phantom_stop_request = 'EB.PHANTOM,/I/PROCESS,':T24USER:'/':T24PASS:',SVC.ID,PHANT.STOP.REQ:1:1=STOP'

*    CRT SYSTEM(19)
*    CRT SYSTEM(50)
*    CRT SYSTEM(1015)
*    CRT SYSTEM(1020)

*    LogName = SYSTEM(1020)
    LogName = SYSTEM(1020)
    ActLogName = SYSTEM(1020)
    EXECUTE 'logname' CAPTURING ActLogName

    IF ActLogName NE LogName THEN
        ActLogName := '->':LogName
    END
    HostName = SYSTEM(52)

    EXECUTE "who am i -u" CAPTURING WHO.CAP
    CHANGE CHAR(9) TO " " IN WHO.CAP
    IpAddress = WHO.CAP[" ", DCOUNT(WHO.CAP, " "), 1]

    PortNo = SYSTEM(18)
    Pid = JBASEGetPidFromPort(SYSTEM(18))

    Tty     = @TTY  ;* /dev/pts/xx or CONxx$
    IF Tty[1] = "$" THEN
        Tty = Tty[1,LEN(Tty)-1]         ;* Remove $ incase of CONxx$
    END

    GOSUB CHECK.USER

    MENU.LEVEL = 1 ; CONSOLIDATED.MENU = ''
    CHECK.CONTINUE = 1

RETURN

*------------------------------------------------------------------------------
GET.USER.PASS:
*-------------

    T24USER = ''
*    PRINT 'Enter T24 User name : ':
*    INPUT T24USER
    LOOP
    WHILE T24USER EQ ''
        PRINT 'Enter T24 User name : ':
        INPUT T24USER
        PRINT ''
    REPEAT

    LOOP
    WHILE T24PASS EQ ''
        PRINT 'Enter T24 user Password : ':
        HUSH 1
        INPUT T24PASS
        HUSH 0
        PRINT ''
    REPEAT

RETURN

*------------------------------------------------------------------------------
CHECK.USER:
*----------

    RESP.VAL = 0
    LOOP
    WHILE RESP.VAL NE '1'

        ORG.SVC.ID = 'TSM'
        MYREQUEST = 'TSA.SERVICE,/S/PROCESS,':T24USER:'/':T24PASS:',':ORG.SVC.ID

        GOSUB CALL.OBM
        IF RESP.VAL NE '1' THEN
            T24USER = '' ; T24PASS = ''
            GOSUB GET.USER.PASS
*            service_request = 'TSA.SERVICE,T24OPERATOR/I/PROCESS,':T24USER:'/':T24PASS:',SVC.ID,SERVICE.CONTROL:1:1='
*            check_request = 'TSA.SERVICE,/S/PROCESS,':T24USER:'/':T24PASS:','
*            phantom_start_request = 'EB.PHANTOM,/V/PROCESS,':T24USER:'/':T24PASS:',SVC.ID'
*            phantom_stop_request = 'EB.PHANTOM,/I/PROCESS,':T24USER:'/':T24PASS:',SVC.ID,PHANT.STOP.REQ:1:1=STOP'
            General_Request = 'APPLICATION,VERSION/FUNCTION/PROCESS,':T24USER:'/':T24PASS:',APPL.ID,APPL.FLDS'
        END
    REPEAT

RETURN

*------------------------------------------------------------------------------
MAIN.MENU.DISPLAY:
*-----------------

* MENU.ID = UPCASE(LogName)
    MENU.ID = LogName
    CALL F.READ(FN.TAFC.MENU, MENU.ID, R.MAIN.MENU, F.TAFC.MENU, MENU.ERR)

    IF MENU.ERR THEN
        CALL F.READ(FN.TAFC.MENU, T24USER, R.MAIN.MENU, F.TAFC.MENU, MENU.ERR)
        IF MENU.ERR THEN RETURN
    END

* IF R.MAIN.MENU<EB.TMA.SUB.MENU> EQ '' THEN
*  SUBMENU.CNT = 0
* END ELSE
*  SUBMENU.CNT = DCOUNT(R.MAIN.MENU<EB.TMA.SUB.MENU>, @VM)
* END
*
* IF R.MAIN.MENU<EB.TMA.CASE.DESC> EQ '' THEN
*  SUB.CMD.CNT = 0
* END ELSE
*  SUBCMD.CNT = DCOUNT(R.MAIN.MENU<EB.TMA.CASE.DESC>, @VM)
* END
*
* SUBTOT.CNT = SUBMENU.CNT + SUBCMD.CNT
*
* MENU.DESC.DISP = R.MAIN.MENU<EB.TMA.MENU.DESCRIPTION>
* MENU.SUB.CNT = SUBMENU.CNT
* MENU.CMD.CNT = SUBCMD.CNT
* MENU.DISP.CNT = MENU.SUB.CNT + MENU.CMD.CNT
*
* BEGIN CASE
* CASE R.MAIN.MENU<EB.TMA.SUB.MENU> EQ '' AND R.MAIN.MENU<EB.TMA.CASE.DESC> EQ ''
*  MENU.DISP = ''
* CASE R.MAIN.MENU<EB.TMA.SUB.MENU> NE '' AND R.MAIN.MENU<EB.TMA.CASE.DESC> EQ ''
*  MENU.DISP = RAISE(R.MAIN.MENU<EB.TMA.SUB.MENU>)
* CASE R.MAIN.MENU<EB.TMA.SUB.MENU> EQ '' AND R.MAIN.MENU<EB.TMA.CASE.DESC> NE ''
*  MENU.DISP = RAISE(R.MAIN.MENU<EB.TMA.CASE.DESC>)
* CASE R.MAIN.MENU<EB.TMA.SUB.MENU> NE '' AND R.MAIN.MENU<EB.TMA.CASE.DESC> NE ''
*  MENU.DISP = RAISE(R.MAIN.MENU<EB.TMA.SUB.MENU>):@FM:RAISE(R.MAIN.MENU<EB.TMA.CASE.DESC>)
* END CASE
*
* ACT.MENU.PROC = R.MAIN.MENU

    R.ACT.MENU = R.MAIN.MENU
    GOSUB SET.MENU.DISPAY.VARS


    GOSUB DISPLAY.MENU

RETURN

*------------------------------------------------------------------------------
DISPLAY.MENU:
*------------

    LOOP.FLAG = 'Y'
    LOOP
    WHILE LOOP.FLAG EQ 'Y'

*  MENU.DESC.DISP = MENU.DESC.DISP[1, 35]
*  MENU.DESC.DISP.LEN = LEN(MENU.DESC.DISP)
        PRINT @(-1)
        PRINT '************************************************************************'
        PRINT '*                    ':FMT(MENU.DESC.DISP,"L#35"):'               *'
        PRINT '*                                                                      *'
        FOR MENU.CNT = 1 TO MENU.DISP.CNT
            MENU.DISP.VAR = MENU.DISP<MENU.CNT>[1, 35]
            MENU.DISP.LEN = LEN(MENU.DISP.VAR)
            IF MENU.DISP.LEN LT 36 THEN
                MENU.DISP.REST = 35 - MENU.DISP.LEN
            END ELSE
                MENU.DISP.REST = 0
            END

            IF MENU.CNT LT 10 THEN
*    PRINT '*       ':MENU.CNT:'. ':FMT(MENU.DISP<MENU.CNT>,"L#35"):FMT("*","R#26")
                PRINT '*       ':MENU.CNT:'. ':MENU.DISP.VAR:FMT(" ", "R#":MENU.DISP.REST):FMT("*","R#26")
            END ELSE
*    PRINT '*       ':MENU.CNT:'. ':FMT(MENU.DISP<MENU.CNT>,"L35"):FMT("*'","L25")
                PRINT '*       ':MENU.CNT:'. ':MENU.DISP.VAR:FMT(" ", "R#":MENU.DISP.REST):FMT("*","R#25")
            END
        NEXT MENU.CNT

        PRINT '*                                                                      *'
        PRINT '*        Q. Quit                                                       *'
        PRINT '*                                                                      *'
        PRINT '*        Enter Choice :                                                *'
        PRINT '************************************************************************'
        INPUT USER.CHOICE

        USER.CHOICE = TRIM(USER.CHOICE," ","B")

        IF USER.CHOICE NE '' AND (ISDIGIT(USER.CHOICE) OR UPCASE(USER.CHOICE) EQ 'Q')  THEN
            BEGIN CASE
                CASE USER.CHOICE LE MENU.SUB.CNT
                    MENU.ID = ACT.MENU.PROC<EB.TMA.SUB.MENU, USER.CHOICE>
                    CONSOLIDATED.MENU<MENU.LEVEL> = LOWER(LOWER(LOWER(ACT.MENU.PROC))):@VM:MENU.DESC.DISP:':':MENU.DISP.CNT:':':MENU.SUB.CNT:':':MENU.CMD.CNT:@VM:LOWER(LOWER(LOWER(MENU.DISP)))
                    GOSUB READ.MENU
                    GOSUB DISPLAY.MENU
                    LOOP.FLAG = 'Y'
                CASE USER.CHOICE GT MENU.SUB.CNT AND USER.CHOICE LE MENU.DISP.CNT
                    GOSUB PROCESS.MENU
                CASE UPCASE(USER.CHOICE) EQ 'Q'
                    LOOP.FLAG = 'N'
                    IF MENU.LEVEL GT 1 THEN
                        GOSUB REVERT.MENU
                    END
                CASE OTHERWISE
                    PRINT 'Please enter the correct option : Press enter to continue ': ; INPUT CONT.VAL
            END CASE
        END

    REPEAT

RETURN

*------------------------------------------------------------------------------
READ.MENU:
*---------

    CALL F.READ(FN.TAFC.MENU, MENU.ID, R.SUB.MENU, F.TAFC.MENU, MENU.ERR)

    IF R.SUB.MENU THEN
        R.ACT.MENU = R.SUB.MENU
        GOSUB SET.MENU.DISPAY.VARS

* MENU.DESC.DISP = R.SUB.MENU<EB.TMA.MENU.DESCRIPTION>
* IF NOT(R.SUB.MENU<EB.TMA.SUB.MENU>) THEN
* MENU.SUB.CNT = DCOUNT(R.SUB.MENU<EB.TMA.SUB.MENU>, @VM)
* MENU.CMD.CNT = DCOUNT(R.SUB.MENU<EB.TMA.CASE.DESC>, @VM)
* MENU.DISP.CNT = MENU.SUB.CNT + MENU.CMD.CNT
* MENU.DISP = RAISE(R.SUB.MENU<EB.TMA.SUB.MENU>):@FM:RAISE(R.SUB.MENU<EB.TMA.CASE.DESC>)
* ACT.MENU.PROC = R.SUB.MENU

        MENU.LEVEL += 1
    END

RETURN

*------------------------------------------------------------------------------
REVERT.MENU:
*-----------

    DEL CONSOLIDATED.MENU<MENU.LEVEL>
    MENU.LEVEL -= 1

    MENU.DESC.DISP = CONSOLIDATED.MENU<MENU.LEVEL, 2>[':', 1, 1]
    MENU.SUB.CNT = CONSOLIDATED.MENU<MENU.LEVEL, 2>[':', 3, 1]
    MENU.CMD.CNT = CONSOLIDATED.MENU<MENU.LEVEL, 2>[':', 4, 1]
    MENU.DISP.CNT = CONSOLIDATED.MENU<MENU.LEVEL, 2>[':', 2, 1]
    MENU.DISP = RAISE(RAISE(RAISE(CONSOLIDATED.MENU<MENU.LEVEL, 3>)))
    ACT.MENU.PROC = RAISE(RAISE(RAISE(CONSOLIDATED.MENU<MENU.LEVEL,1>)))

RETURN

*------------------------------------------------------------------------------
SET.MENU.DISPAY.VARS:
*--------------------

    IF R.ACT.MENU<EB.TMA.SUB.MENU> EQ '' THEN
        SUBMENU.CNT = 0
    END ELSE
        SUBMENU.CNT = DCOUNT(R.ACT.MENU<EB.TMA.SUB.MENU>, @VM)
    END

    IF R.ACT.MENU<EB.TMA.CASE.DESC> EQ '' THEN
        SUB.CMD.CNT = 0
    END ELSE
        SUBCMD.CNT = DCOUNT(R.ACT.MENU<EB.TMA.CASE.DESC>, @VM)
    END

    SUBTOT.CNT = SUBMENU.CNT + SUBCMD.CNT

    MENU.DESC.DISP = R.ACT.MENU<EB.TMA.MENU.DESCRIPTION>
    MENU.SUB.CNT = SUBMENU.CNT
    MENU.CMD.CNT = SUBCMD.CNT
    MENU.DISP.CNT = MENU.SUB.CNT + MENU.CMD.CNT

    BEGIN CASE
        CASE R.ACT.MENU<EB.TMA.SUB.MENU> EQ '' AND R.ACT.MENU<EB.TMA.CASE.DESC> EQ ''
            MENU.DISP = ''
        CASE R.ACT.MENU<EB.TMA.SUB.MENU> NE '' AND R.ACT.MENU<EB.TMA.CASE.DESC> EQ ''
            MENU.DISP = RAISE(R.ACT.MENU<EB.TMA.SUB.MENU>)
        CASE R.ACT.MENU<EB.TMA.SUB.MENU> EQ '' AND R.ACT.MENU<EB.TMA.CASE.DESC> NE ''
            MENU.DISP = RAISE(R.ACT.MENU<EB.TMA.CASE.DESC>)
        CASE R.ACT.MENU<EB.TMA.SUB.MENU> NE '' AND R.ACT.MENU<EB.TMA.CASE.DESC> NE ''
            MENU.DISP = RAISE(R.ACT.MENU<EB.TMA.SUB.MENU>):@FM:RAISE(R.ACT.MENU<EB.TMA.CASE.DESC>)
    END CASE

    ACT.MENU.PROC = R.ACT.MENU

RETURN

*------------------------------------------------------------------------------
PROCESS.MENU:
*------------

    ACT.CMD.CNT = USER.CHOICE - MENU.SUB.CNT

    MENU.APPL.VERSION = TRIM(ACT.MENU.PROC<EB.TMA.APPL.VERSION, ACT.CMD.CNT>, " ", "B")
    MENU.CALL.ROUT = TRIM(ACT.MENU.PROC<EB.TMA.CALL.ROUT, ACT.CMD.CNT>, " ", "B")
    MENU.JSH.CMD = TRIM(ACT.MENU.PROC<EB.TMA.EXEC.JSH.CMD, ACT.CMD.CNT>, " ", "B")
    MENU.SH.CMD = TRIM(ACT.MENU.PROC<EB.TMA.EXEC.SH.CMD, ACT.CMD.CNT>, " ", "B")

    BEGIN CASE

        CASE MENU.APPL.VERSION NE ''
            GOSUB APPL.PROCESS
        CASE MENU.CALL.ROUT NE ''
            GOSUB CALL.ROUTINE
        CASE MENU.JSH.CMD NE ''
            IF MENU.JSH.CMD NE 'RUNTIME' THEN
                JSH.CMD = MENU.JSH.CMD
            END ELSE
                PRINT 'Enter the command to execute : ': ;INPUT JSH.CMD
                JSH.CMD = TRIM(JSH.CMD, " ", "B")
            END
            IF JSH.CMD THEN
                GOSUB CHECK.JSH.CMD
            END

        CASE MENU.SH.CMD NE ''
            IF MENU.SH.CMD NE 'RUNTIME' THEN
                JSH.CMD = MENU.SH.CMD
            END ELSE
                PRINT 'Enter the command to execute : ': ;INPUT JSH.CMD
                JSH.CMD = TRIM(JSH.CMD, " ", "B")
            END
            IF JSH.CMD THEN
                GOSUB CHECK.SH.CMD
            END

    END CASE

RETURN

*------------------------------------------------------------------------------
APPL.PROCESS:

    PROC.APPL.VERSION = MENU.APPL.VERSION

    IF INDEX(PROC.APPL.VERSION, ',' ,1) THEN
        PROC.APPL = PROC.APPL.VERSION[',', 1, 1]
        PROC.VERSION = PROC.APPL.VERSION[',', 2, 1]
    END ELSE
        PROC.APPL = PROC.APPL.VERSION
        PROC.VERSION = ''
    END

    FN.PROC.APPL = 'F.':PROC.APPL
    F.PROC.APPL = ''
    CALL OPF(FN.PROC.APPL, F.PROC.APPL)

    PROC.FUNCTION = TRIM(ACT.MENU.PROC<EB.TMA.FUNCTION, ACT.CMD.CNT>, " ", "B")
    PROC.APPL.ID = TRIM(ACT.MENU.PROC<EB.TMA.APPL.ID, ACT.CMD.CNT>, " ", "B")

    ORG.SVC.ID = PROC.APPL.ID

    CHANGE '/' TO '^' IN PROC.APPL.ID
    CHANGE ',' TO '?' IN PROC.APPL.ID

    PROC.APPL.FLD.MUL = ACT.MENU.PROC<EB.TMA.APPL.FLD, ACT.CMD.CNT>
    PROC.APPL.FLD.VAL.MUL = ACT.MENU.PROC<EB.TMA.APPL.FLD.VAL, ACT.CMD.CNT>
    PROC.APPL.FLD.CNT = DCOUNT(PROC.APPL.FLD.MUL, @SM)
    PROC.APPL.FLDS = ''

    FOR PROC.APPL.FLD.I = 1 TO PROC.APPL.FLD.CNT
        IF PROC.APPL.FLD.I LT PROC.APPL.FLD.CNT THEN
            PROC.APPL.FLDS := TRIM(PROC.APPL.FLD.MUL<1, 1, PROC.APPL.FLD.I>, " ", "B"):'=':TRIM(PROC.APPL.FLD.VAL.MUL<1, 1, PROC.APPL.FLD.I>, " ", "B"):','
        END ELSE
            PROC.APPL.FLDS := TRIM(PROC.APPL.FLD.MUL<1, 1, PROC.APPL.FLD.I>, " ", "B"):'=':TRIM(PROC.APPL.FLD.VAL.MUL<1, 1, PROC.APPL.FLD.I>, " ", "B")
        END
    NEXT PROC.APPL.FLD.I

    MYREQUEST = General_Request

    CHANGE 'APPLICATION' TO PROC.APPL IN MYREQUEST
    CHANGE 'VERSION' TO PROC.VERSION IN MYREQUEST
    CHANGE 'FUNCTION' TO PROC.FUNCTION IN MYREQUEST
    CHANGE 'APPL.ID' TO PROC.APPL.ID IN MYREQUEST
    CHANGE 'APPL.FLDS' TO PROC.APPL.FLDS IN MYREQUEST



* PRINT PROC.APPL:',':PROC.VERSION:'  ':PROC.FUNCTION:'  ':PROC.APPL.ID:'  ':CHANGE(PROC.APPL.FLDS, ',', '  ')
    EX.CMD = "LIST ":FN.PROC.APPL:" ":"'":PROC.APPL.ID:"' (N"
    CHECK.CONTINUE = 0
    GOSUB EXEC.CMD
    CHECK.CONTINUE = 1
    PRINT 'Do you want to continue Y/N ? ': ;INPUT CONT.VAL
    IF UPCASE(CONT.VAL) EQ 'Y' THEN
        GOSUB CALL.OBM
    END

RETURN

*------------------------------------------------------------------------------
CALL.OBM:
*--------

    MYRESPONSE = ''
    REQCOM = ''

    SHOWREQUEST = MYREQUEST
    CHANGE T24PASS TO '********' IN SHOWREQUEST

    PRINT SHOWREQUEST

    PRINT @(-1)
    OFS$SOURCE.ID = "TAABS"
    env = PUTENV("OFS_SOURCE=TAABS")
    READ OFS$SOURCE.REC FROM F.OFS.SOURCE,OFS$SOURCE.ID ELSE NULL
    IF OFS$SOURCE.REC THEN

        ORIGINAL.COMMAND = SHOWREQUEST
        GOSUB WRITE.LOG

        CALL JF.INITIALISE.CONNECTION
        CALL OFS.BULK.MANAGER(MYREQUEST, MYRESPONSE, REQCOM)

        IF MYRESPONSE[1, LEN(ORG.SVC.ID)] EQ ORG.SVC.ID THEN
            RESP.VAL = MYRESPONSE[',', 1, 1][LEN(ORG.SVC.ID),99]['/', 3, 1]
            IF RESP.VAL NE '1' THEN
                PRINT 'ERROR ':MYRESPONSE[',',2,999]
            END ELSE
                PRINT 'Txn committed.'
            END
        END ELSE
            PRINT 'ERROR ':MYRESPONSE
        END

    END ELSE
        PRINT 'OFS.SOURCE ID ':OFS$SOURCE.ID:' IS MISSING'
        STOP
    END

    PRINT 'Press any key to continue : ': ;INPUT CONT.VAL

RETURN

*------------------------------------------------------------------------------
CALL.ROUTINE:
*------------

    PRINT 'You are calling routine ':MENU.CALL.ROUT:'. Do you want to continue Y/N ? ': ; INPUT CONT.VAL

    IF UPCASE(CONT.VAL) EQ 'Y' THEN
        EXECUTE 'EBS.TERMINAL.SELECT EBS-JBASE'
        CALL @MENU.CALL.ROUT
    END

RETURN

*------------------------------------------------------------------------------
CHECK.JSH.CMD:
*-------------

    JSH.CMD.POS = 0


    ORG.JSH.CMD = JSH.CMD

    JSH.CMD = UPCASE(JSH.CMD[' ', 1, 1])

*    Tty     = @TTY  ;* /dev/pts/xx or CONxx$
*    IF Tty[1] = "$" THEN
*        Tty = Tty[1,LEN(Tty)-1]         ;* Remove $ incase of CONxx$
*    END

    IF SYSTEM(11) THEN        ;* If something is in active select list
        READLIST CurrentActiveList ELSE
            CurrentActiveList = ""
        END
    END

*    READ JSH.CMD.ACCESS FROM F.VOC, LogName:'_JSH' THEN
*        FINDSTR JSH.CMD IN JSH.CMD.ACCESS SETTING JSH.CMD.POS ELSE JSH.CMD.POS = 0
*    END

*    IF NOT(JSH.CMD.POS) THEN
*        READ JSH.FULL.CMD.ACCESS FROM F.VOC, LogName:'_':JSH.CMD THEN
*            FINDSTR ORG.JSH.CMD IN JSH.FULL.CMD.ACCESS SETTING JSH.CMD.POS ELSE JSH.CMD.POS = 0
*        END

*        IF NOT(JSH.CMD.POS) THEN
*            PRINT 'Sorry You do not have permission to execute this command ' ;* - Alert has been sent to Admin'
**            Alert = 'mailx -s "Please check user ':LogName:' from ':IpAddress:' is trying to execute Unauthorized command ':ORG.JSH.CMD:' in server ':HostName:'" Admin,PRODTI'
**            SH.CMD = Alert
**            GOSUB EXEC.CMD
**   EXECUTE CHAR(255):'K ':Alert
*   PRINT 'Press any key to continue : ' ; INPUT CONT.VAL
*        END
*    END

*    IF JSH.CMD.POS THEN
**  ORIGINAL.COMMAND = ORG.JSH.CMD
**  GOSUB WRITE.LOG
    EX.CMD = ORG.JSH.CMD
**JSH.CMD:' ':ORG.JSH.CMD[' ', 2, 9999]
    GOSUB EXEC.CMD
*    END

RETURN

*------------------------------------------------------------------------------
CHECK.SH.CMD:
*------------

    JSH.CMD.POS = 0

    ORG.JSH.CMD = JSH.CMD

*    JSH.CMD = UPCASE(JSH.CMD[' ', 1, 1])
    JSH.CMD = JSH.CMD[' ', 1, 1]

*    Tty     = @TTY  ;* /dev/pts/xx or CONxx$
*    IF Tty[1] = "$" THEN
*        Tty = Tty[1,LEN(Tty)-1]         ;* Remove $ incase of CONxx$
*    END

*    READ JSH.CMD.ACCESS FROM F.VOC, LogName:'_SH' THEN
*        FINDSTR JSH.CMD IN JSH.CMD.ACCESS SETTING JSH.CMD.POS ELSE JSH.CMD.POS = 0
*    END

*    IF NOT(JSH.CMD.POS) THEN
*        READ JSH.FULL.CMD.ACCESS FROM F.VOC, LogName:'_':JSH.CMD THEN
*            FINDSTR ORG.JSH.CMD IN JSH.FULL.CMD.ACCESS SETTING JSH.CMD.POS ELSE JSH.CMD.POS = 0
*        END

*        IF NOT(JSH.CMD.POS) THEN
*            PRINT 'Sorry You do not have permission to execute this command'
**            Alert = 'mailx -s "Please check user ':LogName:' from ':IpAddress:' is trying to execute Unauthorized command ':ORG.JSH.CMD:' in server ':HostName:'" Admin,PRODTI'
**            SH.CMD = Alert
**            GOSUB EXEC.CMD
**   EXECUTE CHAR(255):'K ':Alert
*   PRINT 'Press any key to continue : ' ; INPUT CONT.VAL
*        END

*    END

*    IF JSH.CMD.POS THEN
**  ORIGINAL.COMMAND = ORG.JSH.CMD
**  GOSUB WRITE.LOG
**  SH.CMD = JSH.CMD:' ':ORG.JSH.CMD[' ', 2, 9999]
    SH.CMD = ORG.JSH.CMD
    GOSUB EXEC.CMD
*    END

RETURN

*------------------------------------------------------------------------------
EXEC.CMD:
*--------

    BEGIN CASE
        CASE EX.CMD  NE ''
            MY.CMD = EX.CMD
        CASE SH.CMD NE ''
            MY.CMD = SH.CMD
    END CASE

    ORIGINAL.COMMAND = MY.CMD

    IF CHECK.CONTINUE THEN
        PRINT 'Executing ':MY.CMD:' command. Quieres Ejecutar Y/N ? : ': ; INPUT CONT.VAL
    END ELSE
        PRINT 'Executing ':MY.CMD:' command.'
        CONT.VAL = 'Y'
    END

*    IF EX.CMD THEN
*        PRINT 'Executing ':EX.CMD:' command. Quieres Ejecutar Y/N ? : ': ; INPUT CONT.VAL
*  ORIGINAL.COMMAND = EX.CMD
*    END
*    IF SH.CMD THEN
*        PRINT 'Executing ':SH.CMD:' script. Quieres Ejecutar Y/N ? : ': ; INPUT CONT.VAL
*  ORIGINAL.COMMAND = SH.CMD
*    END

    IF UPCASE(CONT.VAL) EQ 'Y' THEN
        GOSUB CHECK.EXEC.CMD
    END

    IF UPCASE(CONT.VAL) EQ 'Y' THEN
*  GOSUB WRITE.LOG
        BEGIN CASE
            CASE EX.CMD
                EXECUTE EX.CMD
                EX.CMD = ''
            CASE SH.CMD
                EXECUTE CHAR(255):'K ':SH.CMD
                SH.CMD = ''
        END CASE
        IF CHECK.CONTINUE THEN
            PRINT 'Press any key to continue : ': ; INPUT CONT.VAL
        END
    END ELSE
        PRINT 'Sorry you dont have permission to execute this command'
        EX.CMD = ''
        SH.CMD = ''
    END

RETURN

*------------------------------------------------------------------------------
CHECK.EXEC.CMD:
*-------------

    recordkey = 'TAFC.MENU.ACCESS.OPERATIONS'
    record = ORIGINAL.COMMAND
    userrc = ''
    CALL jShell.Audit.Trigger('', '', '', '', recordkey, record, userrc)
    IF NOT(userrc) THEN
        CONT.VAL = 'Y'
    END ELSE
        CONT.VAL = 'N'
    END

RETURN

*------------------------------------------------------------------------------
WRITE.LOG:
*---------

    Today   = DATE() "DG"     ;* YYYYMMDD
    DateTime = TIME() "MTS"   ;* HH:MM:SS
    OsDateTime = TIMESTAMP()
    OsDateTime = OCONV(LOCALDATE(OsDateTime, ""), "D"):" ":OCONV(LOCALTIME(OsDateTime, ""), "MTS")
    recordkey = 'T24OPERATOR.MENU'

* use REC.NO because if there are several commands from same terminal within 1 sec - only the last one is saved.
*
    RecID = UPCASE(Today:"_":DateTime:"_":PortNo:"_":LogName:"_":++REC.NO)      ;* Convert to Upper case
*
    CallStack = SYSTEM(1029)
    VAR2 = DCOUNT(CallStack,@VM)
    VAR3 = VAR2
    RjBASEJedLog = ''
    FOR I = 1 TO VAR2
        IF I NE VAR2 THEN
            RjBASEJedLog<jedlogger.routine.name> = RjBASEJedLog<jedlogger.routine.name>:CallStack<1,VAR3,4>:" -> "
            VAR3 = INT(VAR3)-1
        END ELSE
            RjBASEJedLog<jedlogger.routine.name> = RjBASEJedLog<jedlogger.routine.name>:CallStack<1,I,4>
            VAR3 = INT(VAR3)-1
        END
    NEXT
*
    RjBASEJedLog<jedlogger.record.key>  = recordkey
    RjBASEJedLog<jedlogger.dateandtime> = OsDateTime
*    RjBASEJedLog<jedlogger.datapart>    = record<1>    ;* don't use record<1> because it might be a VOC paragraph
    RjBASEJedLog<jedlogger.datapart>    = ORIGINAL.COMMAND
    RjBASEJedLog<jedlogger.loginid>     = ActLogName        ;*LogName
    RjBASEJedLog<jedlogger.ipaddress>   = IpAddress
    RjBASEJedLog<jedlogger.hostname>    = HostName
    RjBASEJedLog<jedlogger.terminal>    = Tty
    RjBASEJedLog<jedlogger.environment> = ""

    WRITE RjBASEJedLog TO F.TAFC.AUDIT.LOG, RecID


RETURN

*------------------------------------------------------------------------------
