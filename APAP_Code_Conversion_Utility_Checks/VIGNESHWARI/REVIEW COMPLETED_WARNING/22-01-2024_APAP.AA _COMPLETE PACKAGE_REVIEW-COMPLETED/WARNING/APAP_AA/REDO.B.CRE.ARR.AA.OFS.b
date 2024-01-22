* @ValidationCode : MjoxMjc0ODE3MzY6Q3AxMjUyOjE3MDM3NTg4ODI0Mzc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2023 15:51:22
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
$PACKAGE APAP.AA
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM to @VM
*14-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   VARIABLE IS CHANGE
*28-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION CHANGE F.READ TO F.READU
*---------------------------------------------------------------------------------------	-
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRE.ARR.AA.OFS(Y.REDO.CRE.ARR.AA.OFS.LIST.ID)
*-----------------------------------------------------------------------------
* Fabrica de Credito
* This SERVICE has to check if the AA that was queued by REDO.CREATE.ARRANGEMENT
* has been created OK or NOT
*
* An update the final status on REDO.CREATE.ARRANGEMENT
*
*        AUTHOR                   DATE
*-----------------------------------------------------------------------------
* hpasquel@temenos.com         2011-01-11
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.B.CRE.ARR.AA.OFS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ERROR = 0
    Y.FATAL = "YES"   ;* By Default is NOT FATAL
    R.REDO.CRE.ARR.AA.OFS.LIST = ''
    YERR = ''
    CALL F.READ(FN.REDO.CRE.ARR.AA.OFS.LIST,Y.REDO.CRE.ARR.AA.OFS.LIST.ID, R.REDO.CRE.ARR.AA.OFS.LIST, F.REDO.CRE.ARR.AA.OFS.LIST, YERR)
    IF NOT(R.REDO.CRE.ARR.AA.OFS.LIST) THEN
        Y.FATAL = ""
        TEXT = "ST-REDO.CR.RECORD.NOT.FOUND" : @VM : "RECORD & NOT FOUND ON &"
        TEXT<2> = Y.REDO.CRE.ARR.AA.OFS.LIST.ID : @VM : FN.REDO.CRE.ARR.AA.OFS.LIST
        GOSUB FATAL.ERROR
    END
    Y.ARRANGEMENT.ID = R.REDO.CRE.ARR.AA.OFS.LIST<2>
    Y.RCA.ID = R.REDO.CRE.ARR.AA.OFS.LIST<1>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.OFS.RESPONSE.ID = Y.REDO.CRE.ARR.AA.OFS.LIST.ID["-",1,1] : ".1"
    R.OFS.RESPONSE.QUEUE = ''
    YERR = ''
* Is in the RESPONSE.QUEUE ?
    CALL F.READ(FN.OFS.RESPONSE.QUEUE, Y.OFS.RESPONSE.ID, R.OFS.RESPONSE.QUEUE, F.OFS.RESPONSE.QUEUE, YERR)
    IF NOT(R.OFS.RESPONSE.QUEUE) THEN
        Y.OFS.MESSAGE.QUEUE.ID = Y.REDO.CRE.ARR.AA.OFS.LIST.ID
        R.OFS.MESSAGE.QUEUE = ''
        YERR = ''
* Is in MESSAGE.QUEUE ?
        CALL F.READ(FN.OFS.MESSAGE.QUEUE,Y.OFS.MESSAGE.QUEUE.ID,R.OFS.MESSAGE.QUEUE,F.OFS.MESSAGE.QUEUE,YERR)
        IF NOT(R.OFS.MESSAGE.QUEUE) THEN
            GOSUB CHECK.AA.EXISTS
        END ELSE
* The OFS message has not been processed yet, try later with the same ID
            CALL OCOMO("OFS.MSG.QUEUE.ID " : Y.REDO.CRE.ARR.AA.OFS.LIST.ID : "WAS NOT PROCESSED YET")
            TEXT = "ST-REDO.CR.AA.OFS.NOT.PROCESSED.YET" : @VM : "RECORD & HAS NOT BEEN PROCESSED BY OFS.MESSAGE.SERVICE, YET"
            GOSUB FATAL.ERROR
        END
    END
*
    IF Y.ERROR THEN
        RETURN
    END
*
    Y.STATUS = R.OFS.RESPONSE.QUEUE<1>
    Y.RESP = ''
    BEGIN CASE
        CASE Y.STATUS EQ '1'
            Y.RESP = ''
        CASE Y.STATUS NE '1'
            Y.RESP = R.OFS.RESPONSE.QUEUE<2>
    END CASE


* Write the final status on REDO.CREATE.ARRANGEMENT
    R.REDO.CREATE.ARRANGEMENT = ''
    YERR = ''
  *  CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.RCA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,YERR)
  CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,Y.RCA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,YERR,"") ;*R22 MANUAL CONVERSTION -CHANGE F.READ TO F.READU 
    IF NOT(R.REDO.CREATE.ARRANGEMENT) THEN
        Y.FATAL = ""
        TEXT = "ST-REDO.CR.RECORD.NOT.FOUND" : @VM : "RECORD & NOT FOUND ON &"
        TEXT<2> = Y.RCA.ID : @VM : FN.REDO.CREATE.ARRANGEMENT
        GOSUB FATAL.ERROR
    END
    IF Y.STATUS NE '1' THEN
        Y.STATUS = Y.STATUS : '/' : Y.RESP
    END

* R.REDO.CREATE.ARRANGEMENT<REDO.CR.REC.STATUS> = Y.STATUS
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.RECORD.STATUS>=Y.STATUS ;*REDO.CR.REC.STATUS to REDO.FC.RECORD.STATUS

    CALL F.WRITE(FN.REDO.CREATE.ARRANGEMENT,Y.RCA.ID,R.REDO.CREATE.ARRANGEMENT)
*
    CALL F.DELETE(FN.REDO.CRE.ARR.AA.OFS.LIST,Y.REDO.CRE.ARR.AA.OFS.LIST.ID)

RETURN
*-----------------------------------------------------------------------------
FATAL.ERROR:
* Call to FATAL.ERROR. Y.FATAL determines if the service has to be stoped or not
*-----------------------------------------------------------------------------
    C.DESC = TEXT
    CALL TXT(C.DESC)
    SOURCE.INFO = 'REDO.B.CRE.ARR.OFS'
    SOURCE.INFO<7> = Y.FATAL    ;* get out of this ID and get the next ID
    CALL FATAL.ERROR(SOURCE.INFO)
    Y.ERROR = 1
*-----------------------------------------------------------------------------
CHECK.AA.EXISTS:
* The message is missed on queues, then check if AA was already created or not
*-----------------------------------------------------------------------------
    R.AA.ARRANGEMENT = ''
    YERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,YERR)
    IF NOT(R.AA.ARRANGEMENT) THEN
        R.OFS.RESPONSE.QUEUE = ''
        R.OFS.RESPONSE.QUEUE<1> = '-1'
        R.OFS.RESPONSE.QUEUE<2> = 'AA.OFS PROCESADO PERO NO CREADO DETAILS NOT FOUND'
    END ELSE
        R.OFS.RESPONSE.QUEUE<1> = '1'
        R.OFS.RESPONSE.QUEUE<2> = ''
    END
RETURN
*-----------------------------------------------------------------------------
END
