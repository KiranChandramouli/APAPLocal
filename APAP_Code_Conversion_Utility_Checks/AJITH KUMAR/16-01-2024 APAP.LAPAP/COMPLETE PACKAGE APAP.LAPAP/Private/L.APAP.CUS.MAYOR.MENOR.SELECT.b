* @ValidationCode : Mjo0MDkwOTM4NDU6Q3AxMjUyOjE2OTAxNjc1MjkzMDc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUS.MAYOR.MENOR.SELECT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON                              ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.CUS.MAYOR.MENOR.COMMON        ;*R22 Auto conversion - End
   $USING EB.Service

    SELECT.STATEMENT = "SELECT ":FN.CUSTOMER
    CUSTOMER.LIST = ""
    LIST.NAME = ""
    SELECTED = ""
    SYSTEM.RETURN.CODE = ""
    CALL EB.READLIST(SELECT.STATEMENT,CUSTOMER.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
*    CALL BATCH.BUILD.LIST('',CUSTOMER.LIST)
EB.Service.BatchBuildList('',CUSTOMER.LIST);* R22 UTILITY AUTO CONVERSION


END
