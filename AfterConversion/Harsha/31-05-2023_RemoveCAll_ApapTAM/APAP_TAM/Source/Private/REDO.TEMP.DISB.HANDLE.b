* @ValidationCode : MjotMTM1MjA4MzU1MjpDcDEyNTI6MTY4MTEwOTg0Mjk0ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:22
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
SUBROUTINE REDO.TEMP.DISB.HANDLE
*********************************************************************
*Company Name  : APAP
*First Release : R15 Upgrade
*Developed for : APAP
*Developed by  : Edwin Charles D
*Date          : 21/06/2017
*--------------------------------------------------------------------------------------------
*
* Subroutine Type       : PROCEDURE
* Attached to           : VERSION.CONTROL - FUNDS.TRANSFER,DSB
* Attached as           : ID ROUTINE
* Primary Purpose       : When a transaction is DELETED, updates info on REDO.DISB.CHAIN and REDO.CREATE.ARRANGEMENT
* Modified              : R15 Upgrade
*--------------------------------------------------------------------------------------------
* Modification Details:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.REDO.FT.TT.TRANSACTION
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.DISB.CHAIN
    $INSERT I_F.REDO.AA.DISBURSE.METHOD
*
*************************************************************************

    IF V$FUNCTION NE 'D' THEN
        RETURN
    END

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1

    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

    FN.REDO.FT.NAU = 'F.REDO.FT.TT.TRANSACTION$NAU'
    F.REDO.FT.NAU = ''
    CALL OPF(FN.REDO.FT.NAU,F.REDO.FT.NAU)

    FN.REDO.AA.DISBURSE.METHOD = 'F.REDO.AA.DISBURSE.METHOD'
    F.REDO.AA.DISBURSE.METHOD = ''
    CALL OPF(FN.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD)

    RTNDISB = ""
*
RETURN
*
OPEN.FILES:
* =========
*
*
RETURN


CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3

    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF V$FUNCTION NE "D" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                Y.ID = COMI
                CALL F.READ(FN.REDO.FT.NAU,Y.ID,R.REDO.FT.NAU,F.REDO.FT.NAU,REDO.FT.ERR)
                WVCR.RDC.ID = R.REDO.FT.NAU<FT.TN.L.INITIAL.ID>
                CALL F.READ(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB)
                IF ERR.MSJDISB THEN
                    Y.ERR.MSG = "EB-RECORD.&.DOES.NOT.EXIST.IN.TABLE.&":@FM:FN.REDO.DISB.CHAIN:@VM:WVCR.RDC.ID
                END

            CASE LOOP.CNT EQ 3
                WVCR.TEMPLATE.ID = R.REDO.DISB.CHAIN<DS.CH.RCA.ID>
                CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
                Y.AA.ID = R.REDO.CREATE.ARRANGEMENT<REDO.FC.ID.ARRANGEMENT>
                GOSUB EX.MULTI.LOP

        END CASE

        GOSUB CONTROL.MSG.ERROR

        LOOP.CNT += 1
    REPEAT
*
RETURN

PROCESS:
* ======
*
* Updates info in REDO.DISB.CHAIN -
*
*
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,Y.POS.RDC> = "DEL"

    WTID.NUMBER = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>,@VM)
    WTID.NUMBER.D = Y.POS.RDC
    LOOP.CNT        = 1
    PROCESS.GOAHEAD.1 = 1

    LOOP
    WHILE LOOP.CNT LE WTID.NUMBER AND PROCESS.GOAHEAD.1
        W.STATUS = R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,LOOP.CNT>
        IF W.STATUS NE "DEL" AND W.STATUS NE "AUTH" THEN
            PROCESS.GOAHEAD.1 = ""
        END

        LOOP.CNT += 1

    REPEAT

    IF PROCESS.GOAHEAD.1 THEN
        R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS> = "D"
    END

    FLS.ID = ''
    CALL LOG.WRITE(FN.REDO.DISB.CHAIN,WVCR.RDC.ID,R.REDO.DISB.CHAIN,FLS.ID)
*
* Updates info in REDO.CREATE.ARRANGEMENT
*
    LOCATE Y.ID IN R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.CODTXN,1> SETTING Y.POS.RCA ELSE
        Y.ERR.MSG = "EB-FT.&.DOES.NOT.EXIST.IN.TABLE.&":@FM:FN.REDO.CREATE.ARRANGEMENT:@VM:WVCR.TEMPLATE.ID
    END
*
    CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ, RTN)
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.CODTXN, Y.POS.RCA> = ""
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.STA, Y.POS.RCA>    = ""
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB>           = "D"
    FLSS.ID = ''
    CALL LOG.WRITE(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,FLSS.ID)

    GOSUB DELETE.AA.DISB.MET
*
RETURN
*

DELETE.AA.DISB.MET:

    CALL F.READ(FN.REDO.AA.DISBURSE.METHOD,Y.AA.ID,R.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD,AA.DIS.ERR)

    LOCATE WVCR.TEMPLATE.ID IN R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID,1> SETTING PS.FC THEN
        LOCATE Y.ID IN R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,1> SETTING PS.CB THEN
            GOSUB PROCES.DL.RE
        END
    END

RETURN

PROCES.DL.RE:

    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,PS.CB>
    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,PS.FC,PS.CB>
    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT,PS.FC,PS.CB>

    IF R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,1>  EQ '' THEN
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID,PS.FC>
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.PROP,PS.FC>
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.AMT,PS.FC>
    END

    Y.FSDS = ''
    CALL LOG.WRITE(FN.REDO.AA.DISBURSE.METHOD,Y.AA.ID,R.REDO.AA.DISBURSE.METHOD,Y.FSDS)

RETURN
*
EX.MULTI.LOP:

    IF ERR.MSJ THEN
        Y.ERR.MSG = "EB-RECORD.&.DOES.NOT.EXIST.IN.TABLE.&":@FM:FN.REDO.CREATE.ARRANGEMENT:@VM:WVCR.TEMPLATE.ID
    END ELSE
        LOCATE Y.ID IN R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,1> SETTING Y.POS.RDC ELSE
            Y.ERR.MSG = "EB-FT.&.DOES.NOT.EXIST.IN.TABLE.&":@FM:FN.REDO.DISB.CHAIN:@VM:WVCR.RDC.ID
        END
    END

RETURN
* ================
CONTROL.MSG.ERROR:
* ================
*
    IF Y.ERR.MSG THEN
        E               = Y.ERR.MSG
        V$ERROR         = 1
        PROCESS.GOAHEAD = ""
        CALL ERR
    END
*
RETURN
*
END
