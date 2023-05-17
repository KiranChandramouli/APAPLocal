SUBROUTINE REDO.APAP.VAL.MAT.DATE
*-----------------------------------------------------------------------------
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By : Temenos Application Management
*Program Name : REDO.CARD.GENERATION.RECORD
*------------------------------------------------------------------------------
*Description : REDO.APAP.VAL.MAT.DATE is a validation routine for
* the version AZ.ACCOUNT, OPEN.CPH which populates the
* field L.VAL.MAT.DATE
*Linked With : AZ.ACCOUNT,OPEN.CPH
*In Parameter : N/A
*Out Parameter: N/A
*Files Used : AZ.ACCOUNT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date Who Reference Description
* ------ ------ ------------- -------------
* 29-07-2010 JEEVA T ODR-2009-10-0346 B.21 Initial Creation
*--------------------------------------------------------------------------------

*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.AZ.ACCOUNT

**************************************************************************
**********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA
RETURN
**************************************************************************
*************
PROCESS.PARA:
*************

    Y.MAT.DATE=COMI
    Y.VAL.DATE=R.NEW(AZ.VALUE.DATE)
    Y.VAL.MAT.DATE=Y.VAL.DATE:'-':Y.MAT.DATE
    CALL System.setVariable("CURRENT.MAT.DATE",Y.MAT.DATE)
    GOSUB FIND.MULTI.LOCAL.REF
    R.NEW(AZ.LOCAL.REF)<1,LOC.L.VAL.MAT.DATE.POS>=Y.VAL.MAT.DATE
    CALL REDO.V.PRINCIPAL.INT.RATE
RETURN
**************************************************************************
*************
FIND.MULTI.LOCAL.REF:
*************
    APPL.ARRAY='AZ.ACCOUNT'
    FLD.ARRAY='L.VAL.MAT.DATE'
    FLD.POS=''
    CALL GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.VAL.MAT.DATE.POS=FLD.POS<1,1>
RETURN
**************************************************************************
END
