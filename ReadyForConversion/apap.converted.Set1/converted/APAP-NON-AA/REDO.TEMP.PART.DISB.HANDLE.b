SUBROUTINE REDO.TEMP.PART.DISB.HANDLE
*********************************************************************
*Company Name  : APAP
*First Release : R15 Upgrade
*Developed for : APAP
*Developed by  : Edwin Charles D
*Date          : 21/06/2017
*--------------------------------------------------------------------------------------------
*
* Subroutine Type       : PROCEDURE
* Attached to           : VERSION.CONTROL - REDO.FT.TT.TRANSACTION,PSB
* Attached as           : ID ROUTINE
* Primary Purpose       : When a transaction is DELETED, updates info on REDO.DISB.CHAIN and REDO.CREATE.ARRANGEMENT
* Modified              : R15 Upgrade
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.REDO.FT.TT.TRANSACTION
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

* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1

    FN.REDO.FT.NAU = 'F.REDO.FT.TT.TRANSACTION$NAU'
    F.REDO.FT.NAU = ''
    CALL OPF(FN.REDO.FT.NAU,F.REDO.FT.NAU)

    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

    RTNDISB = ""
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
                Y.ID = COMI
                CALL F.READ(FN.REDO.FT.NAU,Y.ID,R.REDO.FT.NAU,F.REDO.FT.NAU,REDO.FT.ERR)
                WVCR.RDC.ID = R.REDO.FT.NAU<FT.TN.L.INITIAL.ID>
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
*
* ======
PROCESS:
* ======
*
* Updates info in REDO.DISB.CHAIN -
*
*
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    LOCATE Y.ID IN R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,1> SETTING Y.POS.RDC THEN
        R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,Y.POS.RDC> = "DEL"
    END
*
    WTID.NUMBER = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>,@VM)
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
