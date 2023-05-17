SUBROUTINE MULTI.TRANSACTION.SERVICE.VALAIDATE
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to retrive the informations from multiple files
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
    $INSERT I_F.AA.ARRANGEMENT

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
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN
*-------------
PROCESS:

    Y.PYMT.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)
    Y.PYMT.MODE = CHANGE(Y.PYMT.MODE,@VM,@FM)
    Y.CNT = DCOUNT(Y.PYMT.MODE,@FM)
    Y.PYMT.VAL = R.NEW(REDO.MTS.PAYMENT.MODE,Y.CNT)

    IF Y.PYMT.VAL EQ 'CHEQUE' THEN
        ETEXT = 'TT-ARR.CHQ.ID'
        CALL STORE.END.ERROR
    END
RETURN
*--------------
GOEND:
END
