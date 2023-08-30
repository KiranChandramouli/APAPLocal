* @ValidationCode : MjotMTcwNDIwNjU5NTpDcDEyNTI6MTY4MjA3NzYzMDk2MzpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:17:10
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
SUBROUTINE LAPAP.MON.VERIFY.ACC.TYPE
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE           DESCRIPTION

* 21-APR-2023  Conversion tool  R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V     R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END

    ACC = COMI
    CALL LAPAP.VERIFY.ACC(ACC,RES)
    COMI = RES

RETURN

END
