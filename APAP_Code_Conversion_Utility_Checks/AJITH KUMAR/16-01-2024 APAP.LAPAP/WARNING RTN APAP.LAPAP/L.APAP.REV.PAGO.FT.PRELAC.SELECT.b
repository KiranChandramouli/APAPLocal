* @ValidationCode : MjotMTgxNjYyODM2NTpDcDEyNTI6MTY5MDE2NzUzNTEyNjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:55
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
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.REV.PAGO.FT.PRELAC.SELECT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.REV.PAGO.FT.PRELAC.COMMON
   $USING EB.Service
    GOSUB PROCESS

RETURN

PROCESS:
********
    SEL.CMD = '' ; SEL.LIST = '' ; NO.OF.REC = '' ; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.ST.L.APAP.PRELACION.COVID19.DET
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN

END
