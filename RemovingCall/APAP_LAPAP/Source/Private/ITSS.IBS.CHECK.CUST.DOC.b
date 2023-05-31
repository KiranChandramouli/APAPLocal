$PACKAGE APAP.LAPAP
SUBROUTINE ITSS.IBS.CHECK.CUST.DOC(Y.DATA,RESPONSE.PARAM)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------	

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUST.DOCUMENT
    Y.CUSTOMER.ID = Y.DATA

    FN.CUST.DOCUMENT = "F.CUST.DOCUMENT"
    F.CUST.DOCUMENT = ""

    CALL OPF(FN.CUST.DOCUMENT,F.CUST.DOCUMENT)

    Y.ID=Y.CUSTOMER.ID:"*ACTDATOS"

    READ R.CUST.DOCUMENT FROM F.CUST.DOCUMENT, Y.ID  ELSE
        Y.ERROR = "RECORD MISSING"
    END

    Y.STATUS = R.CUST.DOCUMENT<CUS.DOC.STATUS>

    IF Y.STATUS NE "1" AND Y.STATUS NE "" THEN
        RESPONSE.PARAM= "NO"
    END

    RESPONSE.PARAM ="YES"

RETURN
