$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.LOAN.DETAILS
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.LOAN.DETAILS
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.NOF.LOAN.SUM
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  08-11-2010       Sakthi Sellappillai            ODR-2010-03-0124            Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------------------------------
********
PROCESS:
********
    Y.CNV.DATE.VALUE = ''
    LOCATE "DATE" IN ENQ.SELECTION<2,1> SETTING Y.CNV.DATE.VAL.POS THEN
        Y.CNV.DATE.VALUE = ENQ.SELECTION<4,Y.CNV.DATE.VAL.POS>
    END

    Y.CNV.LOAN.STATUS = ''
    LOCATE "LOAN.STATUS" IN ENQ.SELECTION<2,1> SETTING Y.CNV.LOAN.STATUS.POS THEN
        Y.CNV.LOAN.STATUS = ENQ.SELECTION<4,Y.CNV.LOAN.STATUS.POS>
    END
    Y.CNV.LOAN.NUMBER = ''
    LOCATE "LOAN.NUMBER" IN ENQ.SELECTION<2,1> SETTING Y.CNV.LOAN.NUMBER.POS THEN
        Y.CNV.LOAN.NUMBER = ENQ.SELECTION<4,Y.CNV.LOAN.NUMBER.POS>
    END
    IF Y.CNV.DATE.VALUE EQ '' THEN
        Y.CNV.DATE.VALUE = 'ALL'
    END ELSE
        Y.CNV.DATE.VALUE=OCONV(Y.CNV.DATE.VALUE,'DI')
        Y.CNV.DATE.VALUE=OCONV(Y.CNV.DATE.VALUE,'D4')
    END
    IF  Y.CNV.LOAN.STATUS EQ '' THEN
        Y.CNV.LOAN.STATUS ='ALL'
    END
    IF  Y.CNV.LOAN.NUMBER EQ '' THEN
        Y.CNV.LOAN.NUMBER = 'ALL'
    END
    IF Y.CNV.DATE.VALUE NE '' AND Y.CNV.LOAN.STATUS NE '' AND Y.CNV.LOAN.NUMBER NE '' THEN
        O.DATA = Y.CNV.DATE.VALUE:"~":Y.CNV.LOAN.STATUS:"~":Y.CNV.LOAN.NUMBER
    END
RETURN
END
