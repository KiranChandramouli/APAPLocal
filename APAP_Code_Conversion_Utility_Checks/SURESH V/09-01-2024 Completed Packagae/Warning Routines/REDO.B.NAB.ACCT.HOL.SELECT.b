* @ValidationCode : MjotMTUzMzA5NTg2MDpDcDEyNTI6MTcwNDM2ODQzMzg3OTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:10:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.NAB.ACCT.HOL.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.NAB.ACCT.HOL.COMMON
    $INSERT I_F.DATES
    $USING EB.Service
 

    Y.NEX.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SEL.CMD = 'SELECT ':FN.REDO.AA.NAB.HISTORY:' WITH NAB.CHANGE.DATE GT ':TODAY:' AND NAB.CHANGE.DATE LT ':Y.NEX.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

*CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 AUTO CONVERSION

RETURN

END
