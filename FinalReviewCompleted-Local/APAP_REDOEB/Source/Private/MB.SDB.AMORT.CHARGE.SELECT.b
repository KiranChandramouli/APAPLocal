* @ValidationCode : MjotMTQ3MjEwNjE2MzpDcDEyNTI6MTY4MTM4NDQzNDkwNTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:54
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
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.AMORT.CHARGE.SELECT

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE GLOBUS.BP I_F.DATES
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.PARAM
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.TYPE
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.CHARGES
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.STATUS
*    $INCLUDE CAPLATFORM.BP I_MB.SDB.AMORT.CHARGE.COMMON

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_MB.SDB.AMORT.CHARGE.COMMON        ;*/ TUS END

    SDB.LIST = ''; SDB.COUNT = ''; SDB.ERROR = ''
    SDB.SELECT = "SELECT ":FN.MB.SDB.STATUS:" WITH AMORT.Y.N EQ 'Y' AND STATUS EQ 'RENTED' BY @ID"
    CALL EB.READLIST(SDB.SELECT, SDB.LIST, '', SDB.COUNT, SDB.ERROR)

    CALL BATCH.BUILD.LIST('', SDB.LIST)

RETURN

END
