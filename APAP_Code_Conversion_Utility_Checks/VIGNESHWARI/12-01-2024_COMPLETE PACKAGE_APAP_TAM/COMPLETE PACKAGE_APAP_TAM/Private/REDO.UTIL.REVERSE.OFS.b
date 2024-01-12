* @ValidationCode : MjotMTk2NDAyMzA3NzpVVEYtODoxNzA0OTc0NDkyMjcxOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 17:31:32
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
$PACKAGE APAP.TAM

SUBROUTINE REDO.UTIL.REVERSE.OFS(APPLICATION.ID,RECORD.ID)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 11.21.2011
* Description  : Utility for reversing OFS Messages through interfaces
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference      Description
* 1.0       21.11.2011     lpazmino       CR.180         Initial version
*           13.04.2023   Conversion Tool   R22           Auto Conversion     - TNO TO C$T24.SESSION.NO, FM TO @FM, -- TO -= 1
*           13.04.2023   Shanmugapriya M   R22           Manual Conversion   - Add call routine prefix
*           11.01.2024   Narmadha V        R22           Manual R22 Conversion  > to GE
*-----------------------------------------------------------------------------
* Input/Output:
* RECORD.ID/NA
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_GTS.COMMON ;*Manual R22 Conversion
    $INSERT I_EB.TRANS.COMMON
    $USING EB.TransactionControl
    $USING EB.Interface

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $USING APAP.TAM
    $USING APAP.REDOCHNLS
* </region>

    GOSUB INIT
    GOSUB TRX.REVERSE

* <region name="GOSUBS">
************************
* Intitialize variables
INIT:
************************
    BK.SEPARATOR = ','
    SUB.BK.SEPARATOR = '/'
    Y.OFS.SOURCE.ID = 'FC.OFS'

    Y.FC.REG.FILE = 'REDO.FC.TRX.REGISTRY'
    Y.FC.REG.ID   = RECORD.ID

* Parameters in Activtity Report for Interface Log
    Y.INT.CODE = 'FC001'
    Y.INT.TYPE = 'ONLINE'
    Y.INT.INFO = 'FC'
    Y.INT.MONT = ''
    Y.INT.DESC = ''
    Y.INT.DATA = ''
    Y.INT.USER = OPERATOR
    Y.INT.TERM = C$T24.SESSION.NO          ;** R22 Auto conversion - TNO TO C$T24.SESSION.NO

    Y.REVERSE.MESSAGES = ''

RETURN

******************
* Reverse Process
TRX.REVERSE:
******************
* It is neccesary to report a successful activity in
* the Event & Failure Interface Log
    Y.INT.MONT = '09'
    Y.INT.DESC = 'ERROR - TRANSACCION REVERSADA'
    Y.INT.DATA = APPLICATION.ID : '@' : RECORD.ID
*CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INT.INFO, Y.INT.INFO, Y.FC.REG.ID, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.TERM)
** R22 Manual conversion
    APAP.REDOCHNLS.redoInterfaceRecAct(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INT.INFO, Y.INT.INFO, Y.FC.REG.ID, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.TERM)

    GOSUB CREATE.OFS.MESSAGES
    GOSUB PROCESS.OFS.MESSAGES
    GOSUB RESET.FC.VALUES

    AF = REDO.FC.PRODUCT

RETURN


**********************
* Check OFS Response
CHECK.OFS.RESPONSE:
**********************
    MSG.ID = OFS.MSG.RES[BK.SEPARATOR,1,1]
    SUCCESS.FAIL = MSG.ID[SUB.BK.SEPARATOR,3,1]

    IF SUCCESS.FAIL NE '1' THEN
* ERROR
* OFS Message not validated properly
        Y.TXN.COMMITED = 0
    END ELSE
* SUCCESS
* Proceed to commit the record
        Y.TXN.COMMITED = 1
    END

RETURN

******************************
* Create OFS reverse messages
CREATE.OFS.MESSAGES:
******************************
    GOSUB OPEN.REGISTRY
    LOOP
        READSEQ Y.FC.REGISTRY FROM Y.REG ELSE EXIT
        Y.APP = Y.FC.REGISTRY["-",1,1]
        Y.VER = Y.FC.REGISTRY["-",2,1]
        Y.ID  = Y.FC.REGISTRY["-",3,1]

* Generate reverse messages
        Y.OFS.REV.MSG = Y.APP : ',' : Y.VER : '/R/PROCESS//0,,' : Y.ID
        Y.REVERSE.MESSAGES<-1> = Y.OFS.REV.MSG
    REPEAT
    GOSUB CLOSE.REGISTRY

RETURN

**********************************
* Process OFS messages to reverse
PROCESS.OFS.MESSAGES:
**********************************
    Y.NUM.MSG = DCOUNT(Y.REVERSE.MESSAGES,@FM)
*    LOOP WHILE Y.NUM.MSG > 1 DO
    LOOP WHILE Y.NUM.MSG GE 1 DO ;*Manual R22 Conversion
        OFS.MSG.REQ = FIELD(Y.REVERSE.MESSAGES,@FM,Y.NUM.MSG)
* Process OFS Reverse Message
        CALL COMMON.SAVE
*        CALL JOURNAL.UPDATE("")
        EB.TransactionControl.JournalUpdate("");* R22 UTILITY AUTO CONVERSION
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.REQ)
*        CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE.ID, OFS.MSG.REQ, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
        EB.Interface.OfsCallBulkManager(Y.OFS.SOURCE.ID, OFS.MSG.REQ, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End;* R22 UTILITY AUTO CONVERSION

        OFS.MSG.RES = OFS.MSG.REQ
        CALL COMMON.RESTORE

        GOSUB CHECK.OFS.RESPONSE

        IF Y.TXN.COMMITED THEN
* Continue processing next reverse message
            Y.NUM.MSG -= 1                     ;** R22 Auto conversion -  -- TO -= 1
        END ELSE
* Force logic condition to break the loop
            Y.NUM.MSG = 0
        END

    REPEAT

RETURN

*********************
* Open registry file
OPEN.REGISTRY:
*********************
    OPENSEQ Y.FC.REG.FILE, Y.FC.REG.ID TO Y.REG ELSE
* File doesnt exist, proceed to creation
        CREATE Y.REG ELSE
            Y.EXE.CMD = "CREATE.FILE " : Y.FC.REG.FILE : " TYPE=UD"   ;* R22 Manual conversion
* Create directly JBase file
*EXECUTE("CREATE.FILE " : Y.FC.REG.FILE : " TYPE=UD")
            EXECUTE Y.EXE.CMD                                       ;* R22 Manual conversion
            GOSUB OPEN.REGISTRY
        END
    END

RETURN

*****************
* Close Registry
CLOSE.REGISTRY:
*****************
    CLOSESEQ Y.REG
RETURN

*****************
RESET.FC.VALUES:
*****************
* Delete generated fields in REDO.CREATE.ARRANGEMENT
* through process
    R.NEW(REDO.FC.ID.LIMIT) = ''
    R.NEW(REDO.FC.ID.COLLATERL.RIGHT) = ''
    R.NEW(REDO.FC.LIMIT.REFERENCE)    = ''
    R.NEW(REDO.FC.COLL.RIGHT.CODE)    = ''
    R.NEW(REDO.FC.VALIDITY.DATE)      = ''
    R.NEW(REDO.FC.SEC.HOLD.IDENTIF)   = ''

RETURN
* </region>

END
