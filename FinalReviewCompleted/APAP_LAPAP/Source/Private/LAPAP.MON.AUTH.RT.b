* @ValidationCode : MjotMTQ0NjQzMjQ1NDpDcDEyNTI6MTY4NDIyMjgxMTU2NjpJVFNTOi0xOi0xOjE3NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 176
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
