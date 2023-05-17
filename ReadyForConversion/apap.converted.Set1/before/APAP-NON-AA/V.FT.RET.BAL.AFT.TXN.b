*-----------------------------------------------------------------------------
* <Rating>32</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE V.FT.RET.BAL.AFT.TXN

*-------------------------------------------------------------------------------
* 25/11/03
* Input routine to calculate the amount after transaction and populate a local reference
* Assumes debit currency of the transaction is account currency
*-------------------------------------------------------------------------------
*Modification Description:
*--------------------------
*changed local reference fields from GET.LOCAL.REF TO MULTI.GET.LOCAL.REF method.
*----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History:
* ---------------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*10/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469         Modification
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.CURRENCY
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.EB.CONTRACT.BALANCES
*
*

    GOSUB INITIALISE
    GOSUB PROCESS

    RETURN

*-------------------------------------------------------------------------------
INITIALISE:
*
    ACC.NO = R.NEW(FT.DEBIT.ACCT.NO)

* added by liril
* TXN.AMT = R.NEW(FT.DEBIT.AMOUNT)
*
    TXN.AMT1 = R.NEW(FT.AMOUNT.DEBITED)
    LEN.TXN = LEN(TXN.AMT1)
    TXN.AMT = TXN.AMT1[4,LEN.TXN-3]
*
    CALL GET.ACCT.BRANCH(ACC.NO,Y.COMP.MNE,Y.COMP.CODE)
*
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
*
    FN.ACCOUNT = 'F':Y.COMP.MNE:'.ACCOUNT'
    FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.CURRENCY = 'F.CURRENCY'
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*
    CALL F.READ(FN.ACCOUNT.CLASS,'SAVINGS',R.ACCT.CLASS,F.ACCOUNT.CLASS,ER.ACC.CLASS)
*
    SAV.ACCT.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>

    FLD.NAM ='BAL.AFT.TXN':VM:'AT.AUTH.CODE':VM:'AT.UNIQUE.ID'


***Commented and modified the above statement for VP Bank
    CALL MULTI.GET.LOC.REF(APPLICATION,FLD.NAM,FLD.POS)
    LRF.NO=FLD.POS<1,1> ; LRF.NO.2=FLD.POS<1,2>;LRF.NO.3=FLD.POS<1,3>
    RETURN          ;* from Initialise

*-------------------------------------------------------------------------------
PROCESS:
*
    CALL F.READ(FN.ACCOUNT,ACC.NO,R.ACCT,F.ACCOUNT,AC.ER)	;*/ TUS START/END
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',ACC.NO,R.ECB,ECB.ERR)
    CCY.CODE = R.NEW(FT.DEBIT.CURRENCY)
    CALL F.READ(FN.CURRENCY,CCY.CODE,R.CCY,F.CURRENCY,ER.CCY)
    NUM.CCY = R.CCY<EB.CUR.NUMERIC.CCY.CODE>
    NUM.CCY = FMT(NUM.CCY,'R%3')

* Added by liril

    ACCATEG = R.ACCT<AC.CATEGORY>
    FIND ACCATEG IN SAV.ACCT.CATEG SETTING SAV.FOUND.POSN1,SAV.FOUND.POSN ELSE SAV.FOUND.POSN = ''
    IF SAV.FOUND.POSN THEN
* IF R.ACCT<AC.CATEGORY> EQ SAV.ACCT.CATEG THEN
        ACC.TYPE = '10'       ;*SAVINGS
    END ELSE
        ACC.TYPE ='20'        ;* CURRENT
    END

    IF NOT(AC.ER) THEN
        IF NUM(TXN.AMT) THEN
*            BAL.BFR.TXN = R.ACCT<AC.WORKING.BALANCE>	;*/ TUS STAT/END
		BAL.BFR.TXN = R.ECB<ECB.WORKING.BALANCE>
            WORK.BAL = BAL.BFR.TXN
* commented and added by liril
* GOSUB REDUCE.LOCK.AMT

            CALL AT.CALC.AVAIL.BALANCE(R.ACCT,WORK.BAL,AVAIL.BAL)
            BAL.AFT.TXN1 = AVAIL.BAL
        END
    END

    IF BAL.BFR.TXN LE '0' THEN
        BAL.SIGN ='D'
    END ELSE
        BAL.SIGN ='C'
    END

    BAL.BFR.TXN =ABS(BAL.BFR.TXN)
    BAL.AFT.TXN1 = ABS(BAL.AFT.TXN1)
    BAL.LEN ='020'

* commented by liril
    BAL.AFT.TXN3 = FIELD(BAL.AFT.TXN1,'.',1)
    BAL.AFT.TXN4 = FIELD(BAL.AFT.TXN1,'.',2)
* Commented and modified the below block for VP Bank
*    BAL.AFT.TXN3 = FMT(BAL.AFT.TXN3,'10%R')
*    BAL.AFT.TXN4 = FMT(BAL.AFT.TXN4,'2%L')
    BAL.AFT.TXN = BAL.AFT.TXN3:BAL.AFT.TXN4
    NO.OF.DECIMALS=R.CCY<EB.CUR.NO.OF.DECIMALS>
    IF NO.OF.DECIMALS EQ 0 THEN
        NO.OF.DECIMALS=2
    END
    BAL.AFT.TXN2 = FMT(BAL.AFT.TXN4,'L%':NO.OF.DECIMALS)
    NO.OF.DIGITS=12-NO.OF.DECIMALS
    BAL.AFT.TXN1 = FMT(BAL.AFT.TXN3,'R%':NO.OF.DIGITS)
    BAL.AFT.TXN = BAL.AFT.TXN1:BAL.AFT.TXN2


***Block Modification ends here



    BAL.AFT.TXN = ACC.TYPE:'01':NUM.CCY:BAL.SIGN:BAL.AFT.TXN
    R.NEW(FT.LOCAL.REF)<1,LRF.NO> = BAL.AFT.TXN

* CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
* CONVERT '.' TO '' IN UNIQUE.TIME
* LEN.UNIQUE.TIME = LEN(UNIQUE.TIME)-6
*UNIQUE.TIME = UNIQUE.TIME[LEN.UNIQUE.TIME,6]
*R.NEW(FT.LOCAL.REF)<1,LRF.NO.2> = UNIQUE.TIME

    BEGIN CASE
    CASE APPLICATION EQ 'FUNDS.TRANSFER'
        UNIQ.ID=R.NEW(FT.LOCAL.REF)<1,LRF.NO.3>
        AUTH.CODE=FIELD(UNIQ.ID,'.',2)
        R.NEW(FT.LOCAL.REF)<1,LRF.NO.2> = AUTH.CODE
    CASE APPLICATION EQ 'AC.LOCKED.EVENTS'
        UNIQ.ID=R.NEW(AC.LCK.LOCAL.REF)<1,LRF.NO.3>
        AUTH.CODE=FIELD(UNIQ.ID,'.',2)
        R.NEW(AC.LCK.LOCAL.REF)<1,LRF.NO.2> = AUTH.CODE
    END CASE


    RETURN          ;*

*-------------------------------------------------------------------------------
REDUCE.LOCK.AMT:
*
    IF R.ACCT<AC.FROM.DATE> THEN
        U.LOCK.AMT =0
        U.CTR = DCOUNT(R.ACCT<AC.FROM.DATE>, @VM)
        FOR U.I = 1 TO U.CTR
            IF TODAY GE R.ACCT<AC.FROM.DATE, U.I> THEN
                U.LOCK.AMT += R.ACCT<AC.LOCKED.AMOUNT,U.I>
            END
        NEXT U.I
        WORK.BAL= WORK.BAL - U.LOCK.AMT
    END ELSE
        WORK.BAL = WORK.BAL
    END

    RETURN          ;*From Reduce.lock.amt

*-------------------------------------------------------------------------------
