* @ValidationCode : MjotNjQ0NDc0MzI2OlVURi04OjE2ODk3NDk2NTU5OTU6SVRTUzotMTotMTotMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.OFS.INTEREST.PAID.SELECT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ACCT.CR
   $USING EB.Service

    $INSERT I_LAPAP.OFS.INTEREST.PAID.COMMON ;*R22 Auto Conversion- END

    SEL.CMD.AZ = "SELECT FBNK.AZ.ACCOUNT"
    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ,'',NO.OF.RECS,SEL.ERR.AZ)

*    CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
EB.Service.BatchBuildList('',SEL.LIST.AZ);* R22 UTILITY AUTO CONVERSION
*CALL LAPAP.OFS.INTEREST.PAID(SEL.LIST.AZ)

RETURN

END
