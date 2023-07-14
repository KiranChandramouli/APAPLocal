* @ValidationCode : Mjo0MDkwOTM4NDU6Q3AxMjUyOjE2ODkyNDIyNzExMTU6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:27:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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

    SELECT.STATEMENT = "SELECT ":FN.CUSTOMER
    CUSTOMER.LIST = ""
    LIST.NAME = ""
    SELECTED = ""
    SYSTEM.RETURN.CODE = ""
    CALL EB.READLIST(SELECT.STATEMENT,CUSTOMER.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    CALL BATCH.BUILD.LIST('',CUSTOMER.LIST)


END
