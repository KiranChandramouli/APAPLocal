* @ValidationCode : Mjo1NTMxMzg4NDc6Q3AxMjUyOjE2ODIwNzMyNTM1MDQ6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:04:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.AZ.RECEIPT.NO

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE           WHO               REFERENCE             DESCRIPTION

* 21-APR-2023   Conversion tool  R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V      R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;*R22 Auto conversion - END

    FN.AZ = "F.AZ.ACCOUNT"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    ID = COMI

    CALL F.READ(FN.AZ,ID,R.AZ,F.AZ,ERRZ)
    CALL GET.LOC.REF("AZ.ACCOUNT","L.AZ.RECEIPT.NO",POS)
    RECEIPT = R.AZ<AZ.LOCAL.REF,POS>


    COMI = RECEIPT

RETURN


END
