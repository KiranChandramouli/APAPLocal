SUBROUTINE REDO.V.VAL.STO.SET.RTN
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.INP.STO.SET.RTN
*------------------------------------------------------------------------------------------------------------------
*Description       :This routine is to set sunnel routine and mask the 6 digits in the credit card
*Linked With       :
*In  Parameter     :
*Out Parameter     :
*ODR  Number       : 2010-08-0031
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System

    R.NEW(STO.FT.ROUTINE)='@REDO.V.STO.UPD.SUNNEL'
RETURN
END
