SUBROUTINE REDO.B.UPDATE.CHEQ.STOCK(CHEQUE.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.UPDATE.CHEQ.STOCK
*-------------------------------------------------------------------------

* Description : This Routine is a Batch Routine which is executed on a Yearly basis
* such that the records present in CERTIFIED.CHEQUE.STOCK application in live status will be moved to History Record
* In parameter : ID.LIST
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE               WHO          REFERENCE         DESCRIPTION
* 22.03.2010  SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK.HIS
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPDATE.CHEQ.STOCK.COMMON
*
********************************************
* Live records will be moved to History Records
**********************************************
*
    Y.CHEQUE.ID = CHEQUE.ID
    R.CERT.CHEQ.STO=''
    CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.ID,R.CERT.CHEQ.STO,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
    CALL F.DELETE(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.ID)
    Y.CHEQUE.HIS.ID=Y.CHEQUE.ID:';1'
    CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK.HIS,Y.CHEQUE.HIS.ID,R.CERT.CHEQ.STO)
RETURN
END
