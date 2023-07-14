* @ValidationCode : MjotMTA3MzQ0NTY0MDpDcDEyNTI6MTY4MjMzMTMyMTk2MTpJVFNTOi0xOi0xOjE5NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.IDENTIFICACION
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    Y.CUS.ID = O.DATA
    Y.POS = ""
    R.PASAPORTE = ""
    R.CEDULA = ""
    R.RNC = ""
    R.ACTA = ""
    R.NUMERO.UNICO = ""
    R.IDENTIFICACION = ""

    CALL OPF(FN.CUS,FV.CUS)

    CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,FV.CUS,CUS.ERROR)


*****PASAPORTE*****

    R.PASAPORTE = R.CUS<EB.CUS.LEGAL.ID>

    IF R.PASAPORTE NE "" THEN
        O.DATA = R.PASAPORTE
        RETURN
    END

*****RNC*****

    CALL GET.LOC.REF("CUSTOMER","L.CU.RNC",Y.POS)
    R.RNC = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

    IF R.RNC NE "" THEN
        O.DATA = R.RNC
        RETURN
    END

*****CEDULA*****

    CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",Y.POS)
    R.CEDULA = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

    IF R.CEDULA NE "" THEN
        O.DATA = R.CEDULA
        RETURN
    END

*****ACTA NACIMIENTO*****

    CALL GET.LOC.REF("CUSTOMER","L.CU.ACTANAC",Y.POS)
    R.ACTA = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

    IF R.ACTA NE "" THEN
        O.DATA = R.ACTA
        RETURN
    END

*****NUMERO UNICO*****

    CALL GET.LOC.REF("CUSTOMER","L.CU.NOUNICO",Y.POS)
    R.NUMERO.UNICO = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

    IF R.NUMERO.UNICO NE "" THEN
        O.DATA = R.NUMERO.UNICO
        RETURN
    END


RETURN
