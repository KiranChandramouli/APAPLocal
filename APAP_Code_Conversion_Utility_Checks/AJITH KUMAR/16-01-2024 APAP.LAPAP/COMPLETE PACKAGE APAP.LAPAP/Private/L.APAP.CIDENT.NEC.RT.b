* @ValidationCode : MjotMTM1OTkwMzExOTpDcDEyNTI6MTY4MjMzMTMyMDE0OTpJVFNTOi0xOi0xOjkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 93
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CIDENT.NEC.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END
   $USING EB.LocalReferences

**---------------------------------------------------------------------------------------------
**VARIABLES
    Y.CU.ID = ""
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""

**---------------------------------------------------------------------------------------------
**ASIGNACION
    Y.CU.ID = O.DATA
**DEBUG
**---------------------------------------------------------------------------------------------
**PRIMERO LEO DESDE LA TABLA CUSTOMER
    CALL F.READ(FN.CUS,Y.CU.ID,R.CUS, FV.CUS, CUS.ERR)

*    CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
EB.LocalReferences.GetLocRef("CUSTOMER", "L.CU.CIDENT",CUS.POS);* R22 UTILITY AUTO CONVERSION
    Y.CUS.CIDENT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>

    Y.IDENTIFICACION = "NeC"
**DEBUG
    IF Y.CUS.CIDENT NE "" THEN
        Y.IDENTIFICACION = Y.CUS.CIDENT
    END
**DEBUG
    O.DATA = Y.IDENTIFICACION

RETURN

END
