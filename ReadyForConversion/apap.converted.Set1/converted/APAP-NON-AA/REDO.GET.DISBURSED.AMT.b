SUBROUTINE REDO.GET.DISBURSED.AMT(ARR.ID,Y.DISB.AMOUNT)
*---------------------------------------------------------
*Description: This routine returns the disbursed amount of the loan.
* Input Arg  :  Arrangement ID.
* Output Arg :  Disbursed Amount.
*---------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------
INIT:
*---------------------------------
    Y.DISB.AMOUNT = 0
RETURN
*---------------------------------
PROCESS:
*---------------------------------

    IF ARR.ID ELSE
        RETURN
    END
    IN.PROPERTY.CLASS = 'TERM.AMOUNT'
    R.OUT.AA.RECORD   = ''
    OUT.PROPERTY      = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    IN.ACC.ID = ''
    OUT.ID = ''
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT)
    Y.ARR.ACC.ID = OUT.ID
    BALANCE.TO.CHECK = 'CUR':OUT.PROPERTY
    CUR.AMOUNT=''
    Y.TODAY = TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,CUR.AMOUNT,RET.ERROR)
    CUR.AMOUNT = ABS(CUR.AMOUNT)

    BALANCE.TO.CHECK = 'TOT':OUT.PROPERTY
    TOT.AMOUNT       = ''
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,TOT.AMOUNT,RET.ERROR)
    TOT.AMOUNT = ABS(TOT.AMOUNT)

    Y.DISB.AMOUNT = TOT.AMOUNT - CUR.AMOUNT

RETURN
END
