$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion      FMto@FM, T24.BP IS REMOVED,Command this Insert file I_F.T24.FUND.SERVICES
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.REC.ACCT.LIST(Y.ACCT.ID)

    $INSERT  I_COMMON ;*R22 Manual code conversion
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_F.STMT.ENTRY
    $INSERT  I_F.FUNDS.TRANSFER ;*R22 Manual code conversion
    $INSERT  I_F.TELLER
    $INSERT  I_F.ACCOUNT ;*R22 Manual code conversion
    $INSERT  I_F.EB.CONTRACT.BALANCES
    $INSERT  I_F.TELLER
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.DATES
    $INSERT  I_F.RE.STAT.REP.LINE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.TRANSACTION
    $INSERT  I_F.TELLER.TRANSACTION
    $INSERT  I_F.FT.TXN.TYPE.CONDITION
* $INSERT  I_F.T24.FUND.SERVICES
    $INSERT  I_REDO.B.REC.ACCT.LIST.COMMON ;*R22 Manual code conversion



    GOSUB PROCESS
    GOSUB WRITE.DATA
RETURN


********
PROCESS:
********
    Y.FIN.ARRAY=''; R.ACCOUNT = '';Y.ERR = ''; R.ECB= '' ; ECB.ERR= ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.RECONCILE =R.ACCOUNT<AC.RECONCILE.ACCT>
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCT.ID,R.ECB,ECB.ERR)
    Y.ONLINE.BAL=R.ECB<ECB.ONLINE.ACTUAL.BAL>

    IF Y.RECONCILE EQ 'Y' AND (Y.ONLINE.BAL GT '0' OR Y.ONLINE.BAL LT '0') ELSE
        RETURN
    END
    IF Y.CUR.SEL.LIST THEN
        Y.AC.CUR=R.ACCOUNT<AC.CURRENCY>
        LOCATE Y.AC.CUR IN Y.CUR.SEL.LIST<1,1,1> SETTING Y.CUR.SEL.POS ELSE
            RETURN
        END
    END
    IF Y.ACC.SEL.LIST THEN
        LOCATE Y.ACCT.ID IN Y.ACC.SEL.LIST<1,1,1> SETTING Y.AC.SEL.POS ELSE
            RETURN
        END
    END
    GOSUB GET.LINE.NO
    IF Y.LINE.SEL.LIST THEN
        LOCATE Y.LINE.NO IN Y.LINE.SEL.LIST<1,1,1> SETTING Y.LINE.SEL.POS ELSE
            RETURN
        END
    END

    IF Y.COMP.SEL.LIST THEN
        Y.COMP.CODE=R.ACCOUNT<AC.CO.CODE>
        LOCATE Y.COMP.CODE IN Y.COMP.SEL.LIST<1,1,1> SETTING Y.COMP.SEL.POS ELSE
            RETURN
        END
    END
    IF RUNNING.UNDER.BATCH THEN
        GOSUB PROCESS.DATA.COB
    END
    ELSE
        GOSUB PROCESS.DATA
    END
RETURN

*************
PROCESS.DATA:
*************

    D.LOGICAL.OPERANDS=1
    D.LOGICAL.OPERANDS<-1>=Y.REP.OPERAND
    D.FIELDS    ="ACCOUNT"
    D.FIELDS<-1>="BOOKING.DATE"
    D.RANGE.AND.VALUE    =Y.ACCT.ID
    D.RANGE.AND.VALUE<-1>=Y.REP.DATE
    CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
    T.TOT.STMT.CNT=DCOUNT(Y.ID.LIST,@FM)
    Y.CUR.STMT.NO=1
    LOOP
    WHILE Y.CUR.STMT.NO LE T.TOT.STMT.CNT
        Y.STMT.ID=FIELD(Y.ID.LIST<Y.CUR.STMT.NO>,'*',2)
        GOSUB PROCESS.STMT
        Y.CUR.STMT.NO++
    REPEAT
RETURN
******************
PROCESS.DATA.COB:
******************
    CALL F.READ(FN.ACCT.EL.DAY,Y.ACCT.ID,Y.ID.LIST,F.ACCT.EL.DAY,ERR)
    T.TOT.STMT.CNT=DCOUNT(Y.ID.LIST,@FM)
    Y.CUR.STMT.NO=1
    LOOP
    WHILE Y.CUR.STMT.NO LE T.TOT.STMT.CNT
        Y.STMT.ID=Y.ID.LIST<Y.CUR.STMT.NO>
        GOSUB PROCESS.STMT
        Y.CUR.STMT.NO++
    REPEAT
RETURN

************
PROCESS.STMT:
************
    CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,Y.ERR)
    IF NOT(R.STMT.ENTRY) THEN
        RETURN
    END

    IF Y.VALD.SEL.LIST THEN
        Y.VAL.DATE=R.STMT.ENTRY<AC.STE.VALUE.DATE>
        LOCATE Y.VAL.DATE IN Y.VALD.SEL.LIST<1,1,1> SETTING Y.VALD.SEL.POS ELSE
            RETURN
        END
    END

    GOSUB GET.BRANCH
    CHANGE ',' TO '-' IN Y.VERSION
    Y.ARR.ID  =FIELD(R.STMT.ENTRY<AC.STE.AA.ITEM.REF>,'*',4)
    Y.STMT.NOS=R.STMT.ENTRY<AC.STE.STMT.NO,1>
    Y.FIN.DATA=R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>:Y.DLM:Y.COMPANY.ID.DR:Y.DLM:Y.COMPANY.ID.CR:Y.DLM:R.STMT.ENTRY<AC.STE.BOOKING.DATE>:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:R.STMT.ENTRY<AC.STE.VALUE.DATE>:Y.DLM:R.STMT.ENTRY<AC.STE.CURRENCY>:Y.DLM:R.STMT.ENTRY<AC.STE.AMOUNT.LCY>:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:Y.DB.CR.FG:Y.DLM:Y.AGE:Y.DLM:Y.TXN.TYPE:Y.DLM:R.STMT.ENTRY<AC.STE.CUSTOMER.ID>:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:Y.VERSION:Y.DLM:Y.COMMENTS:Y.DLM:R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>:Y.DLM:Y.ARR.ID:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:Y.STMT.NOS:Y.DLM:R.STMT.ENTRY<AC.STE.OUR.REFERENCE>:Y.DLM:R.STMT.ENTRY<AC.STE.THEIR.REFERENCE>:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:R.STMT.ENTRY<AC.STE.NARRATIVE>:Y.DLM:Y.DEL.OUT.REF:Y.DLM:Y.STMT.ID:Y.DLM
    Y.FIN.DATA=Y.FIN.DATA:FIELD(R.STMT.ENTRY<AC.STE.INPUTTER>,'_',2):Y.DLM:FIELD(R.STMT.ENTRY<AC.STE.AUTHORISER>,'_',2)
    Y.COMPANY.ID.CR=''; Y.COMPANY.ID.DR='';  Y.TXN.TYPE=''; Y.VERSION =''; Y.STMT.NOS=''; Y.COMMENTS=''; Y.STMT.ID =''
    Y.FIN.ARRAY<-1>=Y.FIN.DATA
RETURN

***********
GET.BRANCH:
***********
    Y.TRANS.REFERENCE = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.COMPANY.MNE = FIELD(Y.TRANS.REFERENCE,'\',2,1)
    Y.COMPANY.ID  = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
    IF Y.COMPANY.MNE NE '' THEN
        LOCATE Y.COMPANY.MNE IN Y.COMPANY.MNE.LIST SETTING Y.COMPANY.MNE.POS THEN
            Y.COMPANY.ID=Y.COMPANY.LIST<Y.COMPANY.MNE.POS>
        END
    END
    IF R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
        Y.DB.CR.FG='CREDIT'
        Y.COMPANY.ID.CR=Y.COMPANY.ID
    END ELSE
        Y.DB.CR.FG='DEBIT'
        Y.COMPANY.ID.DR=Y.COMPANY.ID
    END
    Y.BK.DATE=R.STMT.ENTRY<AC.STE.BOOKING.DATE>
    Y.PR.DATE=R.DATES(EB.DAT.LAST.WORKING.DAY)
    IF Y.REP.DATE NE R.DATES(EB.DAT.LAST.WORKING.DAY) THEN
        Y.PR.DATE=TODAY
    END
    Y.AGE='C'
    IF Y.BK.DATE AND Y.PR.DATE THEN
        CALL CDD('',Y.BK.DATE,Y.PR.DATE,Y.AGE)
    END
    Y.OUR.REF=R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    Y.OUR.REF.APP=Y.OUR.REF[1,2]

    R.TT = ''; Y.ERR = ''; R.FT = ''
    IF Y.OUR.REF.APP EQ 'FT' THEN
        CALL F.READ(FN.FT,Y.OUR.REF,R.FT,F.FT,Y.ERR)
        IF NOT(R.FT) THEN
            Y.OUR.REF.HIS=Y.OUR.REF
            CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.OUR.REF.HIS,R.FT,Y.ERROR)
        END
        Y.TXN.TYPE=R.FT<FT.TRANSACTION.TYPE>
        IF Y.TXN.TYPE THEN
            CALL F.READ(FN.FTTC,Y.TXN.TYPE,R.FTTC,F.FTTC,Y.ERR)
            Y.TXN.TYPE=R.FTTC<FT6.DESCRIPTION,1>
        END
        Y.VERSION=R.FT<FT.PAYMENT.DETAILS>
        IF NOT(Y.VERSION) THEN
            Y.VERSION =R.FT<FT.LOCAL.REF><1,Y.FT.ACT.VER.POS>
        END
        Y.COMMENTS=R.FT<FT.LOCAL.REF><1,Y.FT.LOC.CMT.POS>
        Y.DEL.OUT.REF=R.FT<FT.DELIVERY.OUTREF>
    END
    IF Y.OUR.REF.APP EQ 'TT' THEN
        CALL F.READ(FN.TT,Y.OUR.REF,R.TT,F.TT,Y.ERR)
        IF NOT(R.TT) THEN
            Y.OUR.REF.HIS=Y.OUR.REF
            CALL EB.READ.HISTORY.REC(F.TT.HIS,Y.OUR.REF.HIS,R.TT,Y.ERROR)
        END
        Y.TXN.TYPE=R.TT<TT.TE.TRANSACTION.CODE>
        IF  Y.TXN.TYPE THEN
            CALL F.READ(FN.TT.TXN,Y.TXN.TYPE,R.TT.TXN,F.TT.TXN,ERR)
            Y.TXN.TYPE=R.TT.TXN<TT.TR.DESC>
        END
        Y.VERSION =R.TT<TT.TE.LOCAL.REF><1,Y.TT.ACT.VER.POS>
        Y.COMMENTS=R.TT<TT.TE.LOCAL.REF><1,Y.TT.LOC.CMT.POS>
    END
RETURN

************
GET.LINE.NO:
************
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''
    CALL F.READ(FN.EB.CONT.BAL.CA,Y.ACCT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONT.BAL.CA,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY    = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART   = FIELD(Y.CONSOL.KEY,'.',1,16)
        YCRF.TYPE       =R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        R.LINE = ''; REP.ERR = ''
        CALL F.READ(FN.RE.STAT.REP.LINE.CA,Y.LINE,R.LINE,F.RE.STAT.REP.LINE.CA,REP.ERR)
        Y.LINE.NO= R.LINE<RE.SRL.DESC,1>
    END
RETURN

**********
WRITE.DATA:
**********
    IF Y.FIN.ARRAY THEN
        Y.REC.COUNT = DCOUNT(Y.FIN.ARRAY,@FM)
        Y.REC.START = 1
        LOOP
        WHILE Y.REC.START LE Y.REC.COUNT
            Y.REC.LINE = Y.FIN.ARRAY<Y.REC.START>
            Y.COMP.ID  = FIELD(Y.REC.LINE,Y.DLM,2)
            IF NOT(Y.COMP.ID) THEN
                Y.COMP.ID  =FIELD(Y.REC.LINE,Y.DLM,3)
            END
            Y.SORT.VAL = FIELD(Y.REC.LINE,Y.DLM,1):Y.COMP.ID:FIELD(Y.REC.LINE,Y.DLM,6):FIELD(Y.REC.LINE,Y.DLM,5)
            Y.FILE.NAME=FILE.NAME:Y.SORT.VAL:SESSION.NO
            OPENSEQ TEMP.PATH,Y.FILE.NAME TO SEQ.PTR ELSE
                ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
                CREATE SEQ.PTR ELSE
                    ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
                    INT.CODE = 'REP001'
                    INT.TYPE = 'BATCH'
                    MON.TP   = 04
                    REC.CON  = 'RECONRPT':ERR.MSG
                    DESC     = 'RECONRPT':ERR.MSG
                    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
                END
            END
            GOSUB WR.SEQ.FILE
            Y.REC.START += 1
        REPEAT
    END
RETURN

***********
WR.SEQ.FILE:
***********

    WRITESEQ Y.REC.LINE APPEND TO SEQ.PTR ELSE
        ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'BATCH'
        MON.TP   = 04
        REC.CON  = 'RECONRPT':ERR.MSG
        DESC     = 'RECONRPT':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
END
