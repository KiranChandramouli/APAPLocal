* @ValidationCode : MjotMTQxNzEwNjc4OkNwMTI1MjoxNzA0MzY4NDE2NDg1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:10:16
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
SUBROUTINE REDO.B.NAB.ACCT.HOL(Y.ID)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 AUTO Conversion Change F.READ to F.READU
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


*CALL F.READ(FN.REDO.AA.NAB.HISTORY,Y.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,HIS.ERR)
    CALL F.READU(FN.REDO.AA.NAB.HISTORY,Y.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,HIS.ERR,'');* R22 AUTO CONVERSION
    Y.NAB.CHNGE.DATE = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.NAB.CHANGE.DATE>

    CALL AWD('',Y.NAB.CHNGE.DATE,DAYTYPE)

    IF DAYTYPE EQ 'H' THEN
        R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.MARK.HOLIDAY> = 'YES'
        CALL F.WRITE(FN.REDO.AA.NAB.HISTORY,Y.ID,R.REDO.AA.NAB.HISTORY)
    END

RETURN

END
