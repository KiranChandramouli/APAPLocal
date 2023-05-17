SUBROUTINE REDO.B.UPDATE.CHEQ.STOCK.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.UPDATE.CHEQ.STOCK.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.UPDATE.CHEQ.STOCK.LOAD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE               WHO          REFERENCE         DESCRIPTION
* 22.03.2010  SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK.HIS
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPDATE.CHEQ.STOCK.COMMON
    FN.CERTIFIED.CHEQUE.STOCK='F.CERTIFIED.CHEQUE.STOCK'
    F.CERTIFIED.CHEQUE.STOCK=''
    CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
    FN.CERTIFIED.CHEQUE.STOCK.HIS='F.CERTIFIED.CHEQUE.STOCK.HIS'
    F.CERTIFIED.CHEQUE.STOCK.HIS=''
    CALL OPF(FN.CERTIFIED.CHEQUE.STOCK.HIS,F.CERTIFIED.CHEQUE.STOCK.HIS)
RETURN
END
