$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.ENQ.VISA.VERIFY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.VISA.NOFILE.VERIFY.INFO
*--------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine to nofile enquiry REDO.ENQ.VISA.CHGBCK.VERIFY
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 1 Jan 2012     Balagurunathan         PACS00170998              Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.VAL.DATA=O.DATA
    CHANGE '@@@' TO "#" IN Y.VAL.DATA
    O.DATA=Y.VAL.DATA

RETURN

END
