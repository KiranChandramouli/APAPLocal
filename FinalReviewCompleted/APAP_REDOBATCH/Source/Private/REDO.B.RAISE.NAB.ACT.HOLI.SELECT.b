* @ValidationCode : MjoxMTgxNTIwMTkwOkNwMTI1MjoxNjg0ODU0Mzk0OTY3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.RAISE.NAB.ACT.HOLI.SELECT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 12-04-2023        CONVERSTION TOOL     R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.RAISE.NAB.ACT.HOLI.COMMON

    SLEEP 60

    SEL.CMD = 'SELECT ':FN.REDO.AA.NAB.HISTORY:' WITH MARK.HOLIDAY EQ "YES" AND ACCT.YES.NO EQ "YES" AND STATUS EQ "STARTED" '
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
