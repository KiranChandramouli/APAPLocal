* @ValidationCode : MjoxNDI5MTk2NzU3OlVURi04OjE3MDI2MjM3MjQ2NTI6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Dec 2023 12:32:04
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
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.AMORT.CHARGE.SELECT

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 15-12-2023      Narmadha V        Manual R22 Conversion      Call Routine Modified
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
    $USING EB.Service

    SDB.LIST = ''; SDB.COUNT = ''; SDB.ERROR = ''
    SDB.SELECT = "SELECT ":FN.MB.SDB.STATUS:" WITH AMORT.Y.N EQ 'Y' AND STATUS EQ 'RENTED' BY @ID"
    CALL EB.READLIST(SDB.SELECT, SDB.LIST, '', SDB.COUNT, SDB.ERROR)

*CALL BATCH.BUILD.LIST('', SDB.LIST)
    EB.Service.BatchBuildList('', SDB.LIST) ;*Manaul R22 Conversion - Call Routine Modified.

RETURN

END
