* @ValidationCode : Mjo2MTY4NDU0ODc6Q3AxMjUyOjE3MDEwODkxNjI1NDU6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Nov 2023 18:16:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH

SUBROUTINE REDO.B.MONITOR.SHIP.LOAD
*
*
*--------------------------------------------------------------------------
* Modifications;
*
* 03/09/10 - Created by Victor Nava
* 07/09/10 - Cesar Yepez. CALLJ to java program
* 01/03/19 - PACS00731205 - Issue Fix by Gopala Krishnan R
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION = TO EQ
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	    VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES- SQA-11542 | MONITOR  – By Santiago-No changes
*--------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.SHIP.COMMON
    $INSERT I_TSS.COMMON
    $INSERT I_F.REDO.MONITOR.CONNECTION
    $USING APAP.REDOCHNLS
*
*--------------------------------------------------------------------------
*
* Main processing

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB GET.DATA.CONNECTION
    GOSUB DO.PROCESS

RETURN
*
*--------------------------------------------------------------------------
DO.PROCESS:

    className = classNameConn
    methodName = methodNameConn
    CALLJ className,methodName,CONNECT_INFO SETTING ret ON ERROR
        GOSUB errorHandler
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
        CALL FATAL.ERROR("FATAL-ERROR " : ERR.MSG)
        RETURN
    END

    IF FIELD(ret,'|',1,1) EQ '2' THEN
        ERR.MSG = 'ERR RETURNED BY CONNECTION JAVA PROGRAM ' : FIELD(ret,'|',1,2)
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
        CALL FATAL.ERROR("FATAL-ERROR " : FIELD(ret,'|',1,2))
        RETURN
    END

RETURN

*--------------------------------------------------------------------------
GET.DATA.CONNECTION:

* Example string of connection
*CONNECT_INFO = "jdbc:sqlserver://10.12.0.73:1433;databaseName=REDOMONITOR;integratedSecurity=false;"
*CONNECT_INFO = CONNECT_INFO : FM : "sa"
*CONNECT_INFO = CONNECT_INFO : FM : "Temenos123"


    CALL CACHE.READ(FN.REDO.MON.CONNECTION,'SYSTEM',R.CONNECTION,YERR.CONN)
*CALL F.READ(FN.REDO.MON.CONNECTION,'SYSTEM',R.CONNECTION,FN.REDO.MON.CONNECTION,YERR.CONN)


    IF NOT(YERR.CONN) THEN
        Y.IP = R.CONNECTION<REDO.MON.CONN.IP.ADDRESS>
        Y.PORT.NUMBER = R.CONNECTION<REDO.MON.CONN.PORT.NUMBER>
        Y.DATABASE.NAME = R.CONNECTION<REDO.MON.CONN.DATABASE.NAME>
        Y.USER = R.CONNECTION<REDO.MON.CONN.USER>
        Y.PASSWORD = R.CONNECTION<REDO.MON.CONN.PASSWORD>
*PACS00731205 - S
        Y.ORACLE.MODE = R.CONNECTION<REDO.MON.CONN.ORACLE.MODE>
        IF Y.ORACLE.MODE EQ 'Y' THEN
            CONNECT_INFO  = "jdbc:oracle:thin:@": Y.IP : ":" : Y.PORT.NUMBER : "/" :Y.DATABASE.NAME
            CONNECT_INFO  = CONNECT_INFO :"@fm": Y.USER
            CONNECT_INFO  = CONNECT_INFO :"@fm": Y.PASSWORD
            CONNECT_INFO  = CONNECT_INFO :"@fm": "ORACLE"
        END ELSE
            CONNECT_INFO  = "jdbc:sqlserver://" : Y.IP : ":" : Y.PORT.NUMBER : ";"
            CONNECT_INFO := "databaseName=" : Y.DATABASE.NAME : ";"
            CONNECT_INFO := "integratedSecurity=false;"
            CONNECT_INFO  = CONNECT_INFO :"@fm": Y.USER
            CONNECT_INFO  = CONNECT_INFO :"@fm": Y.PASSWORD
        END
*PACS00731205 - E
    END ELSE
        ERR.MSG = 'CONNECTION DATA NO FOUND IN REDO.MONITOR.CONNECTION'
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
        CALL FATAL.ERROR("FATAL-ERROR " : ERR.MSG)
    END


RETURN

*--------------------------------------------------------------------------

LOG.ERROR:
* Register error in the fault log

    INT.CODE = Y.INTERF.ID
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = 'T24'
    INFO.DE = 'MONITOR'
    ID.PROC = 'REDO.B.MONITOR.SHIP.LOAD'
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = 'REDO.B.MONITOR.SHIP.LOAD'
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR'
            MON.TP = 08
    END CASE

*    CALL REDO.INTERFACE.REC.ACT(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC) ;*R22 Manual Code Conversion
RETURN

*--------------------------------------------------------------------------
errorHandler:
    err = SYSTEM(0)

    BEGIN CASE
        CASE err EQ 1
            ERR.MSG = "Fatal Error creating Thread!"
        CASE err EQ 2
            ERR.MSG = "Cannot find the JVM.dll !"
        CASE err EQ 3
            ERR.MSG = "Class " : className : " doesn't exist!"
        CASE err EQ 4
            ERR.MSG = "UNICODE conversion error!"
        CASE err EQ 5
            ERR.MSG = "Method " : methodName : " doesn't exist!"
        CASE err EQ 6
            ERR.MSG = "Cannot find object Constructor!"
        CASE err EQ 7
            ERR.MSG = "Cannot instantiate object!"
        CASE @TRUE
            ERR.MSG = "Unknown error!"
    END CASE

RETURN

*--------------------------------------------------------------------------
INITIALISE:

    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'

    classNameConn =  "com.temenos.monitor.connection.DBConnection"
    methodNameConn = "$openConnection"

    classNameInsert = "com.temenos.monitor.main.REDOMonitor"
    methodNameInsert = "insert"

    CONNECT_INFO = ''
    ERR.MSG = ''
    ERR.TYPE = ''
    YERR.CONN = ''
    R.CONNECTION = ''
    ret = ''

RETURN

*--------------------------------------------------------------------------

OPEN.FILES:

    FN.REDO.MON.SEND.QUEUE = 'F.REDO.MON.SEND.QUEUE'
    F.REDO.MON.SEND.QUEUE = ''
    CALL OPF(FN.REDO.MON.SEND.QUEUE, F.REDO.MON.SEND.QUEUE)

    FN.REDO.MON.SEND.QUEUE.ERR = 'F.REDO.MON.SEND.QUEUE.ERR'
    F.REDO.MON.SEND.QUEUE.ERR = ''
    CALL OPF(FN.REDO.MON.SEND.QUEUE.ERR, F.REDO.MON.SEND.QUEUE.ERR)

    FN.REDO.MON.CONNECTION = 'F.REDO.MONITOR.CONNECTION'
    F.REDO.MON.CONNECTION = ''
    CALL OPF(FN.REDO.MON.CONNECTION, F.REDO.MON.CONNECTION)

RETURN
*--------------------------------------------------------------------------

END
