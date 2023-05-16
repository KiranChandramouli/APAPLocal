* @ValidationCode : MjotNzM2NzEzMTQ3OlVURi04OjE2ODIzMTI1OTEyNTU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 10:33:11
* @ValidationInfo : Encoding          : UTF-8
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

SUBROUTINE LAPAP.REMOVER.COMMA.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO                 REFERENCE           DESCRIPTION

* 24-APR-2023   Conversion tool   R22 Auto conversion     BP is removed in Insert File
* 24-APR-2023   Narmadha V        R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

    Y.VALOR = O.DATA

    Y.VALOR = EREPLACE(Y.VALOR,',','')

    O.DATA = Y.VALOR

RETURN

END
