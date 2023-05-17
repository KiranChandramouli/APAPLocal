SUBROUTINE REDO.AUT.UPD.CLEAR.OUT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.AUT.UPD.CLEAR.OUT
*-------------------------------------------------------------------------
* Description: This routine is a Authorisation Routine
*
*----------------------------------------------------------
* Linked with:  FUNDS.TRANSFER,CH.RTN
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.REDO.OUTWARD.CLEARING = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.OUTWARD.CLEARING = ''
    CALL OPF(FN.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING)

    FN.REDO.APAP.H.REPRINT.SEQ = 'F.REDO.APAP.H.REPRINT.SEQ'
    F.REDO.APAP.H.REPRINT.SEQ  = ''
    CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ)

RETURN

PROCESS:

*Get the Payment Details

    VAR.PAY.DETAILS = R.NEW(FT.PAYMENT.DETAILS)

* Read REDO.CLEARING.OUTWARD and get the status and raise the override


    CALL F.READU(FN.REDO.OUTWARD.CLEARING,VAR.PAY.DETAILS,R.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING,OUTWARD.ERR,'')
    R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CHQ.STATUS> = "RETURNED"
    R.REDO.OUTWARD.CLEARING<CLEAR.OUT.RETURN.STATUS> = 'SETTLED'

    TEMP.V = V
    V = CLEAR.OUT.AUDIT.DATE.TIME
    CALL F.WRITE(FN.REDO.OUTWARD.CLEARING, VAR.PAY.DETAILS, R.REDO.OUTWARD.CLEARING)
    V = TEMP.V
    CALL F.RELEASE(FN.REDO.OUTWARD.CLEARING, VAR.PAY.DETAILS, F.REDO.OUTWARD.CLEARING)

    IF PGM.VERSION EQ ',CH.RTN' THEN
        GOSUB UPDATE.DEAL.SLIP
    END
RETURN
*----------------------------------------------
UPDATE.DEAL.SLIP:
*----------------------------------------------

    CALL PRODUCE.DEAL.SLIP('REDO.CHQ.DETAIL')
    Y.TXN.DSLIP = ID.NEW

    R.REDO.APAP.H.REPRINT.SEQ                             = ''
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.SEQ>   = '0'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.FLAG>  = 'NO'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.INIT.PRINT>    = 'NO'
    CALL F.WRITE(FN.REDO.APAP.H.REPRINT.SEQ,Y.TXN.DSLIP,R.REDO.APAP.H.REPRINT.SEQ)

RETURN
END
