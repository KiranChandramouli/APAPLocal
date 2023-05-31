$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.IVR.VALLOCAL(REC.IDS)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUST.DOCUMENT


    LOCATE "APPLN.TXN.REF" IN D.FIELDS<1> SETTING Y.AGENCY.POS  THEN
        Y.CUST.DOC= D.RANGE.AND.VALUE<Y.AGENCY.POS>
*        CHANGE SM TO ' ' IN Y.AGENCY.VAL
    END


    IF Y.CUST.DOC EQ '' THEN

        REC.IDS=3
        RETURN
    END


    Y.CUST.DOC=Y.CUST.DOC : '*ACTDATOS'



    FN.CUST.DOCUMENT='F.CUST.DOCUMENT'
    F.CUST.DOCUMENT=''
    CALL OPF(FN.CUST.DOCUMENT,F.CUST.DOCUMENT)
    R.CUST.DOCUMENT=''
    CALL F.READ(FN.CUST.DOCUMENT,Y.CUST.DOC,R.CUST.DOCUMENT,F.CUST.DOCUMENT,ACC.ERR)


    IF R.CUST.DOCUMENT THEN

        REC.IDS=2

    END ELSE
        REC.IDS=1

    END




RETURN

END
