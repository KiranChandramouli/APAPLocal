SUBROUTINE REDO.E.CNV.TRIM.AMT
****************************************************
*Company Name: Asociacion Popular de Ahorros y Prestamos
*Program Name: REDO.E.CNV.TRIM.AMT
************************************************************
*Description: This conversion routine returns absolute value
************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*   04/05/2011       Pradeep S       PACS00056287            Initial Creation
*******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*Process Para:
***************

    Y.AMT = O.DATA
    Y.AMT = TRIM(Y.AMT," ","B")
    O.DATA = Y.AMT

RETURN
END
