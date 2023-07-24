$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AC.PJ.NO.JOINT.RT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
*--------------------------------------------------------------------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)
*--------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
    P.CUSTOMER = ""
    P.JOINT.HOLDER = ""
    T.L.CU.TIPO.CL = ""
*--------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
    P.CUSTOMER = R.NEW(AC.CUSTOMER)
    P.JOINT.HOLDER = R.NEW(AC.JOINT.HOLDER)
*--------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS,P.CUSTOMER,R.CUS, FV.CUS, CUS.ERR)
    CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",CU.POS.1)
    T.L.CU.TIPO.CL = R.CUS<EB.CUS.LOCAL.REF,CU.POS.1>
*--------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
    IF T.L.CU.TIPO.CL EQ "PERSONA JURIDICA" THEN
        IF P.JOINT.HOLDER NE "" THEN
            EXT_MSG = "."
            ETEXT = 'CUENTA P. JURIDICA- NO PERMITE RELACIONAR CLIENTE' : EXT_MSG
            CALL STORE.END.ERROR
        END

    END


RETURN

END
