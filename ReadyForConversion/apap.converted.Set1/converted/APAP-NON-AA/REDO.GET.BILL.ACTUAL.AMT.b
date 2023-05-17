SUBROUTINE REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
*---------------------------------------------------
*Description: This routine is get the original bill i.e bill amount
*             along with adjustment balances.

* Incoming Arg: Y.BILL.IDS     -> Bill ids Seperated by FM.
* Outgoing Arg: R.ARRAY<1>     -> Bill ids Seperated by VM.
*               R.ARRAY<2>     -> Property Seperated by SM.
*               R.ARRAY<3>     -> Respective amount Seperated by SM.
*               R.ARRAY<4>     -> Total amounts Seperated by VM.
*               Y.FUTURE.USE   -> Future Use.
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*---------------------------------------------------
OPEN.FILES:
*---------------------------------------------------

    R.ARRAY = ''

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS  = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    FN.AA.BILL.HST = 'F.AA.BILL.DETAILS.HIST'
    F.AA.BILL.HST = ''
    CALL OPF(FN.AA.BILL.HST,F.AA.BILL.HST)

RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    Y.BILL.CNT = DCOUNT(Y.BILL.IDS,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BILL.CNT
        Y.BILL.ID = Y.BILL.IDS<Y.VAR1>
        R.ARRAY<1,Y.VAR1> = Y.BILL.ID
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
        IF NOT(R.BILL.DETAILS) THEN
            R.BILL.DETAILS = ''; BILL.ERR = ''
            CALL F.READ(FN.AA.BILL.HST,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.HST,BILL.ERR)
        END
        GOSUB GET.RESPECTIVES.AMOUNT
        Y.VAR1 += 1
    REPEAT
RETURN
*---------------------------------------------------
GET.RESPECTIVES.AMOUNT:
*---------------------------------------------------
    Y.PROPERTIES  =  R.BILL.DETAILS<AA.BD.PROPERTY>
    Y.PROP.CNT    =  DCOUNT(Y.PROPERTIES,@VM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.PROP.CNT
        Y.PROPERTY = Y.PROPERTIES<1,Y.VAR2>
        GOSUB GET.AMOUNT
        R.ARRAY<2,Y.VAR1,Y.VAR2> = Y.PROPERTY
        R.ARRAY<3,Y.VAR1,Y.VAR2> = R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,Y.VAR2> + ADJ.AMOUNT
        R.ARRAY<4,Y.VAR1>        = R.ARRAY<4,Y.VAR1> + (R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,Y.VAR2> + ADJ.AMOUNT)
        Y.VAR2 += 1
    REPEAT

RETURN

*-------------------------------------
GET.AMOUNT:
*-------------------------------------
    Y.EXCLUSION.ADJ.STATUS = 'SUSPEND':@VM:'CAPTURE.BILL':@VM:'RESUME'
    Y.FINAL.AMOUNT = 0
    ADJ.AMOUNT     = 0
    Y.ADJUSTED.REF = R.BILL.DETAILS<AA.BD.ADJUST.REF,Y.VAR2>
    Y.ADJUSTED.AMT = R.BILL.DETAILS<AA.BD.ADJUST.AMT,Y.VAR2>
    Y.ADJUSTED.CNT = DCOUNT(Y.ADJUSTED.REF,@SM)
    Y.VAR3 = 1
    LOOP
    WHILE Y.VAR3 LE Y.ADJUSTED.CNT
        Y.ADJUSTED.ID = Y.ADJUSTED.REF<1,1,Y.VAR3>
        Y.SECOND.PART = FIELD(Y.ADJUSTED.ID,'-',2)
        IF Y.SECOND.PART MATCHES Y.EXCLUSION.ADJ.STATUS ELSE
            ADJ.AMOUNT += Y.ADJUSTED.AMT<1,1,Y.VAR3>
        END
        Y.VAR3 += 1
    REPEAT

RETURN

END
