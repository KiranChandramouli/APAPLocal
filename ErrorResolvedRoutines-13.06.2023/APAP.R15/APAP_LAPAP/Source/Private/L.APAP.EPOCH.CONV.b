* @ValidationCode : MjoxNDY5MjY3NTc2OkNwMTI1MjoxNjgyMzMxMzIyMjI1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.EPOCH.CONV
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion

    Y.DATETIME =O.DATA
    Y.FECHA.LEIBLE = OCONV(ICONV(Y.DATETIME[1,6],"D2/"),'D4Y'):Y.DATETIME[3,4]
    O.DATA = Y.FECHA.LEIBLE

RETURN
END
