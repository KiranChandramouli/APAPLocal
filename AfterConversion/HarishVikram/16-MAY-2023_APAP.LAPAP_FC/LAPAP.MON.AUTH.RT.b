* @ValidationCode : MjotMTQ0NjQzMjQ1NDpDcDEyNTI6MTY4MjA3MjM4MDM4ODpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:49:40
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
SUBROUTINE LAPAP.MON.AUTH.RT

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END


    GOSUB INIT
    GOSUB INITb
    GOSUB PROCESS
    GOSUB END_PROCESS


INIT:
*----

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""

    ACC.NUM = COMI
    CALL OPF(FN.ACC,F.ACC)

    Y.AUTHORISER = ''

RETURN

INITb:
*----

    CALL F.READ(FN.ACC,ACC.NUM,R.ACC,F.ACC,ACC.ERR)

RETURN


PROCESS:
*-------
    Y.AUTHORISER = R.ACC<AC.AUTHORISER>


RETURN


END_PROCESS:
*---------------


    COMI = FIELD(Y.AUTHORISER, "_", 2)

RETURN


END
