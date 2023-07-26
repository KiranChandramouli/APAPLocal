* @ValidationCode : Mjo4NDgyNzMxMzU6Q3AxMjUyOjE2OTAzNTA3MTI2Njg6dmljdG86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Jul 2023 11:21:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*26-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.CANT.REL.AC
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON ;*R22 MANUAL CONVERSION END


    Y.ACC.ID = O.DATA
    Y.CUS.ID = ""
    Y.RELACION.CODE = ""
    Y.JOINT.HOLDER = ""
    Y.CADENA = ""

    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""

    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""

    CALL OPF(FN.ACC,FV.ACC)

    CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERROR)
    Y.CUS.ID = R.ACC<AC.CUSTOMER>

    Y.CANT.RELACIONES = R.ACC<AC.JOINT.HOLDER>
    Y.CNT = DCOUNT(Y.CANT.RELACIONES,@VM)

    O.DATA = Y.CNT

RETURN
