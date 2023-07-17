* @ValidationCode : MjoxNzgwNzcxODgxOkNwMTI1MjoxNjg5MjQwNzUwMTM4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:02:30
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
SUBROUTINE L.APAP.CORR.CASTIG.SEQPROT.SELECT
*-----------------------------------------------------------------------------
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to adjust the Insurance (SEGPROTFIN1) amount for the castigado prestamos.
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_L.APAP.CORR.CASTIG.SEQPROT.COMMON


    NO.RECS = ''; SEL.ERR = ''; ACCOUNT.LIST = ''
    SEL.CMD = "SELECT ":FN.AA.ACCOUNT.DETAILS:" WITH SUSPENDED EQ 'YES'"
    CALL EB.READLIST(SEL.CMD, ACCOUNT.LIST, '', NO.RECS, SEL.ERR)
    CALL BATCH.BUILD.LIST('',ACCOUNT.LIST)

RETURN
END
