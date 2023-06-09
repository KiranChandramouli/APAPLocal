*-----------------------------------------------------------------------------
* <Rating>70</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.AA.TC.MIG.DREPORT(AA.ACT.ID)

* Routine to generate the current day report
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCOUNT
    $INSERT LAPAP.BP I_L.APAP.AA.TC.MIG.DREPORT.COMMON


    GOSUB PROCESS
    RETURN

PROCESS:
********
    ERR.AA.ARRANGEMENT = ''; R.AA.ARRANGEMENT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ACT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARRANGEMENT)
    YPRD.GRP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    IF YPRD.GRP NE 'LINEAS.DE.CREDITO.TC' THEN RETURN

    YAA.CUST = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER,1>
    YAA.EFFDTE = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE,1>
    YAA.CONT.DTE = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE,1>
    YAA.ACCT.ID= R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
    YAA.CO.CODE = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    STAR.DATE.VAL = R.AA.ARRANGEMENT<AA.ARR.START.DATE,1>
    YAA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT,1>

    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''
    Y.PREV.ACCOUNT = ''; Y.PREV.ACCOUNT.1 = ''
    CALL F.READ(FN.ACCOUNT,YAA.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'T.DEBITO.1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    LOCATE 'T.DEBITO.2' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POSN THEN
        Y.PREV.ACCOUNT.1 = Y.ALT.ACCT.ID<1,ALT.TYPE.POSN>
    END

    GOSUB GET.BALANCES
    YTOT.AMT = 0; YTOT.AMT = YACCT.GRP + YPRINCIP.GRP + YPRINCIPTC.GRP + YCOMM.GRP

    RETURN.MSG = ''
    RETURN.MSG = YAA.PROD:',':YAA.CUST:',':YAA.CONT.DTE:',':YACCT.GRP:',':YAA.EFFDTE:',':Y.PREV.ACCOUNT:',':Y.PREV.ACCOUNT.1:',':YAA.ACCT.ID:',0,0,':YACCT.GRP:',':YPRINCIP.GRP:',':YPRINCIPTC.GRP:',':YCOMM.GRP:',':YTOT.AMT
    IF RETURN.MSG THEN
        CALL F.WRITE(FN.L.APAP.TC.MIG.WORKFILE,AA.ACT.ID,RETURN.MSG)
    END
    RETURN

GET.BALANCES:
*************
    AC.LEN = 9; PRIN.INT.LEN = 14; PRINTC.INT.LEN = 15; COMMTC.LEN = 10
    YACCT.GRP = 0; YPRINCIP.GRP = 0; YPRINCIPTC.GRP = 0; YCOMM.GRP = 0
    EB.CONTRACT.BALANCES.ERR = ''; R.EB.CONTRACT.BALANCES = ''; Y.ASSET.TYPE = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCE,YAA.ACCT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCE,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.ASSET.TYPE = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
        CTR.BAL.TYPE = 1
        CNT.BAL.TYPE = DCOUNT(Y.ASSET.TYPE,VM)
        LOOP
        WHILE CTR.BAL.TYPE LE CNT.BAL.TYPE
            Y.ASSET.TYPE.TP = ''; BAL.TYPE1 = ''
            BAL.TYPE1 = Y.ASSET.TYPE<1,CTR.BAL.TYPE>
            Y.ASSET.TYPE.TP = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE,CTR.BAL.TYPE>
            LEN.TYPE = LEN(BAL.TYPE1)
            REQ.LEN = BAL.TYPE1[((LEN.TYPE-AC.LEN)+1),AC.LEN]
            REQ.INT.LEN = BAL.TYPE1[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
            REQ.INTTC.LEN = BAL.TYPE1[((LEN.TYPE-PRINTC.INT.LEN)+1),PRINTC.INT.LEN]
            REQ.COMM.LEN = BAL.TYPE1[((LEN.TYPE-COMMTC.LEN)+1),COMMTC.LEN]

            IF (REQ.LEN EQ 'ACCOUNTTC') OR (REQ.INT.LEN EQ 'PRINCIPALINTTC') OR (REQ.INTTC.LEN EQ 'PRINCIPALINTTCC') OR (REQ.COMM.LEN EQ 'COMISIONTC') THEN
                GOSUB REG.ACCOUNT.NO
            END
            CTR.BAL.TYPE += 1
        REPEAT
    END
    RETURN

REG.ACCOUNT.NO:
***************
    REQUEST.TYPE = ''; START.DATE = STAR.DATE.VAL; END.DATE = YLST.DAYS; REQUEST.TYPE<4>='ECB'
    BAL.DETAILS = ''; ERROR.MESSAGE = ''; DAT.BALANCES = 0
    CALL AA.GET.PERIOD.BALANCES(YAA.ACCT.ID, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    DAT.BALANCES = ABS(BAL.DETAILS<4>)

    IF REQ.LEN EQ 'ACCOUNTTC' THEN
        YACCT.GRP += DAT.BALANCES
    END
    IF REQ.INT.LEN EQ 'PRINCIPALINTTC' THEN
        YPRINCIP.GRP += DAT.BALANCES
    END
    IF REQ.INTTC.LEN EQ 'PRINCIPALINTTCC' THEN
        YPRINCIPTC.GRP += DAT.BALANCES
    END
    IF REQ.COMM.LEN EQ 'COMISIONTC' THEN
        YCOMM.GRP += DAT.BALANCES
    END
    RETURN

END
