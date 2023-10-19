$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.AZ.ACCOUNT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  -  Added IF E EQ "EB-UNKNOWN.VARIABLE"
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                              
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    Y.DATA = O.DATA
    ACCT.ID = System.getVariable("CURRENT.ACCT.NO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE"
        ACCT.ID = ""
    END
    IF Y.DATA NE ACCT.ID THEN
        O.DATA = ACCT.ID
    END
RETURN
END
