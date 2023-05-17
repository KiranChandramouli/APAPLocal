* @ValidationCode : MjotODAwNzgzMDAyOkNwMTI1MjoxNjgyNDIxOTE0NzU5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:55:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PRE.JOB.OFS
*--------------------------------------------------------------
* Description: This is pre Job for Direct debit to check OFS.MESSAGE.QUEUE
* has been cleared for charge messages.
*--------------------------------------------------------------

* Input Argument : NA
* Out Argument   : NA
* Deals With     : BATCH>BNK/REDO.B.DIRECT.DBT
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, ++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL routine format modified
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------
    FN.REDO.AA.OFS.FAIL = 'F.REDO.AA.OFS.FAIL'
    F.REDO.AA.OFS.FAIL = ''
    CALL OPF(FN.REDO.AA.OFS.FAIL,F.REDO.AA.OFS.FAIL)

    FN.OFS.MESSAGE.QUEUE = 'F.OFS.MESSAGE.QUEUE'
    F.OFS.MESSAGE.QUEUE = ''
    CALL OPF(FN.OFS.MESSAGE.QUEUE,F.OFS.MESSAGE.QUEUE)

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    INT.CODE = 'COB001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''

    MON.TP   = '04'
    DESC     = 'Run OFS Message Service(BNK/OFS.MESSAGE.SERVICE)'
    REC.CON  = 'Run OFS Message Service(BNK/OFS.MESSAGE.SERVICE)'

    CALL APAP.TAM.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION

    Y.CNCT.ID = TODAY:'-':'OFS'
    R.RECORD.CNCT = ''
    CALL F.READ(FN.REDO.AA.OFS.FAIL,Y.CNCT.ID,R.RECORD.CNCT,F.REDO.AA.OFS.FAIL,CNCT.ERR)

    IF R.RECORD.CNCT EQ '' THEN
        RETURN
    END

    LOOP
    WHILE R.RECORD.CNCT
        Y.VAR1 =1
        Y.MSG.CNT = DCOUNT(R.RECORD.CNCT,@FM)
        CALL OCOMO("Run OFS.MESSAGE.SERVICE")
        CALL OCOMO("Waiting For OFS.MESSAGE.SERVICE to process ":Y.MSG.CNT:" messages")
        LOOP
        WHILE Y.VAR1 LE Y.MSG.CNT
            R.OFS.MESSAGE = ''
            IF R.RECORD.CNCT<Y.VAR1> THEN
                CALL F.READ(FN.OFS.MESSAGE.QUEUE,R.RECORD.CNCT<Y.VAR1>,R.OFS.MESSAGE,F.OFS.MESSAGE.QUEUE,OFS.MSG.ERR)
                IF R.OFS.MESSAGE THEN
                    Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
                END ELSE
                    DEL R.RECORD.CNCT<Y.VAR1>
                END
            END ELSE

                Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
            END
        REPEAT
        SLEEP 30
    REPEAT
    CALL OCOMO("Messages are processed")
RETURN
END
