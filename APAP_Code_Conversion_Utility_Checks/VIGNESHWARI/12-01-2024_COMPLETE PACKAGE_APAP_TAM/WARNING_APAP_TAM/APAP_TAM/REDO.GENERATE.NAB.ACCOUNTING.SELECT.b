* @ValidationCode : MjotMTYzMDk0MTE4MzpDcDEyNTI6MTcwNDk3Mjk1NzEyNTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 17:05:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GENERATE.NAB.ACCOUNTING.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will select the Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with STATUS is STARTED.
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------

*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GENERATE.NAB.ACCOUNTING.COMMON
    $INSERT I_F.DATES
   $USING EB.Service

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

    Y.DATE = TODAY
    Y.LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

    DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

    DATE.DIFF = DATE.DIFF<4>

    IF DATE.DIFF GT 1 THEN

        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND NAB.CHANGE.DATE GT":Y.LAST.WORK.DATE

    END ELSE

        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND NAB.CHANGE.DATE EQ ":Y.DATE

    END

    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

*    CALL BATCH.BUILD.LIST('', SEL.LIST)
EB.Service.BatchBuildList('', SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
*------------------------------------------------------------------------------------------------------------------
END
