* @ValidationCode : MjotMzEwMDI2ODg1OkNwMTI1MjoxNjg0ODU0MzkzNDcxOklUU1M6LTE6LTE6MTk1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NAB.ACCT.HOL(Y.ID)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.DATES
    $INSERT I_F.REDO.AA.NAB.HISTORY
    $INSERT I_REDO.B.NAB.ACCT.HOL.COMMON
    $INSERT I_F.AA.ARRANGEMENT

MAIN:


    CALL F.READ(FN.REDO.AA.NAB.HISTORY,Y.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,HIS.ERR)
    Y.NAB.CHNGE.DATE = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.NAB.CHANGE.DATE>

    CALL AWD('',Y.NAB.CHNGE.DATE,DAYTYPE)

    IF DAYTYPE EQ 'H' THEN
        R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.MARK.HOLIDAY> = 'YES'
        CALL F.WRITE(FN.REDO.AA.NAB.HISTORY,Y.ID,R.REDO.AA.NAB.HISTORY)
    END

RETURN

END
