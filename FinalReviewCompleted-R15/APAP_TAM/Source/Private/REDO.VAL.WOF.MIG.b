* @ValidationCode : MjotMTQxNjE5ODI4MzpDcDEyNTI6MTY4MTE1MTYxODY5NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:38
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.WOF.MIG
*----------------------------------------------------
*Description: This is the input routine for WOF account creation version.
*----------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------



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

    R.AA.ARRANGEMENT = ''
    AA.ERR           = ''
RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

    Y.DETAILS = R.NEW(AC.ACCOUNT.TITLE.2)
    Y.AA.ID   = FIELD(Y.DETAILS,'*',1)
    Y.AA.TYPE = FIELD(Y.DETAILS,'*',2)
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT EQ '' AND AA.ERR NE '' THEN
        AF = AC.ACCOUNT.TITLE.2
        ETEXT = 'EB-AA.ID.NT.ENTERED'
        CALL STORE.END.ERROR
    END ELSE
        Y.LOAN.AC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    END

    IF Y.AA.TYPE NE 'PRINCIPLE' AND Y.AA.TYPE NE 'INTEREST' THEN

        AF = AC.ACCOUNT.TITLE.2
        ETEXT = 'Account type not mentioned'
        CALL STORE.END.ERROR
    END

RETURN
END
