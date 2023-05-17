SUBROUTINE REDO.MTS.DIS.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.MULTI.TRAN.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.MTS.DISBURSE to
* default the value for the  FT application from REDO.MTS.DISBURSE
* It is AUTOM NEW CONTENT routine

*IN PARAMETER : NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*16-11-2010   JEEVA T           B.12           INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.MTS.DISBURSE

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
    F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = "" ; Y.CASH.FLAG = '' ; Y.CHEQUE.FLAG = '' ; Y.SETTLE.TYPE = ''
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.MULTI.PROCESS.ID=FIELD(Y.DATA,"*",2)
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION EQ ",REDO.AA.CUS.PAY" THEN
        CALL F.READ(FN.REDO.MTS.DISBURSE,Y.REDO.MULTI.PROCESS.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,PRO.ERR)
        R.NEW(FT.DEBIT.ACCT.NO)   = R.REDO.MTS.DISBURSE<MT.BR.AC.NUMBER>
        R.NEW(FT.DEBIT.CURRENCY)  = R.REDO.MTS.DISBURSE<MT.CURRENCY>
        R.NEW(FT.DEBIT.AMOUNT)    = R.REDO.MTS.DISBURSE<MT.AMOUNT>
        R.NEW(FT.CREDIT.THEIR.REF) = Y.REDO.MULTI.PROCESS.ID
    END

    IF APPLICATION EQ 'TELLER' AND PGM.VERSION EQ ",REDO.AA.CUS.PAY" THEN
        CALL F.READ(FN.REDO.MTS.DISBURSE,Y.REDO.MULTI.PROCESS.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,PRO.ERR)
        R.NEW(TT.TE.ACCOUNT.2) = R.REDO.MTS.DISBURSE<MT.BR.AC.NUMBER>
        R.NEW(TT.TE.CURRENCY.1) = R.REDO.MTS.DISBURSE<MT.CURRENCY>
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = R.REDO.MTS.DISBURSE<MT.AMOUNT>
        R.NEW(TT.TE.NARRATIVE.1) = Y.REDO.MULTI.PROCESS.ID
        R.NEW(TT.TE.THEIR.REFERENCE)=R.REDO.MTS.DISBURSE<MT.TRAN.TYPE>
    END
RETURN
*--------------------------------------------------------------------------------------------------
END
