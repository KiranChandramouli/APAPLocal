* @ValidationCode : MjoxNDY0ODY0ODA6Q3AxMjUyOjE2ODMwOTYzNjU0MDQ6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 May 2023 12:16:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.AA
SUBROUTINE REDO.AUTH.AA.CHEQUE.REV
*----------------------------------------------------------------------------------
*Description: This is the auth routine during reversal of
*             AA cheque payment and post the new FT incase of remaining amount
*-----------------------------------------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion      FM TO @FM, VM to @VM, SM to @SM
* 29-MAR-2023      Harishvikram C     Manual R22 conversion    CALL routine format changed
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.REDO.H.AA.DIS.CHG
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.LOAN.CHQ.RETURN
    $USING APAP.TAM


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------

    LOC.REF.APPLICATION   = "FUNDS.TRANSFER":@FM:"AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS        = 'L.ACTUAL.VERSIO':@VM:'L.INITIAL.ID':@FM:'L.LOAN.COND'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.ACTUAL.VERSIO =      LOC.REF.POS<1,1>
    POS.L.INITIAL.ID    =      LOC.REF.POS<1,2>
    POS.L.LOAN.COND     =      LOC.REF.POS<2,1>

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN  = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM  = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

    FN.REDO.LOAN.CHQ.RETURN = 'F.REDO.LOAN.CHQ.RETURN'
    F.REDO.LOAN.CHQ.RETURN  = ''
    CALL OPF(FN.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN)

    FN.REDO.H.AA.DIS.CHG = 'F.REDO.H.AA.DIS.CHG'
    F.REDO.H.AA.DIS.CHG = ''
    CALL OPF(FN.REDO.H.AA.DIS.CHG,F.REDO.H.AA.DIS.CHG)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------


    Y.RLT.ID = R.NEW(FT.LOCAL.REF)<1,POS.L.INITIAL.ID>
    CALL F.READU(FN.REDO.LOAN.FT.TT.TXN,Y.RLT.ID,R.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN,RLT.ERR,"")
    IF R.REDO.LOAN.FT.TT.TXN ELSE
        RETURN
    END
    LOCATE ID.NEW IN R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.FT.TRANSACTION.ID,1> SETTING POS1 THEN
        Y.RETURN.AMOUNT = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,POS1> - R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        Y.CHQ.TXN.AMT   = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,POS1>
        Y.CHQ.REV.AMT   = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        GOSUB PROCESS.TXN
    END
    LOCATE ID.NEW IN R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.FT.REF,1> SETTING POS1 THEN
        Y.RETURN.AMOUNT = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,POS1> - R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        Y.CHQ.TXN.AMT   = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,POS1>
        Y.CHQ.REV.AMT   = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        GOSUB PROCESS.TXN
    END
RETURN
*-------------------------------------------------------
PROCESS.TXN:
*-------------------------------------------------------

    CALL CACHE.READ(FN.REDO.H.AA.DIS.CHG,'SYSTEM',R.REDO.H.AA.DIS.CHG,CHG.ERR)
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,PARA.ERR)
    Y.MAX.RET.CHQ   =  R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.MAX.RET.CHEQUES>
    Y.RETAIN.PERIOD =  R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CHEQUE.RETAIN>
    IF Y.RETAIN.PERIOD THEN
        Y.TODAY = TODAY
        CALL CALENDAR.DAY(Y.TODAY,'+',Y.RETAIN.PERIOD)
        Y.EXP.DATE = Y.RETAIN.PERIOD
    END ELSE
        Y.EXP.DATE = TODAY
    END

*CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,CLEAR.ERR)
    Y.AA.WASH.AC = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.AA.WASHTHROUGH>
    IF Y.RETURN.AMOUNT GT 0 THEN
        GOSUB POST.FT.REAPPLY
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.AMOUNT,POS1> = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,Y.RLT.ID,R.REDO.LOAN.FT.TT.TXN)
    END ELSE
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.AMOUNT,POS1> = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURN.AMOUNT,POS1>
        CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,Y.RLT.ID,R.REDO.LOAN.FT.TT.TXN)
    END
    GOSUB RAISE.ENTRY
    Y.LOAN.NO = R.NEW(FT.CREDIT.ACCT.NO)
    Y.DATE    = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE>
    CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,Y.LOAN.NO,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,CHQ.RET.ERR)
    IF R.REDO.LOAN.CHQ.RETURN THEN
        GOSUB UPDATE.EXIST
    END ELSE
        GOSUB UPDATE.NEW
    END
    IF R.REDO.LOAN.CHQ.RETURN THEN
        CALL F.WRITE(FN.REDO.LOAN.CHQ.RETURN,Y.LOAN.NO,R.REDO.LOAN.CHQ.RETURN)
    END
    GOSUB TRIGGER.CHARGE
    IF R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> GE Y.MAX.RET.CHQ THEN      ;* Three return check update
        GOSUB UPDATE.LOAN.RETURN.CHQ
    END

RETURN
*-------------------------------------------------------
UPDATE.EXIST:
*-------------------------------------------------------

    LOCATE Y.DATE IN R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TXN.DATE,1> SETTING POS2 THEN

        Y.CHEQUE.REF = ''
        Y.CHQ.RET.AMT     = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INDV.RET.AMT,POS1>
        Y.CHQ.RET.AMT.CNT = DCOUNT(Y.CHQ.RET.AMT,@SM)
        Y.VAR1 = 1
        LOOP
        WHILE Y.VAR1 LE Y.CHQ.RET.AMT.CNT
            IF Y.CHQ.RET.AMT<1,1,Y.VAR1> THEN
                Y.CHEQUE.REF = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DRAWDOWN.ACC,Y.VAR1> :'-': R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.CHQ,POS1,Y.VAR1>
                LOCATE Y.CHEQUE.REF IN R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,POS2,1> SETTING POS3 ELSE
                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,POS2,-1>      = Y.CHEQUE.REF
                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.RET.DATE,POS2,-1>        = TODAY
                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.EXP.DATE,POS2,-1>        = Y.EXP.DATE
                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> + 1

                END
            END
            Y.VAR1 += 1
        REPEAT
    END ELSE
        GOSUB UPDATE.NEW
    END

RETURN
*-------------------------------------------------------
UPDATE.NEW:
*-------------------------------------------------------

    Y.CHEQUE.REF = ''
    Y.CHQ.RET.AMT     = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INDV.RET.AMT,POS1>
    Y.CHQ.RET.AMT.CNT = DCOUNT(Y.CHQ.RET.AMT,@SM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.CHQ.RET.AMT.CNT
        IF Y.CHQ.RET.AMT<1,1,Y.VAR1> THEN
            Y.CHEQUE.REF = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DRAWDOWN.ACC,Y.VAR1> :'-': R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.CHQ,POS1,Y.VAR1>
            LOCATE Y.DATE IN R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TXN.DATE,1> SETTING POS4 THEN

                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,POS4,-1>       = Y.CHEQUE.REF
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.RET.DATE,POS4,-1>         = TODAY
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.EXP.DATE,POS4,-1>         = Y.EXP.DATE
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ>            = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> + 1

            END ELSE
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TXN.DATE,-1>              = Y.DATE
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,-1,1>          = Y.CHEQUE.REF
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.RET.DATE,-1,1>            = TODAY
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.EXP.DATE,-1,1>            = Y.EXP.DATE
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ>            = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> + 1
            END

        END
        Y.VAR1 += 1
    REPEAT


RETURN
*-------------------------------------------------------
POST.FT.REAPPLY:
*-------------------------------------------------------
    Y.ACTUAL.FTTC  = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.ACTUAL.FTTC>
    Y.REVERSE.FTTC = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.REVERSAL.FTTC>

    LOCATE R.NEW(FT.TRANSACTION.TYPE) IN Y.ACTUAL.FTTC<1,1> SETTING FTTC.POS THEN ;* During payoff cheque reversal, to avoid payoff charge(Payoff charge applicable only once)
        Y.FTTC = Y.REVERSE.FTTC<1,FTTC.POS>
    END ELSE
        Y.FTTC = R.NEW(FT.TRANSACTION.TYPE)
    END
    R.FT = ''
    R.FT<FT.TRANSACTION.TYPE> = Y.FTTC
    R.FT<FT.CREDIT.CURRENCY>  = R.NEW(FT.CREDIT.CURRENCY)
    R.FT<FT.CREDIT.ACCT.NO>   = R.NEW(FT.CREDIT.ACCT.NO)
    R.FT<FT.CREDIT.AMOUNT>    = Y.RETURN.AMOUNT
    R.FT<FT.DEBIT.CURRENCY>   = R.NEW(FT.CREDIT.CURRENCY)
*R.FT<FT.DEBIT.ACCT.NO>    = Y.AA.WASH.AC
    R.FT<FT.DEBIT.ACCT.NO>    = R.NEW(FT.DEBIT.ACCT.NO)
    R.FT<FT.ORDERING.CUST>    = "AARETURN"
    R.FT<FT.DEBIT.VALUE.DATE> = R.NEW(FT.DEBIT.VALUE.DATE)
    R.FT<FT.CREDIT.VALUE.DATE>= R.NEW(FT.CREDIT.VALUE.DATE)
    R.FT<FT.CREDIT.THEIR.REF> = ID.NEW
    R.FT<FT.LOCAL.REF,POS.L.INITIAL.ID> = R.NEW(FT.LOCAL.REF)<1,POS.L.INITIAL.ID>
    APP.NAME           = 'FUNDS.TRANSFER'
    OFSFUNCTION        = 'I'
    PROCESS            = 'PROCESS'
    OFS.SOURCE.ID      = 'FT.RET.CHQ'
    OFSVERSION         = 'FUNDS.TRANSFER,RET.CHQ'
    GTS.MODE           = ''
    NO.OF.AUTH         = 0
    TRANSACTION.ID     = ''
    OFSSTRING          = ''
    OFS.ERR            = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.FT,OFSSTR)
    CALL OFS.POST.MESSAGE(OFSSTR,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
RETURN
*--------------------------------------------
UPDATE.LOAN.RETURN.CHQ:
*--------------------------------------------

    IN.ARR.ID = ''
    OUT.ID = ''
    CALL APAP.TAM.redoConvertAccount(Y.LOAN.NO,IN.ARR.ID,OUT.ID,ERR.TEXT)
    ARR.ID = OUT.ID

    IN.PROPERTY.CLASS='OVERDUE'
    PROPERTY=''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,PROPERTY,OUT.ERR)

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    R.CONDITION = ''
    ERR.MSG = ''
    CALL APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);* R22 Manual Conversion- CALL routine format changed
    Y.STATUS = 'ThreeReturnedChecks'
    LOCATE Y.STATUS IN R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.COND,1> SETTING COND.POS ELSE
        ACT.ID = "LENDING-UPDATE-":PROPERTY
        Y.LOAN.COND = R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.COND>
        Y.LOAN.COND.CNT = DCOUNT(Y.LOAN.COND,@SM)
        OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,,,ARRANGEMENT:1:1=":ARR.ID:",ACTIVITY:1:1=":ACT.ID:",PROPERTY:1:1=":PROPERTY
        OFS.STRING.FINAL:= ",FIELD.NAME:1:1=LOCAL.REF:":POS.L.LOAN.COND:':':Y.LOAN.COND.CNT+1:",FIELD.VALUE:1:1=":Y.STATUS
        OFS.SRC = 'REDO.AA.OVR.UPD'
        OPTIONS = ''
        OFS.MSG.ID = ''
        CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    END
RETURN
*-------------------------------------------------------
TRIGGER.CHARGE:
*-------------------------------------------------------
    Y.LOAN.NO = R.NEW(FT.CREDIT.ACCT.NO)


    LOCATE Y.DATE IN R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TXN.DATE,1> SETTING POS2 THEN
        Y.CHQ.REF = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,POS2>
        Y.VAR1 = 1
        Y.RET.CHQ.CNT = DCOUNT(Y.CHQ.REF,@SM)
        LOOP
        WHILE Y.VAR1 LE Y.RET.CHQ.CNT
            Y.RET.FLAG = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHG.FLAG,POS2,Y.VAR1>
            IF Y.RET.FLAG EQ '' THEN
                GOSUB POST.OFS
                Y.VAR1 = Y.RET.CHQ.CNT+1
            END
            Y.VAR1 += 1
        REPEAT
    END
RETURN

*-------------------------------------------------------
POST.OFS:
*-------------------------------------------------------
    Y.RET.CHQ.PROP = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.RET.CHQ.CHARGE>

    IN.ARR.ID = ''
    OUT.ID = ''
    CALL APAP.TAM.redoConvertAccount(Y.LOAN.NO,IN.ARR.ID,OUT.ID,ERR.TEXT)
    ARR.ID = OUT.ID
    IF Y.RET.CHQ.PROP THEN
        APP.NAME       = 'AA.ARRANGEMENT.ACTIVITY'
        OFS.FUNCTION   = 'I'
        PROCESS        = 'PROCESS'
        OFS.SOURCE.ID  = 'REDO.CHQ.ISSUE'
        OFSVERSION     = 'AA.ARRANGEMENT.ACTIVITY,APAP'
        GTS.MODE        = ''
        NO.OF.AUTH     = '0'
        TRANSACTION.ID = ''
        R.APP.RECORD   = ''
        OFS.STRING     = ''
        R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = ARR.ID
*R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = 'LENDING-CHANGE-':Y.RET.CHQ.PROP
        R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = 'CHQ.RETURN.ACTIVITY'
        R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
        CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)

        OFS.MSG.ID = ''
        OPTIONS = ''
        OFS.ERR = ''

        CALL OFS.POST.MESSAGE(OFS.MESSAGE,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    END

RETURN
*----------------------------------------------------------
RAISE.ENTRY:
*----------------------------------------------------------
    Y.ACCOUNTING.AMT =  Y.CHQ.REV.AMT + R.NEW(FT.CREDIT.AMOUNT) - Y.CHQ.TXN.AMT
    IF Y.ACCOUNTING.AMT GT 0 ELSE
        RETURN
    END
    Y.DR.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CR.ACCOUNT = Y.AA.WASH.AC
    MULTI.STMT   = ''
    Y.CR.CODE    = 82
    Y.DR.CODE    = 201
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT ELSE
        RETURN
    END
    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER>    = Y.DR.ACCOUNT
    R.STMT.ARR<AC.STE.AMOUNT.LCY>        = -1 * Y.ACCOUNTING.AMT
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>  = Y.DR.CODE
*R.STMT.ARR<AC.STE.CRF.TYPE>          = "DEBIT"
    R.STMT.ARR<AC.STE.CURRENCY>          = R.ACCOUNT<AC.CURRENCY>
    GOSUB BASIC.ACC.ENTRY
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)

    CALL F.READ(FN.ACCOUNT,Y.CR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT ELSE
        RETURN
    END

    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER>    = Y.CR.ACCOUNT
    R.STMT.ARR<AC.STE.AMOUNT.LCY>        = Y.ACCOUNTING.AMT
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>  = Y.CR.CODE
*R.STMT.ARR<AC.STE.CRF.TYPE>          = "CREDIT"
    R.STMT.ARR<AC.STE.CURRENCY>          = R.ACCOUNT<AC.CURRENCY>
    GOSUB BASIC.ACC.ENTRY
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)

    CALL EB.ACCOUNTING("FT","SAO",MULTI.STMT,'')


RETURN

BASIC.ACC.ENTRY:
*Common Call for raising Entries

    R.STMT.ARR<AC.STE.COMPANY.CODE>     = ID.COMPANY
*R.STMT.ARR<AC.STE.CUSTOMER.ID>      = VAR.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER>  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    R.STMT.ARR<AC.STE.VALUE.DATE>       = TODAY
    R.STMT.ARR<AC.STE.POSITION.TYPE>    = "TR"
    R.STMT.ARR<AC.STE.OUR.REFERENCE>    = ID.NEW
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>  = ID.NEW
    R.STMT.ARR<AC.STE.SYSTEM.ID>        = "FT"
    R.STMT.ARR<AC.STE.BOOKING.DATE>     = TODAY
    R.STMT.ARR<AC.STE.EXPOSURE.DATE>    = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>  = 1
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ARR<AC.STE.PROCESSING.DATE>  = TODAY
    R.STMT.ARR<AC.STE.ORIG.CCY.MARKET>  = 1

RETURN

END
