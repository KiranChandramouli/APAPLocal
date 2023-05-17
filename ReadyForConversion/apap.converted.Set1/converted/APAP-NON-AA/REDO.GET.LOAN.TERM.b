SUBROUTINE REDO.GET.LOAN.TERM(Y.AA.ID,EFFECTIVE.DATE,Y.LOAN.TERM)
*-----------------------------------------------------------------------------
*Description: This CALL routine is to get the loan's term details.
*             For migrated contracts - AA.ARR.TERM.AMOUNT>TERM will not have hold the
*             exact term of the loan. So we need to calculate the difference of original start date
*             & end date.
*Incoming Arg: Y.AA.ID        -> Arrangement ID.
*              EFFECTIVE.DATE -> Effective date.
*Outgoing Arg: Y.LOAN.TERM    -> Loan's Term.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT

    Y.LOAN.TERM = ''
    IF Y.AA.ID THEN
        GOSUB PROCESS
    END
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    IF R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE> THEN
        GOSUB GET.LOAN.TERM.MIG   ;* Get the loan's term by calculating the difference between original start date and maturity date.
    END ELSE
        GOSUB GET.LOAN.TERM.NON.MIG         ;* Get the loan term from AA.ARR.TERM.AMOUNT
    END

RETURN

*-----------------------------------------------------------------------------

*** <region name= GET.LOAN.TERM.MIG>
GET.LOAN.TERM.MIG:
*** <desc>Get the loan's term by calculating the difference between original start date and maturity date.</desc>

    EFF.DATE    = EFFECTIVE.DATE
    PROP.CLASS  ='TERM.AMOUNT'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.ORIG.START.DATE = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
    Y.MATURITY.DATE   = R.CONDITION<AA.AMT.MATURITY.DATE>
    YREGION = ''
    YDAYS   = 'C'
    IF Y.ORIG.START.DATE AND Y.MATURITY.DATE THEN
        CALL CDD (YREGION,Y.ORIG.START.DATE,Y.MATURITY.DATE,YDAYS)
        Y.LOAN.TERM = YDAYS:'D'
    END

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.LOAN.TERM.NON.MIG>
GET.LOAN.TERM.NON.MIG:
*** <desc>Get the loan term from AA.ARR.TERM.AMOUNT</desc>

    EFF.DATE    = EFFECTIVE.DATE
    PROP.CLASS  ='TERM.AMOUNT'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.LOAN.TERM = R.CONDITION<AA.AMT.TERM>
RETURN
*** </region>
END
