* @ValidationCode : Mjo4NDgyNzMxMzU6Q3AxMjUyOjE2OTA0MzQwODU3NDI6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Jul 2023 10:31:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
