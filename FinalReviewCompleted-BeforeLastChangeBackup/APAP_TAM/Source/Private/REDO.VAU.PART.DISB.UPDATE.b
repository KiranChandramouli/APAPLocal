* @ValidationCode : MjoyMDYxMzA0NTU1OkNwMTI1MjoxNjgxMTUxNjIwNzIwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:40
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
SUBROUTINE REDO.VAU.PART.DISB.UPDATE
*
* =======================================================================
*
*    First Release :
*    Developed for : APAP
*    Developed by  : TAM
*    Date          : 28-11-2012
*    Attached to   : VERSION.CONTROL - FT,PSB
*    Attached as   : AUTHORISATION ROUTINE
*    Modified      : PACS00245100 - 12-02-2013
* =======================================================================
* =======================================================================
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VMf
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.REDO.DISB.CHAIN
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
* Updates TRAN.AUTH field to AP if ONLY SOME valid transactions are AUTHORISED,
*   and to A if ALL valid transactions are AUTHORISED
*
    RTNDISB = ""
    RTR     = ""
*
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
*
    IF NOT(ERR.MSJDISB) THEN
        GOSUB WRITE.RDC
    END
*
RETURN
*
* ========
WRITE.RDC:
* ========
*
    WVCR.TEMPLATE.ID = R.REDO.DISB.CHAIN<DS.CH.RCA.ID>
*
    Y.TEMP.FT.ID   = R.NEW(FT.CREDIT.THEIR.REF)
    LOCATE Y.TEMP.FT.ID IN R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,1> SETTING Y.POS THEN
        R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,Y.POS> = "AUTH"
        R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>     = "PP"
        IF R.REDO.DISB.CHAIN<DS.CH.TR.STATUS> EQ "AUTH" THEN
            R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS> = "A"
            R.REDO.DISB.CHAIN<DS.CH.RPD.ID>  = ''
        END ELSE
            GOSUB UPDATE.STATUS.RDC
        END
    END

* R.REDO.DISB.CHAIN<DS.CH.RPD.ID>  = ''
    CALL F.WRITE(FN.REDO.DISB.CHAIN,WVCR.RDC.ID,R.REDO.DISB.CHAIN)

    CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,FC.ERR)
    R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.STAT> = R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>

    CALL F.WRITE(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC)
*
RETURN
*
* ================
UPDATE.STATUS.RDC:
* ================
*
* Check whether all valid transactions are already authorised (field TRANS.STATUS EQ blank)
* If ALL are authorised, update field TRANS.AUTH to A
*
    WTID.NUMBER = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID>,@VM)
    LOOP.CNT        = 1
    PROCESS.GOAHEAD = 1
*
    LOOP
    WHILE LOOP.CNT LE WTID.NUMBER AND PROCESS.GOAHEAD
        W.STATUS = R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,LOOP.CNT>
        IF W.STATUS  NE "AUTH" AND W.STATUS NE "DEL" THEN
            PROCESS.GOAHEAD = ""
        END
*
        LOOP.CNT += 1
*
    REPEAT
*
    IF PROCESS.GOAHEAD THEN
        R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS> = "A"
        R.REDO.DISB.CHAIN<DS.CH.RPD.ID>  = ''
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
* wmeza
*
    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    R.REDO.DISB.CHAIN   = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
    F.REDO.AA.PART.DISBURSE.FC = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

    YPOS = ''
    WAPP.LST  = APPLICATION
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOS.LI    = YPOS<1,1>
*
    WVCR.RDC.ID      = R.NEW(FT.LOCAL.REF)<1,WPOS.LI>
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
    MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
        BEGIN CASE
*
            CASE LOOP.CNT EQ 1
                IF WVCR.RDC.ID EQ "" THEN
                    PROCESS.GOAHEAD = ""
                END

        END CASE
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
