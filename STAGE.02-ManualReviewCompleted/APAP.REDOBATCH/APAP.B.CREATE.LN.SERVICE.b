* @ValidationCode : MjotMTcwODE3NDYyNDpDcDEyNTI6MTY4MDc4MDQxNjY0ODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:56:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE APAP.B.CREATE.LN.SERVICE(REDO.CREATE.ARR)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      :
*Date              :
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION FM TO @FM AND ++ TO += 1
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_APAP.B.CREATE.LN.SERVICE.COMMON
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL
    GOSUB PROCESS
RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
    OFS.SOURCE.ID = 'FC.OFS' ; SKIP = '' ; MSG.CNT = 0
    Y.REDO.CREATE.ARR.ID = REDO.CREATE.ARR
    CALL F.READU(FN.APAP.LN.OFS.CONCAT,Y.REDO.CREATE.ARR.ID,R.APAP.LN.OFS.CONCAT,F.APAP.LN.OFS.CONCAT,Y.REDO.ERR,'')
    TOT.MSG.CNT = DCOUNT(R.APAP.LN.OFS.CONCAT,@FM)

*    LOOP
*        MSG.CNT ++
*    WHILE R.APAP.LN.OFS.CONCAT AND NOT(SKIP)
    Y.MESSAGE = R.APAP.LN.OFS.CONCAT<1>
    APPLN = FIELD(Y.MESSAGE,'/',1)
    DEL R.APAP.LN.OFS.CONCAT<1>
    Y.TXN.COMMITTED = '' ; Y.RESPONSE = ''

    CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,REDO.CREATE.ARR,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,Y.REDO.ERR,'')
    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,Y.MESSAGE,Y.RESPONSE, Y.TXN.COMMITTED)
    GOSUB CHECK.OUT.MESSAGE
    IF R.APAP.LN.OFS.CONCAT THEN
        CALL F.WRITE(FN.APAP.LN.OFS.CONCAT,Y.REDO.CREATE.ARR.ID,R.APAP.LN.OFS.CONCAT)
        CALL F.RELEASE(FN.REDO.CREATE.ARRANGEMENT,Y.REDO.CREATE.ARR.ID,F.REDO.CREATE.ARRANGEMENT)
    END ELSE
        IF NOT(Y.ERROR.MSG)  THEN
            R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.STATUS> = "Complete"
            R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.ERROR> = ''
            GOSUB WRITE.REDO.ARRANGEMENT
        END
    END
*    REPEAT

RETURN


CHECK.OUT.MESSAGE:
    Y.APP.ID = FIELD(Y.RESPONSE,",",1)
    Y.MESS.OUT = FIELD(Y.APP.ID,"/",3)
    IF Y.MESS.OUT EQ '1' THEN

    END ELSE
        R.APAP.LN.OFS.CONCAT = ''
        GOSUB WRITE.ERROR.MSG.VAL
        GOSUB WRITE.REDO.ARRANGEMENT
    END
RETURN

WRITE.ERROR.MSG.VAL:
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.STATUS> = "Error"
    Y.FLAG = "2"
    Y.COUNT.VALUE = DCOUNT(Y.RESPONSE,",")
    Y.ERROR.MSG = APPLN
    LOOP
    WHILE Y.FLAG LE Y.COUNT.VALUE
        Y.INT.COUNT = Y.FLAG
        IF APPLN THEN
            Y.ERROR.MSG = APPLN:',':FIELD(Y.RESPONSE,",",Y.INT.COUNT)
        END ELSE
            Y.ERROR.MSG = FIELD(Y.RESPONSE,",",Y.INT.COUNT)
        END
        R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.ERROR,-1> = Y.ERROR.MSG
        APPLN = ''
        Y.FLAG += 1
    REPEAT
RETURN

WRITE.REDO.ARRANGEMENT:
    CALL F.WRITE(FN.REDO.CREATE.ARRANGEMENT,Y.REDO.CREATE.ARR.ID,R.REDO.CREATE.ARRANGEMENT)
    CALL F.DELETE(FN.APAP.LN.OFS.CONCAT,Y.REDO.CREATE.ARR.ID)
RETURN

*****************************FINAL END****************************************
END
