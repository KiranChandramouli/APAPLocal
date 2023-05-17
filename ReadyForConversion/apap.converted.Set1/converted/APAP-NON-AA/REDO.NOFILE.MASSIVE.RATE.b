SUBROUTINE REDO.NOFILE.MASSIVE.RATE(Y.OUT.ARRAY)
*--------------------------------------------------------
* Description: This routine is a nofile enquiry routine to display the details
* of the loan along with interest rate.

* In  Argument:
* Out Argument: Y.OUT.ARRAY

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh         Massive rate - B.16  INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------

    Y.OUT.ARRAY = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    FILE.NAME = FN.AA.ARRANGEMENT

    LOCATE 'MARGIN.ID' IN  D.FIELDS<1> SETTING POS1 THEN
        Y.MARGIN.ID = D.RANGE.AND.VALUE<POS1>
        D.RANGE.AND.VALUE<POS1>=''
        D.LOGICAL.OPERANDS<POS1>=''
        D.FIELDS<POS1>=''

    END

    CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.AA.CMD)
    SEL.AA.CMD :=' AND (ARR.STATUS EQ AUTH OR ARR.STATUS EQ CURRENT)'
    CALL EB.READLIST(SEL.AA.CMD,AA.IDS,'',NO.OF.REC,SEL.ERR)
    CALL REDO.CHECK.AA.IDS(AA.IDS,Y.MARGIN.ID,RETURN.AA.IDS)

    GOSUB FORM.ARRAY


RETURN
*-----------------------------------------------------------------
FORM.ARRAY:
*-----------------------------------------------------------------


    Y.OUT.ARRAY = ''
    Y.FINAL.IDS.CNT = DCOUNT(RETURN.AA.IDS,@FM)

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.FINAL.IDS.CNT

        Y.AA.ID = FIELD(RETURN.AA.IDS<Y.CNT>,'*',1)
        GOSUB GET.INTEREST.DET
        Y.OUT.ARRAY<-1> = Y.AA.AC.ID:'*':Y.CUS.ID:'*':Y.EFFECTIVE.RATE:'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',2):'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',3):'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',4)

        Y.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------
GET.INTEREST.DET:
*-----------------------------------------------------------------
    OUT.PROP = ''
    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
    CALL REDO.GET.INTEREST.PROPERTY(Y.AA.ID,PROP.NAME,OUT.PROP,ERR)
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

    Y.ARRG.ID = Y.AA.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = TODAY
    ERR.MSG = ''
    R.INT.ARR.COND = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)

    Y.EFFECTIVE.RATE = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE,1>

    IN.ACC.ID = ''
    IN.ARR.ID = Y.AA.ID
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
    Y.AA.AC.ID = OUT.ID

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRG.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    Y.CUS.ID = R.ARRANGEMENT<AA.ARR.CUSTOMER>



RETURN

END
