* @ValidationCode : Mjo0NDY3ODEyNTg6Q3AxMjUyOjE2ODIzMzEzMjA4ODg6SVRTUzotMTotMTotMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUS.PEP.MANDATORY.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END
   $USING EB.LocalReferences


    P.L_CU_PEPS = ""
    P.L_CUS_PEP = ""

*    CALL GET.LOC.REF("CUSTOMER","L.CU.PEPS",FT.POS.1)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.PEPS",FT.POS.1);* R22 UTILITY AUTO CONVERSION
    P.L_CU_PEPS = R.NEW(LOCAL.REF.FIELD)<1,FT.POS.1>
*    CALL GET.LOC.REF("CUSTOMER","L.CUS.PEP",FT.POS.2)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CUS.PEP",FT.POS.2);* R22 UTILITY AUTO CONVERSION
    P.L_CUS_PEP = R.NEW(LOCAL.REF.FIELD)<1,FT.POS.2>

    IF P.L_CU_PEPS EQ "SI" THEN
        IF P.L_CUS_PEP NE "D" AND P.L_CUS_PEP NE "V" THEN
            MESSAGE = 'CAMPO: TIPO PEP, REQUERIDO PARA PERSONAS MARCADAS COMO PEP.'
            E = MESSAGE
*CALL STORE.END.ERROR
            ETEXT = E
            CALL ERR
        END
    END

RETURN

END
