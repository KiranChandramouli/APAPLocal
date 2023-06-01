* @ValidationCode : MjotMTYwMDY3MTM1OTpDcDEyNTI6MTY4MjQxMjMyODIzODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.NAB.WR.CONCAT

*MODIFICATION HISTORY:

*--------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT


MAIN:



    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    Y.AA.ID = R.NEW(AC.ACCOUNT.TITLE.2)
    Y.AA.ID = FIELD(Y.AA.ID,'*',1)

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARR,F.AA.ARRANGEMENT,ARR.ERR)
    IF R.AA.ARR THEN
        Y.AC.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.AA.ID,R.ACC,F.ACCOUNT,AC.ERR)
        IF NOT(R.ACC) THEN
            AF = AC.ACCOUNT.TITLE.2
            ETEXT = 'EB-AA.ID.NT.ENTERED'
            CALL STORE.END.ERROR
        END ELSE
            Y.AC.ID = Y.AA.ID
        END
    END

    IF Y.AC.ID THEN
        R.REDO.CONCAT.ACC.NAB = ID.NEW
        CALL F.WRITE(FN.REDO.CONCAT.ACC.NAB,Y.AC.ID,R.REDO.CONCAT.ACC.NAB)
    END

RETURN

END
