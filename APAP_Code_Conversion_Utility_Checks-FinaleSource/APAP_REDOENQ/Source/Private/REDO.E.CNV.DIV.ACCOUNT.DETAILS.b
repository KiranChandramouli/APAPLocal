$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.DIV.ACCOUNT.DETAILS
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.DIV.ACCOUNT.DETAILS
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display header of REDO.APAP.INVST.AMT.ENQ
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.APAP.INVST.AMT.ENQ
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  01-12-2010       Sakthi Sellappillai            ODR-2010-03-0132            Initial Creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - SM to @SM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
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
    Y.CLASSIFICATION = ''
    Y.TIME = ''
*Y.TIME = OCONV(TIME(), "MTS")
    Y.CLOSE.MONTH = ''
    Y.CLOSE.LEN = ''
    Y.M1 = ''
    Y.M2 = ''
    Y.AGENCY = ''
    Y.INVST.TYPE = ''

*    LOCATE "DATE.RANGE" IN ENQ.SELECTION<2,1> SETTING Y.CNV.DATE.VAL.POS THEN
    LOCATE "CLOSE.MONTH" IN ENQ.SELECTION<2,1> SETTING Y.CNV.DATE.VAL.POS THEN
        Y.CLOSE.MONTH = ENQ.SELECTION<4,Y.CNV.DATE.VAL.POS>
    END
    LOCATE "AGENCY" IN ENQ.SELECTION<2,1> SETTING Y.CNV.AGENCY.VAL.POS THEN
        Y.AGENCY = ENQ.SELECTION<4,Y.CNV.AGENCY.VAL.POS>
    END
    LOCATE "INVESTMENT.TYPE" IN ENQ.SELECTION<2,1> SETTING Y.CNV.INVEST.TYPE.VAL.POS THEN
        Y.INVST.TYPE = ENQ.SELECTION<4,Y.CNV.INVEST.TYPE.VAL.POS>
    END

    IF Y.CLOSE.MONTH THEN
        CHANGE " " TO @SM IN Y.CLOSE.MONTH
        Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
        IF Y.CLOSE.LEN EQ 17 THEN
            Y.M1 = FIELD(Y.CLOSE.MONTH,@SM,1)
            Y.M2 = FIELD(Y.CLOSE.MONTH,@SM,2)
        END
        Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
        IF Y.CLOSE.LEN EQ 8 THEN
            Y.M1 = Y.CLOSE.MONTH
            Y.M2 = ''
        END
        IF Y.M1 THEN
            Y.FROM.MONTH = Y.M1
            Y.FROM.MONTH=OCONV(Y.FROM.MONTH,'DI')
            Y.FROM.MONTH=OCONV(Y.FROM.MONTH,'D4')
        END
        IF Y.M2 THEN
            Y.TO.MONTH = Y.M2
            Y.TO.MONTH=OCONV(Y.TO.MONTH,'DI')
            Y.TO.MONTH=OCONV(Y.TO.MONTH,'D4')
        END

        IF Y.M2 EQ '' THEN
            Y.CLASSIFICATION = Y.FROM.MONTH
        END ELSE
            Y.CLASSIFICATION = Y.FROM.MONTH:' - ':Y.TO.MONTH
        END
    END

    IF Y.AGENCY THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':Y.AGENCY
        END ELSE
            Y.CLASSIFICATION = Y.AGENCY
        END
    END

    IF Y.INVST.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':Y.INVST.TYPE
        END ELSE
            Y.CLASSIFICATION = Y.INVST.TYPE
        END
    END
    IF Y.CLOSE.MONTH  EQ '' AND Y.AGENCY EQ '' AND Y.INVST.TYPE EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END
    IF Y.CLASSIFICATION  THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END
RETURN
END
