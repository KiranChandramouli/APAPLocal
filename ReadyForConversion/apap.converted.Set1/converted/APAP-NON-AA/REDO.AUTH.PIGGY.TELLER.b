SUBROUTINE REDO.AUTH.PIGGY.TELLER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.CLAIM
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.CLAIMS.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.LOCKING
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_F.REDO.H.PIGGY.BANK.ASSIGNMENT
    $INSERT I_F.REDO.H.PIGGY.BANKS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.REDO.H.PIGGY.BANKS = 'F.REDO.H.PIGGY.BANKS'
    F.REDO.H.PIGGY.BANKS = ''
    CALL OPF(FN.REDO.H.PIGGY.BANKS,F.REDO.H.PIGGY.BANKS)
    FN.REDO.H.PIGGY.BANK.ASSIGNMENT = 'F.REDO.H.PIGGY.BANK.ASSIGNMENT'
    F.REDO.H.PIGGY.BANK.ASSIGNMENT = ''
    CALL OPF(FN.REDO.H.PIGGY.BANK.ASSIGNMENT,F.REDO.H.PIGGY.BANK.ASSIGNMENT)

RETURN

********
PROCESS:
********

    Y.FILED = R.NEW(TT.TE.NARRATIVE.2)
    Y.ID = FIELD(Y.FILED,"-",2)
    CALL F.READ(FN.REDO.H.PIGGY.BANK.ASSIGNMENT,Y.ID,R.REDO.H.PIGGY.BANK.ASSIGNMENT,F.REDO.H.PIGGY.BANK.ASSIGNMENT,Y.ERR)
    Y.QNT = R.REDO.H.PIGGY.BANK.ASSIGNMENT<PB.AS.QUANTITY>
    Y.COMPANY = R.REDO.H.PIGGY.BANK.ASSIGNMENT<PB.AS.CO.CODE>
    Y.ID.BANK = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.PIGGY.BANKS,Y.ID.BANK,R.REDO.H.PIGGY.BANKS,Y.ERR)
    Y.CMP = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT>
    Y.AVL = R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL>
    CHANGE @VM TO @FM IN Y.CMP
    LOCATE Y.COMPANY IN Y.CMP SETTING POS THEN
        Y.VALUE = Y.AVL<1,POS>
        Y.SUB = Y.VALUE - Y.QNT
        R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL,POS> = Y.SUB
        CALL F.WRITE(FN.REDO.H.PIGGY.BANKS,Y.ID.BANK,R.REDO.H.PIGGY.BANKS)
    END

END
