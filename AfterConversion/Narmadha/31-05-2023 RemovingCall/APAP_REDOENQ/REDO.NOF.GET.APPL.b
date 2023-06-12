$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.GET.APPL(Y.DATA)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.GET.APPL
*--------------------------------------------------------------------------------
*Description : This routine is used to display the  in selection citeria
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.NOF.GET.APPL
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   02-06-2011       DHAMU S                 CRM                Initial Creation
* 13-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.DATA = 'RECLAMACION':@FM:'SOLICITUD':@FM:'QUEJAS'

RETURN
