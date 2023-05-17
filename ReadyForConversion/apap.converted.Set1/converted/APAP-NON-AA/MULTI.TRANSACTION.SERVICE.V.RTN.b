SUBROUTINE MULTI.TRANSACTION.SERVICE.V.RTN
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to hide the transaction id field based upon the user's
*               selection in Settlement type field
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.TELLER.ID

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*---------
INIT:
RETURN

*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
RETURN
*-------------
PROCESS:
    Y.TYPE = R.NEW(REDO.MTS.SETTLEMENT.TYPE)
    Y.ARR.ID = R.NEW(REDO.MTS.ARRANGEMENT.ID)
    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
*    Y.DR.NO = R.NEW(REDO.MTS.DR.CR.ACCOUNT.NO)
    IF Y.TYPE EQ 'SINGLE' AND Y.OPERATION EQ 'REPAYMENT' THEN
        IF Y.ARR.ID EQ '' THEN
            ETEXT = 'TT-ARR.ID.FOR.TYPE.SINGLE'
            CALL STORE.END.ERROR
        END
*        IF Y.DR.NO EQ '' THEN
*            ETEXT = 'TT-ACC.NO.FOR.TYPE.SINGLE'
*            CALL STORE.END.ERROR
*        END
    END

    Y.TYPE1 = COMI
    IF Y.OPERATION EQ 'REPAYMENT' THEN
        IF Y.TYPE1 EQ 'MULTIPLE' THEN
            T(REDO.MTS.ARRANGEMENT.ID)<3> = 'NOINPUT'
        END

        Y.RESIDUAL.VAL = R.NEW(REDO.MTS.RESIDUAL)
        IF Y.RESIDUAL.VAL EQ 'NO' THEN
            T(REDO.MTS.RESIDUAL.MODE)<3> = 'NOINPUT'
        END
    END
RETURN
*--------------
GOEND:
END
