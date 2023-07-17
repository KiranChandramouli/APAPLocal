$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.LETTER.ISSUE.ENQ.INVOKE.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.LETTER.ISSUE

    Y.RECORD.ID = ID.NEW
    Y.LETTER = R.NEW(REDO.LET.ISS.TYPE.OF.LETTER)

    IF Y.LETTER EQ "CONSULAR" THEN
        NEW.TASK = "ENQ L.APAP.CONSULAR.PDF.GEN LETTER.ISSUE.ID EQ " : Y.RECORD.ID
        CALL EB.SET.NEW.TASK(NEW.TASK)
    END

    IF Y.LETTER EQ "INDIVIDUAL" THEN
        NEW.TASK = "ENQ L.APAP.INDIVIDUAL.REF.PDF.GEN LETTER.ISSUE.ID EQ " : Y.RECORD.ID
        CALL EB.SET.NEW.TASK(NEW.TASK)
    END



END
