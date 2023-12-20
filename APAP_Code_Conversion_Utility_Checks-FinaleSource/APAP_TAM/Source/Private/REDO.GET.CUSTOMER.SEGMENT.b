$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.CUSTOMER.SEGMENT(Y.FINAL.ARRAY)
**************************************************************************************************
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S & MOHAMMED ANIES.K
* Program Name : REDO.NOF.CLIENT.DETAILS
*--------------------------------------------------------------------------------
*Description :This subroutine is attached to the ENQUIRY REDO.PRD.CLIENT.ENQ
*             which displays the client details
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.ENQ.CUSTOMER.SEGMENT
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   19-10-2010       DHAMU S          ODR-2010-08-0182 113       Initial Creation
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.FINAL.ARRAY<-1> = 'PLATINUM':@FM:'GOLD':@FM:'SILVER':@FM:'BRONZE':@FM:'COPPER'

RETURN
************************************************************
END
