SUBROUTINE MULTI.TRANSACTION.SERVICE.RECORD
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This record routine is used to hold the version names in the fields
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

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*-------------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)
RETURN
*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------

    R.NEW(REDO.MTS.RESERVED.9) = ''
    R.NEW(REDO.MTS.RESERVED.8) = ''

RETURN
*--------------------------------------------------------------------------------------
END
