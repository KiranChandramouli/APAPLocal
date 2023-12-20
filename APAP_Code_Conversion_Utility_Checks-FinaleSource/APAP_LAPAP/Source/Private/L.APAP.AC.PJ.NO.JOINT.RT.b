* @ValidationCode : MjotMzI4NzM1NjI3OkNwMTI1MjoxNzAyOTg4MzQ0NDE4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AC.PJ.NO.JOINT.RT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023        Santosh C              MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check
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
*   CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",CU.POS.1)
    EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TIPO.CL",CU.POS.1) ;*R22 Manual Code Conversion_Utility Check
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
