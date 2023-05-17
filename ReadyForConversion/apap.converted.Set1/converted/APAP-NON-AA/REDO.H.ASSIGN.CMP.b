SUBROUTINE REDO.H.ASSIGN.CMP
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This validation routine is attached in REDO.H.ASSIGNMENT application for checking the fields are inputted
*               properly or not
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.02.2011   Jeyachandran S      ODR-2009-11-0200       INITIAL CREATION
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ASSIGNMENT
    $INSERT I_F.REDO.H.PIGGY.BANKS

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------
INIT:
    Y.CMP = ''
RETURN

*------------
OPENFILES:

    FN.REDO.H.ASSIGNMENT = 'F.REDO.H.ASSIGNMENT'
    F.REDO.H.ASSIGNMENT = ''
    CALL OPF(FN.REDO.H.ASSIGNMENT,F.REDO.H.ASSIGNMENT)

    FN.REDO.H.PIGGY.BANKS = 'F.REDO.H.PIGGY.BANKS'
    F.REDO.H.PIGGY.BANKS = ''
    CALL OPF(FN.REDO.H.PIGGY.BANKS,F.REDO.H.PIGGY.BANKS)

RETURN
*-------------
PROCESS:



    Y.SYS.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.PIGGY.BANKS,Y.SYS.ID,R.REDO.H.PIGGY.BANKS,Y.ERR)
    Y.CMP = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT>
    Y.QTY = R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL>
    Y.QUANTITY = R.NEW(REDO.ASSIGN.QUANTITY)
    CHANGE @VM TO @FM IN Y.CMP
    Y.CHCK = ID.COMPANY
    LOCATE Y.CHCK IN Y.CMP SETTING POS THEN
        IF Y.QUANTITY GT Y.QTY<1,POS> THEN
            AF= REDO.ASSIGN.QUANTITY
            ETEXT = 'EB-QTY.CHCK'
            CALL STORE.END.ERROR
        END
    END ELSE
        AF= REDO.ASSIGN.QUANTITY
        ETEXT = 'EB-QTY.CHCK'
        CALL STORE.END.ERROR
    END
    Y.ACC.VAL = R.NEW(REDO.ASSIGN.DEBIT.ACCOUNT)
    Y.TOT.AMT = R.NEW(REDO.ASSIGN.AMOUNT)
    R.NEW(REDO.ASSIGN.AMOUNT)       = FMT(Y.TOT.AMT,"R2#10")
    R.NEW(REDO.ASSIGN.DATE) = TODAY
RETURN

END
