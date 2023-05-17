SUBROUTINE REDO.AUTH.CUS.UPD.FAX

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.CUS.UPD.FAX
*--------------------------------------------------------------------------------
* Description: This routine is for the local template which holds Id of Employee customer
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 02-12-2011      Jeeva T     For COB Performance
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB OPEN.FILE

RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.REDO.W.CUSTOMER.UPDATE = 'F.REDO.W.CUSTOMER.UPDATE'
    F.REDO.W.CUSTOMER.UPDATE = ''
    CALL OPF(FN.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE)

    R.REDO.W.CUSTOMER.UPDATE = ''
    Y.FAX = ''
    Y.FAX = R.NEW(EB.CUS.FAX.1)

    CALL F.READ(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW,R.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE,Y.ERR)

    IF NOT(R.REDO.W.CUSTOMER.UPDATE) AND Y.FAX THEN
        R.REDO.W.CUSTOMER.UPDATE<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW,R.REDO.W.CUSTOMER.UPDATE)
    END

    IF NOT(Y.FAX) AND R.REDO.W.CUSTOMER.UPDATE THEN
        CALL F.DELETE(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW)
    END

RETURN
END
