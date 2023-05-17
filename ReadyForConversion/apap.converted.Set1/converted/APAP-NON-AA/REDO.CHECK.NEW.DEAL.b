SUBROUTINE REDO.CHECK.NEW.DEAL
*********************************************************************************************************
**Description      : New record not allowed
*Linked With       : APAP.H.GARNISH.DETAILS
*In  Parameter     : N.A
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 13 JUN 2010       Prabhu N                 B88                         ERROR ON MODIFICATION
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    FN.APAP.H.GARNISH.DETAILS='F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS=''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)


    CALL F.READ(FN.APAP.H.GARNISH.DETAILS,ID.NEW,R.GAR.REC,F.APAP.H.GARNISH.DETAILS,ERR)
    IF ERR AND V$FUNCTION EQ 'I' THEN
        E='EB-REDO.NO.NEW'
        CALL STORE.END.ERROR
    END

RETURN
END
