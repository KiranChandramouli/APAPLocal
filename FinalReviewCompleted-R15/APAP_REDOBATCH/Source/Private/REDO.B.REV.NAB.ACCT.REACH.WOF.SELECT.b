* @ValidationCode : MjoxNzMwOTU5MTYwOkNwMTI1MjoxNjg0ODU0Mzk2MTI0OklUU1M6LTE6LTE6LTExOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REV.NAB.ACCT.REACH.WOF.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.REV.NAB.ACCT.REACH.WOF.SELECT
*-----------------------------------------------------------------
* Description : This routine is used to reverse contingent cus a/c and internal ac
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      23-OCT-2011          WOF ACCOUTING - PACS00202156
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.REV.NAB.ACCT.REACH.WOF.COMMON
    $INSERT I_F.DATES

MAIN:


    Y.DATE = TODAY
    Y.LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.LS.DATE = TODAY - 1

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

    DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

    DATE.DIFF = DATE.DIFF<4>

*    IF DATE.DIFF GT 1 THEN

    SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.DATE

*    END ELSE

*        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.LS.DATE

*    END
*    DEBUG

    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)


RETURN

END
