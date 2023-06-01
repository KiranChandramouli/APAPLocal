* @ValidationCode : MjotMTg0NTk2MjA4NTpDcDEyNTI6MTY4MjQxMjMyODUyMDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*---------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*05-04-2023           Samaran T          Manual R22 Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
SUBROUTINE REDO.AUTH.PRINT.DEALSLIP
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_RC.COMMON
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ


    OFS$DEAL.SLIP.PRINTING = 1
    Y.TXN.ID = ID.NEW


    Y.DEAL.SLIP.ID = R.VERSION(EB.VER.D.SLIP.FORMAT)
    IF Y.DEAL.SLIP.ID THEN
        OFS$DEAL.SLIP.PRINTING = 1
        CALL PRODUCE.DEAL.SLIP(Y.DEAL.SLIP.ID)
        R.VERSION(EB.VER.D.SLIP.FORMAT) = ''
        R.VERSION(EB.VER.D.SLIP.FUNCTION) = ''
        R.VERSION(EB.VER.D.SLIP.TRIGGER) = ''
        GOSUB UPDATE.REPRINT.TABLE
    END
RETURN

UPDATE.REPRINT.TABLE:
    FN.REDO.APAP.H.REPRINT.SEQ = 'F.REDO.APAP.H.REPRINT.SEQ'
    F.REDO.APAP.H.REPRINT.SEQ = ''
    CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ)

    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.SEQ>   = '0'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.FLAG>  = 'NO'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.INIT.PRINT>    = 'NO'
    GET.FIRST.ID = FIELD(C$LAST.HOLD.ID,',',1)
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.HOLD.CTRL.ID> = CHANGE(C$LAST.HOLD.ID,',',@VM)
    WRITE R.REDO.APAP.H.REPRINT.SEQ TO F.REDO.APAP.H.REPRINT.SEQ, Y.TXN.ID
RETURN


END
