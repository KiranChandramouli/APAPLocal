$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.LOAN.NUMBER
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - = to EQ and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ALTERNATE.ACCOUNT

    Y.TC.NUMBER = COMI

*PARA ABRIR EL ACHIVO DE ALTERNATE.ACCOUNT
    FN.AAC = "F.ALTERNATE.ACCOUNT"
    FV.AAC = ""
    RS.AAC = ""
    AAC.ERR = ""

    IF Y.TC.NUMBER EQ '' THEN
        RETURN
    END

    FINDSTR "*" IN Y.TC.NUMBER SETTING Ap, Vp THEN
        RETURN
    END ELSE

*PARA ABRIR EL ACHIVO DE ALTERNATE.ACCOUNT
        FN.AAC = "F.ALTERNATE.ACCOUNT"
        FV.AAC = ""
        RS.AAC = ""
        AAC.ERR = ""

        CALL OPF(FN.AAC, FV.AAC)
        CALL F.READ(FN.AAC, Y.TC.NUMBER, RS.AAC, FV.AAC, AAC.ERR)

        R.NEW(1) = RS.AAC<AAC.GLOBUS.ACCT.NUMBER>

        COMI = RS.AAC<AAC.GLOBUS.ACCT.NUMBER>
        CALL REDO.V.VAL.COLLECT.AA

        COMI = SUBSTRINGS(Y.TC.NUMBER,0,6) : "******" : SUBSTRINGS(Y.TC.NUMBER,13,4)
        R.NEW(1) = RS.AAC<AAC.GLOBUS.ACCT.NUMBER>

        RETURN
    END
END
