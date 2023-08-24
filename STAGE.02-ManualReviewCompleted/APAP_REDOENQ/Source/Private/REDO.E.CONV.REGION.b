$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.REGION
*****************************************************************************
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRISTAMOS
*Program Name : REDO.E.CONV.REGION
******************************************************************************
*Description: This conversion routine used to fetch the data from right to left
********************************************************************************

*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*    23 SEP 2010   MD Preethi       0DR-2010-03-131          Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*********************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    Y.REGION = O.DATA

    IF LEN(Y.REGION) LT 8 THEN
        Y.REGION = ""
    END ELSE
        Y.REGION = Y.REGION[8]
        Y.REGION = Y.REGION[1,2]
    END
    O.DATA = Y.REGION
RETURN
END
