$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.DATE.TIME
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.DATE.TIME
*--------------------------------------------------------------------------------------------------------
*Description  : This routine is used to get the current system date and time
*In Parameter : N/A
*Out Parameter : N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ----------------                 ----------------         ----------------
* 18 APR 2011     Pradeep S                        PACS00054884             Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*---------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.TIME.DATE = TIMEDATE()

    Y.TIME = FIELD(Y.TIME.DATE,' ',1)
    Y.DATE = FIELD(Y.TIME.DATE,' ',2,99)

    O.DATA = Y.TIME:"*":Y.DATE

RETURN
END
