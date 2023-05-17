SUBROUTINE REDO.AZ.FUND.PARAM.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.FUND.PARAM.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.AZ.FUND.PARAM.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.AZ.FUND.PARAM , the routine checks if the duplicate value entered in the
*                    CURRENCY field
*Linked With       : Template - REDO.AZ.FUND.PARAM
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.AZ.FUND.PARAM           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 01 Nov 2010       Sudharsanan S               CR.18                 Initial Creation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AZ.FUND.PARAM
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = REDO.FUND.CURRENCY
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
