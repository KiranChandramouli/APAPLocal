* @ValidationCode : MjozOTMyODQxMjg6Q3AxMjUyOjE2ODEyNzg0NDc4MzA6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:17:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NAB.ACCT.BK.DT.LOANS.SELECT

*--------------------------------------------------------
*Description: This is SELECT routine of the batch REDO.B.NEW.NAB.ACCOUNTING to create
* and raise the accounting entries for NAB accounting
*--------------------------------------------------------
*Input Arg  : N/A
*Out   Arg  : N/A
*Deals With : NAB Accounting
*--------------------------------------------------------
* Date           Name        Dev Ref.                         Comments
* 16 Oct 2012   H Ganesh     NAB Accounting-PACS00202156     Initial Draft
*Modification
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.NAB.ACCT.BK.DT.LOANS.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------


    Y.DATE = TODAY
    Y.LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

    DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

    DATE.DIFF = DATE.DIFF<4>

* IF DATE.DIFF GT 1 THEN


    SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND ACCT.YES.NO EQ 'YES' AND BACK.DATED.LN EQ 'YES' AND MARK.HOLIDAY NE 'YES' "

* END ELSE

*     SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND NAB.CHANGE.DATE EQ ":Y.DATE

* END

    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)


RETURN
END
