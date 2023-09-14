* @ValidationCode : MjoxMTUwNDQxMzc1OkNwMTI1MjoxNjgxMjc4NzA3MDg4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:21:47
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
SUBROUTINE REDO.B.NCF.ASSIGN.ADV.SELECT

*DESCRIPTION:
*------------
*This Routine will select arrangements to generate NCF for the remaining amount
*in advance payment
* Input/Output:
*--------------
* IN  : -NA-
* OUT : VAR.SEL.AA.LIST
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_REDO.B.NCF.ASSIGN.ADV.COMMON

    VAR.ACTIVITY.SELECT.LIST="SELECT ": FN.AA.SCHEDULED.ACTIVITY
    CALL EB.READLIST(VAR.ACTIVITY.SELECT.LIST,VAR.ACTIVITY.LIST,'',NO.OF.REC,ERR)
    LOOP
        REMOVE VAR.AA.ARRANGEMENT.ID FROM  VAR.ACTIVITY.LIST SETTING POS
    WHILE VAR.AA.ARRANGEMENT.ID:POS
        CALL F.READ(FN.AA.SCHEDULED.ACTIVITY,VAR.AA.ARRANGEMENT.ID,R.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY,SCHEDULE.ERR)
        Y.ACTIVITY.NAME.ARRAY=R.SCHEDULED.ACTIVITY<AA.SCH.ACTIVITY.NAME>
        Y.ACTIVITY.NAME.ARRAY=CHANGE(Y.ACTIVITY.NAME.ARRAY,@VM,@FM)
        LOCATE "LENDING-MAKEDUE-REPAYMENT.SCHEDULE" IN Y.ACTIVITY.NAME.ARRAY SETTING DATE.POS THEN
            Y.NEXT.DATE=R.SCHEDULED.ACTIVITY<AA.SCH.LAST.DATE,DATE.POS>
            CALL F.READ(FN.REDO.AA.REPAY,VAR.AA.ARRANGEMENT.ID,R.REDO.AA.REPAY,F.REDO.AA.REPAY,ERR)
            IF Y.NEXT.DATE EQ TODAY AND R.REDO.AA.REPAY NE '' THEN
                Y.NEXT.DATE=R.SCHEDULED.ACTIVITY<AA.SCH.NEXT.DATE,DATE.POS>
                VAR.SEL.AA.LIST<-1>=VAR.AA.ARRANGEMENT.ID
            END
        END
    REPEAT
    CALL BATCH.BUILD.LIST('',VAR.SEL.AA.LIST)
RETURN
END
