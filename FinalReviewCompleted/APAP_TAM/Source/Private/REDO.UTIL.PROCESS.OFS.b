* @ValidationCode : MjoxMzk5OTM5MjI2OkNwMTI1MjoxNjgzMDE4MTAwODg4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-167</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.UTIL.PROCESS.OFS(OFS.MSG.REQ, OFS.MSG.RES)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : Utility for processing OFS Messages through interfaces
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference      Description
* 1.0       15.06.2011     lpazmino       CR.180         Complete refactoring
* 1.1       01.11.2011     lpazmino       CR.180         Reverse feature
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix, FM TO @FM, VM TO @VM
*
*-----------------------------------------------------------------------------
* Input/Output:
* OFS.MSG.REQ > OFS Message Request
* OFS.MSG.RES > OFS Message Response
*
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
***********PACS00708597**********************************
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.CUSTOMER
*************PACS00708597********************************
    $INSERT I_F.OFS.SOURCE

    $INSERT I_RAPID.APP.DEV.COMMON
    
    $USING APAP.REDOCHNLS
	$USING APAP.TAM
* </region>

    GOSUB INIT
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

* Initialize variables
INIT:

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.APAP.LN.OFS.CONCAT = 'F.APAP.LN.OFS.CONCAT'
    F.APAP.LN.OFS.CONCAT = ''
    CALL OPF(FN.APAP.LN.OFS.CONCAT,F.APAP.LN.OFS.CONCAT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    BK.SEPARATOR = ','
    SUB.BK.SEPARATOR = '/'
* OFS.SOURCE used for FC
    Y.OFS.SOURCE.ID = ''
* This helps to determine if was called from BULK.MANAGER
    IF OFS$SOURCE.ID NE 'LN.TEST.OFS' THEN
        Y.BM.CAN.BE.USED = OFS$SOURCE.REC AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> MATCHES 'TELNET'
    END

* OFS Message main info
    Y.APPLICATION.ID = OFS.MSG.REQ[BK.SEPARATOR,1,1]
    Y.RECORD.ID      = OFS.MSG.REQ[BK.SEPARATOR,4,1]
    Y.MSG.OPTS       = OFS.MSG.REQ[BK.SEPARATOR,2,1]
    Y.VERSION        = Y.MSG.OPTS[SUB.BK.SEPARATOR,1,1]

    Y.OPTIONS = ''
    Y.TXN.COMMITED = ''
    Y.ERR = ''
    Y.TRX.REGISTERED = 0
* Parameters in Activtity Report for Interface Log
    Y.INT.CODE = 'FC001'
    Y.INT.TYPE = 'ONLINE'
    Y.INT.INFO = 'FC'
    Y.INT.MONT = ''
    Y.INT.DESC = ''
    Y.INT.DATA = ''
    Y.INT.USER = OPERATOR
    Y.INT.TERM = TNO
    Y.FC.REG.FILE = 'REDO.FC.TRX.REGISTRY'
    Y.FC.REG.ID   = ID.NEW
*************PACS00708597********************************
    APPL.NAME.ARR = "CUSTOMER"
    FLD.NAME.ARR = "NEW.LN.PROC"
    FLD.POS.ARR = ""
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    VAL.POS = FLD.POS.ARR<1,1>
    GOSUB READ.CUS.GET.PROC.VAL
***********PACS00708597**********************************
RETURN

READ.CUS.GET.PROC.VAL:
    Y.RCA.ID =  ID.NEW
    Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    Y.VAL.PROC = R.CUSTOMER<EB.CUS.LOCAL.REF,VAL.POS>
*    IF Y.VAL.PROC EQ "YES" THEN
*        IF OFS$BROWSER THEN
*            GOSUB WRITE.CONCAT.TABLE
*        END
*   END
RETURN

***********PACS00708597**********************************

***********************
* Main Process
PROCESS:
***********************

    E = ''

    IF Y.BM.CAN.BE.USED THEN
* OFS Message will be send by OFS.BULK.MANANGER
* when it comes from TWS (Automatic process)
        Y.OFS.SOURCE.ID = 'FC.TWS'
        Y.OPTIONS = Y.OFS.SOURCE.ID : @FM : "OFS"
        CALL OFS.CALL.BULK.MANAGER(Y.OPTIONS, OFS.MSG.REQ, OFS.MSG.RES, Y.TXN.COMMITED)
    END ELSE
* OFS Message will be sent by OFS.GLOBUS.MANAGER
* when it comes from VERSION (Manual process)
***********PACS00708597**********************************
        IF Y.VAL.PROC NE "YES" THEN
***********PACS00708597*********************************
            GOSUB RES.VALUE.PROC.CHK
        END ELSE
***********PACS00708597**********************************
            GOSUB WRITE.CONCAT.TABLE
*            IF (RUNNING.UNDER.BATCH) THEN
*                CALL ofs.addLocalRequest(OFS.MSG.REQ,'add',Y.ERR)
*            END
        END
    END
RETURN
***********PACS00708597**********************************

WRITE.CONCAT.TABLE:
    R.APAP.LN.OFS.CONCAT = '' ; Y.ID.RCA = ID.NEW
    CALL F.READU(FN.APAP.LN.OFS.CONCAT,Y.ID.RCA,R.APAP.LN.OFS.CONCAT,F.APAP.LN.OFS.CONCAT,ERR,'')
    R.APAP.LN.OFS.CONCAT<-1> = OFS.MSG.REQ
    CALL F.WRITE(FN.APAP.LN.OFS.CONCAT,Y.ID.RCA,R.APAP.LN.OFS.CONCAT)
RETURN


RES.VALUE.PROC.CHK:
    Y.OFS.SOURCE.ID = 'FC.OFS'
    OFS.MSG.VAL = EREPLACE(OFS.MSG.REQ,"PROCESS","VALIDATE")
    GOSUB COMMON.SAVE.LOCAL
    CALL COMMON.SAVE
    CALL JOURNAL.UPDATE("")
    OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.VAL)
    CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.VAL, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
    
    OFS.MSG.RES = OFS.MSG.VAL
    CALL COMMON.RESTORE
    GOSUB COMMON.RESTORE.LOCAL
    GOSUB CHECK.OFS.RESPONSE
    IF Y.TXN.COMMITED THEN
* Send message to process
        GOSUB COMMON.SAVE.LOCAL
        CALL COMMON.SAVE
        CALL JOURNAL.UPDATE("")
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.REQ)
        CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.REQ, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End

        OFS.MSG.RES = OFS.MSG.REQ
        GOSUB CHECK.OFS.RESPONSE
        CALL COMMON.RESTORE
        GOSUB COMMON.RESTORE.LOCAL
* FC transacction registry
        IF Y.TXN.COMMITED THEN
            GOSUB TRX.REGISTER
        END
    END
RETURN

*** Testing purposes
*         IF OPERATOR EQ 'LFPAZMINO' AND Y.APPLICATION.ID EQ 'COLLATERAL' THEN
*            * Force reverse
*            CALL REDO.UTIL.REVERSE.OFS(Y.APPLICATION.ID, Y.FC.REG.ID)
*            GOSUB ADD.RESPONSE.MESSAGE
*         END
*** End Testing purposes

**********************
* Check OFS Response
CHECK.OFS.RESPONSE:
**********************
    MSG.ID = OFS.MSG.RES[BK.SEPARATOR,1,1]
    SUCCESS.FAIL = MSG.ID[SUB.BK.SEPARATOR,3,1]
    MSG.NOT.CHANGED = INDEX(OFS.MSG.RES,'LIVE RECORD NOT CHANGED',1)

* Capture fail message in response
    Y.RESP = OFS.MSG.RES[",",2,99]
    IF Y.RESP EQ '' THEN
        Y.RESP = OFS.MSG.RES
    END

    IF SUCCESS.FAIL NE '1' AND NOT(MSG.NOT.CHANGED) THEN
* ERROR
* OFS Message not validated properly
        Y.TXN.COMMITED = 0
        IF Y.TRX.REGISTERED THEN
* CALL REDO.UTIL.REVERSE.OFS(Y.APPLICATION.ID,Y.FC.REG.ID)
** R22 Manual conversion
            APAP.TAM.redoUtilReverseOfs(Y.APPLICATION.ID,Y.FC.REG.ID)
        END
        GOSUB ADD.RESPONSE.MESSAGE
    END ELSE
* SUCCESS
* Proceed to commit the record
        Y.TXN.COMMITED = 1
    END

RETURN

***********************
* Transaction registry
TRX.REGISTER:
***********************
* It is neccesary to report a successful activity in
* the Event & Failure Interface Log
    Y.INT.MONT = '01'
    Y.INT.DESC = 'EJECUCION SATISFACTORIA'
    Y.INT.DATA = Y.APPLICATION.ID : '@' : Y.RECORD.ID
*CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INT.INFO, Y.INT.INFO, Y.FC.REG.ID, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.TERM)
** R22 Manual conversion
    APAP.REDOCHNLS.redoInterfaceRecAct(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INT.INFO, Y.INT.INFO, Y.FC.REG.ID, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.TERM)

    Y.NEW.ENTRY   = Y.APPLICATION.ID : '-' : Y.VERSION : '-' : Y.RECORD.ID

    GOSUB OPEN.REGISTRY
    GOSUB WRITE.NEW.REGISTRY
    GOSUB CLOSE.REGISTRY

RETURN

*********************
* Open registry file
OPEN.REGISTRY:
*********************
*OPENSEQ Y.FC.REG.FILE, Y.FC.REG.ID TO Y.REG SETTING Y.RESULT ELSE
    OPENSEQ Y.FC.REG.FILE, Y.FC.REG.ID TO Y.REG ELSE    ;* R22 Manual conversion
* File doesnt exist, proceed to creation
        CREATE Y.REG ELSE
*EXECUTE("CREATE.FILE " : Y.FC.REG.FILE : " TYPE=UD")
            Y.EXE.CMD = "CREATE.FILE " : Y.FC.REG.FILE : " TYPE=UD"
            EXECUTE Y.EXE.CMD
            GOSUB OPEN.REGISTRY
        END
    END

RETURN

*********************
* Write new registry
WRITE.NEW.REGISTRY:
*********************
    WRITESEQ Y.NEW.ENTRY APPEND TO Y.REG ELSE
* Registry could not be appended
        CALL OCOMO(Y.FC.REG.ID : " - UNABLE TO WRITE TO THE FILE")
    END

RETURN

*****************
* Close Registry
CLOSE.REGISTRY:
*****************
    CLOSESEQ Y.REG
RETURN

***********************
* Add Response Message
ADD.RESPONSE.MESSAGE:
***********************
    E = "EB-FC-REVERSE.TRN" : @FM : Y.APPLICATION.ID : @VM : Y.RESP             ;* R22 Manual conversion - FM TO @FM, VM TO @VM
RETURN
* </region>


COMMON.SAVE.LOCAL:
    DIM SAVE.R.OLD(C$SYSDIM)
    DIM SAVE.R.NEW(C$SYSDIM)
    DIM SAVE.T(C$SYSDIM)
    DIM SAVE.CONCATFILE(C$SYSDIM)

    MAT SAVE.R.OLD = MAT R.OLD
    MAT SAVE.R.NEW = MAT R.NEW
    SAVE.ID.NEW = ID.NEW
    SAVE.APP = APPLICATION
    SAVE.FULL.FNAME = FULL.FNAME
    SAVE.F.FILE = F.FILE
    SAVE.COMI = COMI
    SAVE.FN = V$FUNCTION
    SAVE.V = V
    MAT SAVE.T = MAT T
    MAT SAVE.CONCATFILE = MAT CONCATFILE

RETURN

COMMON.RESTORE.LOCAL:

    MAT T = MAT SAVE.T
    MAT R.OLD = MAT SAVE.R.OLD
    MAT R.NEW = MAT SAVE.R.NEW
    ID.NEW = SAVE.ID.NEW
    APPLICATION = SAVE.APP
    FULL.FNAME = SAVE.FULL.FNAME
    F.FILE = SAVE.F.FILE
    V = SAVE.V
    COMI = SAVE.COMI
    MAT CONCATFILE = MAT SAVE.CONCATFILE

RETURN

END
