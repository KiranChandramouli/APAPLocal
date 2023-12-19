$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.FREQ.DATE
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.STATEMENT
    $INSERT I_F.AZ.ACCOUNT


    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.ACCOUNT.STATEMENT = 'F.ACCOUNT.STATEMENT'
    F.ACCOUNT.STATEMENT  = ''
    CALL OPF(FN.ACCOUNT.STATEMENT,F.ACCOUNT.STATEMENT)
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    Y.VALUE.DATE = ""
RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~


    IF O.DATA THEN
        CALL F.READ(FN.ACCOUNT.STATEMENT,O.DATA,R.ACCOUNT.STATEMENT,F.ACCOUNT.STATEMENT,E.ACCOUNT.STATEMENT)
        Y.VALUE.DATE = R.ACCOUNT.STATEMENT<AC.STA.FQU1.LAST.DATE>
        IF NOT(Y.VALUE.DATE) THEN
            CALL F.READ(FN.AZ.ACCOUNT,O.DATA,R.AZ.ACCOUNT,F.AZ.ACCOUNT,E.AZ.ACCOUNT)
            Y.VALUE.DATE =  R.AZ.ACCOUNT<AZ.VALUE.DATE>
        END
        O.DATA = Y.VALUE.DATE
    END
RETURN
*-------------------------------------------------------------------------
END
