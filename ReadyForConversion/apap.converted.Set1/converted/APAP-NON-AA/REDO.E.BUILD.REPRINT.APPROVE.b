SUBROUTINE REDO.E.BUILD.REPRINT.APPROVE(ENQ.DATA)
*---------------------------------------------------------------------------
*---------------------------------------------------------------------------
*Description       : This routine is a build routine to display the given AZ Account number deal slip is available or no
*Linked With       :
*Linked File       :
*--------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    FN.DEP.REPRINT = 'F.REDO.DEP.REPRINT.DETAILS'
    F.DEP.REPRINT = ''
    CALL OPF(FN.DEP.REPRINT,F.DEP.REPRINT)

    LOCATE "@ID" IN ENQ.DATA<2,1> SETTING POS1 THEN
        VAR.AZ.ID =  ENQ.DATA<4,POS1>
    END


    CALL F.READ(FN.DEP.REPRINT,VAR.AZ.ID,R.DEP.REPRINT,F.DEP.REPRINT,DEP.ERR)

    IF NOT(R.DEP.REPRINT) THEN
        ENQ.ERROR = 'EB-AZ.NOT.PRINT'
        CALL STORE.END.ERROR
    END
RETURN
END
