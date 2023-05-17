SUBROUTINE REDO.AZ.ID.SMS.CHECK
*-------------------------------------------------------------------
* Description: This ID routine is to check whether any existing record is getting modified
*              through the creation version then it will throw the error.
*-------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    IF V$FUNCTION EQ "I" THEN
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------

    FN.FILE = "F.":APPLICATION
    F.FILE  = ""
    CALL OPF(FN.FILE,F.FILE)

    Y.ID = COMI

    CALL F.READ(FN.FILE,Y.ID,R.RECORD,F.FILE,FILE.ERR)

    IF R.RECORD THEN
        E = "EB-TRANSACTION.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END

RETURN
END
