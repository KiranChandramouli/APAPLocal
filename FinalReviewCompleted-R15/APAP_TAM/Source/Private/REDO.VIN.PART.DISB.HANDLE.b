* @ValidationCode : MjotNzM1ODUwNjA1OkNwMTI1MjoxNjgxMTg5OTk2MDY2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:43:16
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
SUBROUTINE REDO.VIN.PART.DISB.HANDLE
*********************************************************************
*Company Name  : APAP
*First Release : Marimuthu
*Developed for : APAP
*Developed by  : Marimuthu
*Date          : 12-02-2013
*--------------------------------------------------------------------------------------------
*
* Subroutine Type       : PROCEDURE
* Attached to           : VERSION.CONTROL - FUNDS.TRANSFER,PSB
* Attached as           : INPUT ROUTINE
* Primary Purpose       : When a transaction is DELETED, updates info on CONTROL TABLES
* Modified              : PACS00245100 - 12-02-2013
*--------------------------------------------------------------------------------------------
* Modification Details:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------
*
*
*************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.REDO.DISB.CHAIN
*
*************************************************************************


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*
* ======
PROCESS:
* ======
*
* Updates info in REDO.DISB.CHAIN -
*
*
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    LOCATE ID.NEW IN R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID,1> SETTING Y.POS.RDC THEN
        R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,Y.POS.RDC> = "DEL"
    END
*
    WTID.NUMBER = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID>,@VM)
    WTID.NUMBER.D = Y.POS.RDC
    LOOP.CNT        = 1
    PROCESS.GOAHEAD.1 = 1
*
    LOOP
    WHILE LOOP.CNT LE WTID.NUMBER AND PROCESS.GOAHEAD.1
        W.STATUS = R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,LOOP.CNT>
        IF W.STATUS NE "DEL" AND W.STATUS NE "AUTH" THEN
            PROCESS.GOAHEAD.1 = ""
        END
*
        LOOP.CNT += 1
*
    REPEAT
*
    IF PROCESS.GOAHEAD.1 THEN
        R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS> = "D"
    END
*
    CALL F.WRITE(FN.REDO.DISB.CHAIN,WVCR.RDC.ID,R.REDO.DISB.CHAIN)

RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1

    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

    RTNDISB = ""
*
    YPOS = ''
    WAPP.LST  = APPLICATION
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.TRAN.AUTH"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOS.LI    = YPOS<1,1>
    WPOS.FT.TA = YPOS<1,2>
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 2
*
    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF V$FUNCTION NE "D" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                WVCR.RDC.ID = R.NEW(FT.LOCAL.REF)<1,WPOS.LI>
                CALL F.READ(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB)
                IF ERR.MSJDISB THEN
                    Y.ERR.MSG = "EB-RECORD.&.DOES.NOT.EXIST.IN.TABLE.&":@FM:FN.REDO.DISB.CHAIN:@VM:WVCR.RDC.ID
                END

        END CASE
*
        GOSUB CONTROL.MSG.ERROR
*
        LOOP.CNT += 1
    REPEAT
*
RETURN
*
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
