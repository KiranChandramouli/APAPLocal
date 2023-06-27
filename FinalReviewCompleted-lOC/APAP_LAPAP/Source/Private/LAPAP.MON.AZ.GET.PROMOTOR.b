* @ValidationCode : MjoxMjAxNTkxMTA4OkNwMTI1MjoxNjg0MjIyODExNzE2OklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:11
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
SUBROUTINE LAPAP.MON.AZ.GET.PROMOTOR

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP removed in INSERT file
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END


    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ID = COMI

    CALL F.READ(FN.ACC,ID,R.ACC,F.ACC,ERRCC)
    PROMOTOR = R.ACC<AC.ACCOUNT.OFFICER>

    COMI = PROMOTOR

RETURN

END
