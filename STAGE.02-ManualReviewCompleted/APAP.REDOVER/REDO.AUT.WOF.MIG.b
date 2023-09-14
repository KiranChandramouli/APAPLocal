* @ValidationCode : MjotMTc5OTY0NzI2OkNwMTI1MjoxNjgwNzc1NzE5MTM2Om11dGh1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:38:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.WOF.MIG
*----------------------------------------------------
*Description: This is the input routine for WOF account creation version.
*----------------------------------------------------
*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			REFERENCE		 DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPEN.FILES:
*----------------------------------------------------

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.CONCAT.ACC.WOF = 'F.REDO.CONCAT.ACC.WOF'
    F.REDO.CONCAT.ACC.WOF  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF)


RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

    Y.DETAILS = R.NEW(AC.ACCOUNT.TITLE.2)
    Y.AA.ID   = FIELD(Y.DETAILS,'*',1)
    Y.AA.TYPE = FIELD(Y.DETAILS,'*',2)
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)

    Y.LOAN.AC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    R.REDO.CONCAT.ACC.WOF = ''
    CALL F.READU(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,CON.ERR,'R 10 10')

    IF Y.AA.TYPE EQ 'PRINCIPLE' THEN
        R.REDO.CONCAT.ACC.WOF<1> = ID.NEW
    END
    IF Y.AA.TYPE EQ 'INTEREST' THEN
        R.REDO.CONCAT.ACC.WOF<2> = ID.NEW
    END
    CALL F.WRITE(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF)
RETURN
END
