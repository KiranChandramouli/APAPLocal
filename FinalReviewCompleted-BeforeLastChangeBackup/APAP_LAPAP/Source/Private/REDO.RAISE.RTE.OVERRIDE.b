* @ValidationCode : MjoxODM4MjY4NTA1OkNwMTI1MjoxNjk5MjcxNTQxODc1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Nov 2023 17:22:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.RAISE.RTE.OVERRIDE
*-----------------------------------------------------------

*-----------------------------------------------------------
* Input  Arg: N/A
* Output Arg: N/A
* Deals With: TO Raise RTE Override
*-----------------------------------------------------------
* Who           Date           Dev Ref           Modification
* APAP          09 Jan 2017    RTE Fix           Initial Draft
*13/07/2023      Conversion tool            R22 Auto Conversion           FM TO @FM, VM TO @VM, SM TO @SM, INCLUDE TO INSERT, BP removed in INSERT file, I TO I.VAR, J TO J.VAR, K TO K.VAR, S TO S.VAR, X TO X.VAR, M TO M.VAR
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*-----------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.VERSION
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.AA.OVERPAYMENT
    $INSERT I_System
    $INSERT I_F.REDO.RTE.CUST.CASHTXN
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 Auto Conversion - End
    $INSERT I_F.T24.FUND.SERVICES ;* R22 Manual Conversion


    IF OFS$OPERATION NE 'PROCESS' THEN
        RETURN
    END

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')

    GOSUB OPEN.FILES
    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)
    Y.FCY.AMT.1 = ''
    Y.AMT.LOCAL.2 = ''
    Y.USD.CONV.AMT = ''
    Y.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.PARAM.ID,R.AML.PARAM,AML.ERR)
    Y.AMT.LIMIT.LCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>
    Y.AMT.LIMIT.FCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    R.REDO.H.REPORTS.PARAM = ''
    RTE.PARAM.ERR = ''
    RTE.PARAM.ID = 'REDO.RTE.FORM'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,RTE.PARAM.ID,R.REDO.H.REPORTS.PARAM,RTE.PARAM.ERR)

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GET.APPLICATION = 'TELLER'

        CASE ID.NEW[1,2] EQ 'FT'
            GET.APPLICATION = 'FUNDS.TRANSFER'

        CASE OTHERWISE
            Y.FLAG = 1
    END CASE

    Y.CURRENT.VERSION = GET.APPLICATION:PGM.VERSION

    IF Y.CURRENT.VERSION EQ 'TELLER,L.APAP.PAY.EPAYIT.DGII' THEN
        GOSUB GET.TRANSACTION.AMOUNT
        IF CUR.TXN.AMT LT Y.AMT.LIMIT.LCY THEN
            RETURN
        END
    END

    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "RTE.VERSIONS" IN Y.FIELD.NME.ARR<1,1> SETTING RTE.VER.POS THEN
        Y.RTE.VERSIONS = Y.FIELD.VAL.ARR<1,RTE.VER.POS>
    END
    Y.RTE.VERSIONS = CHANGE(Y.RTE.VERSIONS,@SM,@VM)
    LOCATE Y.CURRENT.VERSION IN Y.RTE.VERSIONS<1,1> SETTING RTE.CHK.POS ELSE
        RETURN
    END

    LOCATE "OVERPAYMENT.CASH" IN Y.FIELD.NME.ARR<1,1> SETTING OVERP.VER.POS THEN
        Y.OVERPAY.VERSIONS = Y.FIELD.VAL.ARR<1,OVERP.VER.POS>
    END
    Y.OVERPAY.VERSIONS = CHANGE(Y.OVERPAY.VERSIONS,@SM,@VM)

    LOCATE "CASH.FX" IN Y.FIELD.NME.ARR<1,1> SETTING FX.VER.POS THEN
        Y.FX.VERSIONS = Y.FIELD.VAL.ARR<1,FX.VER.POS>
    END
    Y.FX.VERSIONS = CHANGE(Y.FX.VERSIONS,@SM,@VM)
    IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        LOCATE Y.CURRENT.VERSION IN Y.FX.VERSIONS<1,1> SETTING VER.CHK.POS THEN
            Y.ID.VAL.TXN.FLAG = 'Y'
        END
    END
    IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'FX' THEN
        LOCATE Y.CURRENT.VERSION IN Y.FX.VERSIONS<1,1> SETTING VER.CHK.POS THEN
            Y.FX.TXN.FLAG = 'Y'
        END
        ELSE
            RETURN
        END
    END

    LOCATE "RTE.CHQ" IN Y.FIELD.NME.ARR<1,1> SETTING CHQ.VER.POS THEN
        Y.CHQ.VERSIONS = Y.FIELD.VAL.ARR<1,CHQ.VER.POS>
    END
    Y.CHQ.VERSIONS = CHANGE(Y.CHQ.VERSIONS,@SM,@VM)
    LOCATE Y.CURRENT.VERSION IN Y.CHQ.VERSIONS<1,1> SETTING VER.CHQ.POS THEN
        Y.CHQ.TXN.FLAG = 'Y'
    END

    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
    VAR.OVERRIDE.ID = 'AML.TXN.AMT.EXCEED'

    IF ID.NEW[1,2] EQ 'TT' THEN
        Y.INITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.INIT.ID>
        Y.NEXT.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.NXT.VER>
        Y.RECORD.STATUS = R.NEW(TT.TE.RECORD.STATUS)
        Y.ACCT.ID = R.NEW(TT.TE.ACCOUNT.2)
        IF Y.CURRENT.VERSION EQ Y.OVERPAY.VERSIONS THEN
            Y.ACCT.ID = R.NEW(TT.TE.NARRATIVE.1)<1,1>
        END
    END ELSE
        IF ID.NEW[1,2] EQ 'FT' THEN
            Y.INITIAL.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.INIT.ID>
            Y.NEXT.VERSION = R.NEW(FT.LOCAL.REF)<1,POS.FT.NXT.VER>
            Y.RECORD.STATUS = R.NEW(FT.RECORD.STATUS)
            Y.ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
        END
    END
    IF Y.INITIAL.ID AND V$FUNCTION NE 'D' THEN
        READ R.TMP.RTC.REC FROM F.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID THEN
            LOCATE ID.NEW IN R.TMP.RTC.REC<RTC.TRANS.ID,1> SETTING TMP.POS THEN
                GET.RTE.TXNS = System.getVariable('CURRENT.RTE.TXNS')
            END ELSE
                GET.RTE.TXNS = ''
            END
        END ELSE
            GET.RTE.TXNS = ''
        END
    END
    IF (V$FUNCTION EQ 'D' AND Y.RECORD.STATUS EQ 'INAU') OR (V$FUNCTION EQ 'D' AND Y.RECORD.STATUS EQ 'INAO') OR (V$FUNCTION EQ 'R' AND Y.RECORD.STATUS EQ '' AND R.VERSION(EB.VER.NO.OF.AUTH) EQ 0)  THEN

        GOSUB GET.CUSTOMER.ID
        IF Y.JOINT.CUSTOMERS THEN
            Y.CUS.ACC.ID = CUS.ACC.ID:@VM:Y.JOINT.CUSTOMERS
        END ELSE
            Y.CUS.ACC.ID = CUS.ACC.ID
        END
        Y.CUST.CNT = DCOUNT(Y.CUS.ACC.ID,@VM)
        FOR K.VAR = 1 TO Y.CUST.CNT ;*R22 Auto Conversion
            Y.RTE.ID = Y.CUS.ACC.ID<1,K.VAR>:'.':Y.CAL.TODAY ;*R22 Auto Conversion
            REDO.RTE.CUST.CASHTXN.ERR = ''
            CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,RTE)
            IF R.REDO.RTE.CUST.CASHTXN THEN
                LOCATE ID.NEW IN R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,1> SETTING RTE.ID.POS THEN
                    R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,RTE.ID.POS> = ''
                    R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,RTE.ID.POS> = V$FUNCTION
                    R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,RTE.ID.POS> = 'REVERTED'
                    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                END
            END
        NEXT K.VAR
    END


    IF Y.INITIAL.ID EQ ID.NEW AND Y.NEXT.VERSION EQ '' THEN
        YDR.UNIT = R.NEW(TT.TE.DR.UNIT)
        DR.CNT = DCOUNT(YDR.UNIT,@VM)
        FOR I.VAR = 1 TO DR.CNT ;*R22 Auto Conversion
            IF R.NEW(TT.TE.DR.UNIT)<1,I.VAR> GT 0 THEN ;*R22 Auto Conversion
                Y.DR.UNIT += R.NEW(TT.TE.DR.UNIT)<1,I.VAR> ;*R22 Auto Conversion
                Y.CASH.FLAG = 'Y'
                BREAK
            END
        NEXT I.VAR ;*R22 Auto Conversion
        IF Y.CASH.FLAG EQ 'Y' THEN
            Y.ACCT.ID = R.NEW(TT.TE.ACCOUNT.2)
            IF Y.CURRENT.VERSION EQ Y.OVERPAY.VERSIONS THEN
                Y.ACCT.ID = R.NEW(TT.TE.NARRATIVE.1)<1,1>
            END
            RTE.TXN.CCY = R.NEW(TT.TE.CURRENCY.1)
            GOSUB GET.CUSTOMER.ID
***-------------------------------todo
            GOSUB GET.EPAYIT.VERSION
***-----------------------------------
            IF NOT(CUS.ACC.ID) THEN
                RETURN
            END

            GOSUB GET.TRANSACTION.AMOUNT

            Y.RTE.ID = CUS.ACC.ID:'.':Y.CAL.TODAY
            CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
* Changes based on the new requirement
            GOSUB VERIFY.RTE.CASH.TXN

            Y.CUST.CNT = DCOUNT(Y.JOINT.CUSTOMERS,@VM)
            FOR K.VAR = 1 TO Y.CUST.CNT ;*R22 Auto Conversion
                Y.RTE.ID = CUS.ACC.ID:'.':Y.CAL.TODAY
                Y.RTE.ID = Y.JOINT.CUSTOMERS<1,K.VAR>:'.':Y.CAL.TODAY ;*R22 Auto Conversion
*                GOSUB UPDATE.CUST.CASHTXN
* Changes based on the new requirement
                CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
                Y.RTE.FLAG.RESET = ''
                GOSUB VERIFY.RTE.CASH.TXN
            NEXT K.VAR ;*R22 Auto Conversion
        END

    END

    IF GET.RTE.TXNS NE 'CURRENT.RTE.TXNS' AND GET.RTE.TXNS NE '' THEN
        IF OFS$SOURCE.ID NE 'FASTPATH' THEN
            IF ID.NEW[1,2] EQ 'TT' THEN
                T(TT.TE.CUSTOMER.2)<3> = "NOINPUT"
                T(TT.TE.ACCOUNT.2)<3> = "NOINPUT"
                T(TT.TE.AMOUNT.LOCAL.1)<3> = "NOINPUT"
                T(TT.TE.NARRATIVE.2)<3> = "NOINPUT"
                T.LOCREF<POS.TT.NXT.VER,7>="NOINPUT"
            END ELSE
                IF ID.NEW[1,2] EQ 'FT' THEN
                    T(FT.CREDIT.ACCT.NO)<3> = "NOINPUT"
                    T(FT.CREDIT.VALUE.DATE)<3> = "NOINPUT"
                    T(FT.CREDIT.AMOUNT)<3> = "NOINPUT"
                    T(FT.CREDIT.ACCT.NO)<3> = "NOINPUT"
                    T.LOCREF<POS.FT.NO.INSTAL,7>="NOINPUT"
                    T.LOCREF<POS.FT.ADV.INS.CNT,7>="NOINPUT"
                    T.LOCREF<POS.FT.AA.PART.ALLOW,7>="NOINPUT"
                    T.LOCREF<POS.FT.NXT.VER,7>="NOINPUT"
                END
            END

            TEXT = VAR.OVERRIDE.ID
            CALL STORE.OVERRIDE(CURR.NO+1)
        END ELSE
            FINDSTR ID.NEW IN GET.RTE.TXNS SETTING RTE.TXN.POS THEN
                TEXT = VAR.OVERRIDE.ID
                CALL STORE.OVERRIDE(CURR.NO+1)
            END

        END
    END

    IF GET.RTE.TXNS EQ '' THEN
        GET.RTE.TXNS = "CURRENT.RTE.TXNS"
        CALL System.setVariable("CURRENT.RTE.TXNS",GET.RTE.TXNS)
    END
RETURN
*-----------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY  = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.FTTC='F.FT.TXN.TYPE.CONDITION'
    F.FTTC=''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
    F.REDO.AML.PARAM=''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    FN.TRANSACTION='F.TRANSACTION'
    F.TRANSACTION=''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.REDO.CREDIT.TRANS.TELLER = 'F.REDO.CREDIT.TRANS.TELLER'
    F.REDO.CREDIT.TRANS.TELLER  = ''
    CALL OPF(FN.REDO.CREDIT.TRANS.TELLER,F.REDO.CREDIT.TRANS.TELLER)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    LRF.APP='TRANSACTION':@FM:'CURRENCY':@FM:'FUNDS.TRANSFER':@FM:'TELLER'
    LRF.FIELD='L.TR.AML.CHECK':@FM:'L.CU.AMLBUY.RT':@FM:'L.RTE.FORM':@VM:'L.NEXT.VERSION':@VM:'L.INITIAL.ID':@VM:'L.NO.OF.INSTAL':@VM:'L.ADV.INS.CNT':@VM:'L.AA.PART.ALLOW':@FM:'L.NEXT.VERSION':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.LEGAL.ID':@VM:'L.INITIAL.ID'
    LRF.POS=''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    POS.L.TR.AML.CHECK = LRF.POS<1,1>
    POS.L.CU.AMLBUY.RT = LRF.POS<2,1>
    POS.L.RTE.FORM     = LRF.POS<3,1>
    POS.FT.NXT.VER = LRF.POS<3,2>
    POS.FT.INIT.ID = LRF.POS<3,3>
    POS.FT.NO.INSTAL = LRF.POS<3,4>
    POS.FT.ADV.INS.CNT = LRF.POS<3,5>
    POS.FT.AA.PART.ALLOW = LRF.POS<3,6>
    POS.TT.NXT.VER = LRF.POS<4,1>
    POS.CUSTOMER.CODE = LRF.POS<4,2>
    POS.TT.LEGAL.ID = LRF.POS<4,3>
    POS.TT.INIT.ID  = LRF.POS<4,4>

    Y.JOINT.RTE.FLAG = ''
    Y.JOINT.FLAG = ''
    Y.RTE.FLAG.RESET = ''

RETURN

********************
UPDATE.CUST.CASHTXN:
********************

    Y.FUNC = V$FUNCTION
    REDO.RTE.CUST.CASHTXN.ERR = ''
    CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,RTE)
    IF R.REDO.RTE.CUST.CASHTXN THEN
        LOCATE ID.NEW IN R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,1> SETTING RTE.ID.POS ELSE
            R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,-1> = ID.NEW
            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = CUR.TXN.AMT
*            R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,-1> = R.CUSTOMER.DETAILS<2,C,D>
            R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID,-1> = Y.INITIAL.ID
            R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE,-1> = ID.COMPANY
*            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = R.CUSTOMER.DETAILS<3,C,D>
            R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,-1> = TIMEDATE()
            R.REDO.RTE.CUST.CASHTXN<RTE.ACTUAL.VERSION,-1> = Y.CURRENT.VERSION
            R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,-1> = Y.FUNC
            IF Y.RTE.FLAG.RESET EQ '' THEN
                Y.RTE.FLAG.RESET = 'IN PROGRESS'
            END
            R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,-1> = Y.RTE.FLAG.RESET

            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
        END
    END
    ELSE
        R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID> = ID.NEW
        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = CUR.TXN.AMT
*        R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID> = R.CUSTOMER.DETAILS<2,C,D>
        R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID> = Y.INITIAL.ID
        R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE> = ID.COMPANY
*        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = R.CUSTOMER.DETAILS<3,C,D>
        R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE> = TIMEDATE()
        R.REDO.RTE.CUST.CASHTXN<RTE.ACTUAL.VERSION> = Y.CURRENT.VERSION
        R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION> = Y.FUNC
        IF Y.RTE.FLAG.RESET EQ '' THEN
            Y.RTE.FLAG.RESET = 'IN PROGRESS'
        END
        R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG> = Y.RTE.FLAG.RESET
        CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
    END
RETURN

*-----------------------------------------------------------
GET.CUSTOMER.ID:
*-----------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUSTOMER.CODE = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUSTOMER.CODE THEN
        CUS.ACC.ID = Y.CUSTOMER.CODE
    END ELSE
*        IF Y.CASH.FLAG EQ 'Y' THEN
        Y.CUSTOMER.CODE = R.NEW(TT.TE.LOCAL.REF)<1,POS.CUSTOMER.CODE>
*        END
        IF NUM(Y.CUSTOMER.CODE[1,2]) AND Y.CUSTOMER.CODE NE '' THEN
            CUS.ACC.ID = Y.CUSTOMER.CODE
        END
    END
    IF (Y.FX.TXN.FLAG EQ 'Y' OR Y.ID.VAL.TXN.FLAG EQ 'Y') AND (CUS.ACC.ID EQ '' OR CUS.ACC.ID EQ 'NA') THEN
        YLEG.TT.VAL = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.LEGAL.ID>
        IF YLEG.TT.VAL THEN
            CUS.ACC.ID = FIELD(YLEG.TT.VAL,'.',1):'.':FIELD(YLEG.TT.VAL,'.',2)
        END
    END

    Y.JOINT.CUSTOMERS = ''
    IF CUS.ACC.ID THEN
        IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
            Y.JOINT.CUSTOMERS = R.ACCOUNT<AC.JOINT.HOLDER>
        END
    END

RETURN

GET.EPAYIT.VERSION:
    PRINTTIME = TIMEDATE()
    Y.CLIENTE.VIRTUAL = 'EPAYIT':PRINTTIME
    IF NOT(CUS.ACC.ID) AND Y.CURRENT.VERSION EQ 'TELLER,L.APAP.BILL.PAY.EPAYIT.CASH' THEN
        CUS.ACC.ID = Y.CLIENTE.VIRTUAL

    END

RETURN

*-----------------------------------------------------------
GET.TRANSACTION.AMOUNT:
*-----------------------------------------------------------


    RTE.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    RTE.TXN.CCY = 'USD'

    CALL CACHE.READ(FN.CURRENCY,RTE.TXN.CCY,R.CURRENCY,CURR.ERR)
    CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,POS.L.CU.AMLBUY.RT>


    CUR.TXN.AMT = RTE.TXN.AMT
    TT.LCCY     = LCCY

    IF (Y.FX.TXN.FLAG EQ 'Y' OR Y.ID.VAL.TXN.FLAG EQ 'Y') THEN
        RTE.CCY.1 = R.NEW(TT.TE.ACCOUNT.1)[1,3]

        BEGIN CASE
            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT' AND RTE.CCY.1 EQ LCCY
                CUR.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.2)
            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT' AND RTE.CCY.1 NE LCCY
                CUR.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' AND RTE.CCY.1 EQ LCCY
                CUR.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' AND RTE.CCY.1 NE LCCY
                CUR.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.2)
        END CASE

        RTE.TXN.CCY = R.NEW(TT.TE.CURRENCY.1)
        IF RTE.TXN.CCY EQ 'USD' THEN
            Y.FCY.AMT.1 =  R.NEW(TT.TE.AMOUNT.FCY.1)
            IF Y.FCY.AMT.1 NE '' THEN
                CUR.TXN.AMT = Y.FCY.AMT.1 * CUR.AMLBUY.RATE
            END
        END ELSE
            IF RTE.TXN.CCY EQ 'EUR' THEN
                Y.AMT.LOCAL.2 = R.NEW(TT.TE.AMOUNT.LOCAL.2)
                IF Y.AMT.LOCAL.2 NE '' THEN
                    LOCATE '10' IN R.CURRENCY<EB.CUR.CURRENCY.MARKET,1> SETTING CCY.MARKET.POS THEN
                        Y.USD.CONV.AMT = Y.AMT.LOCAL.2 / R.CURRENCY<EB.CUR.SELL.RATE,CCY.MARKET.POS>
                        IF Y.USD.CONV.AMT NE '' THEN
                            CUR.TXN.AMT = Y.USD.CONV.AMT * CUR.AMLBUY.RATE
                        END
                    END
                END
            END
        END
    END

    IF Y.CHQ.TXN.FLAG EQ 'Y' THEN
        CUR.TXN.AMT = R.NEW(TT.TE.NET.AMOUNT)
    END

RETURN

*********************
VERIFY.RTE.CASH.TXN:
*********************

    Y.LOOP.AMT = ''
    Y.BREAK.FLAG = ''
    Y.LOOP.AMT.TDY = ''
    Y.AMT.CNT = ''

* RTE - TODAY RECORD reverse LOOP
    IF R.REDO.RTE.CUST.CASHTXN THEN
        Y.CASH.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>
        Y.AMT.CNT = DCOUNT(Y.CASH.AMOUNT.LIST,@VM)
*        FOR J = Y.AMT.CNT TO 1
        J.VAR = Y.AMT.CNT ;*R22 Auto Conversion
        LOOP
        WHILE J.VAR NE 0 ;*R22 Auto Conversion
*         Y.VERS.TOT.AMT += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J>

            Y.TRANS.DATE = R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,J.VAR> ;*R22 Auto Conversion
            Y.FLAG.RESET = R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,J.VAR> ;*R22 Auto Conversion
            Y.CURRENT.TIME = OCONV(TIME(),'MTS')
            Y.CURRENT.SECS = ICONV(Y.CURRENT.TIME,'MTH')
            Y.TRANS.DATE.SECS = ICONV(Y.TRANS.DATE[1,8],'MTH')

            BEGIN CASE
                CASE Y.FLAG.RESET EQ 'STARTED'
                    IF Y.TRANS.DATE.SECS LE Y.CURRENT.SECS THEN
                        Y.LOOP.AMT.TDY += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J.VAR> ;*R22 Auto Conversion
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + CUR.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
                            GOSUB UPDATE.CUST.CASHTXN
                        END
                        Y.BREAK.FLAG = 1
                        BREAK     ;* Break as the STARTED flag has been found in today's rte record itself.
                    END
                CASE OTHERWISE
                    Y.LOOP.AMT.TDY += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J.VAR>
            END CASE
            J.VAR -= 1
        REPEAT

        IF Y.BREAK.FLAG NE 1 THEN
*  CHECK THE YESTERDAY RTE RECORD.
            GOSUB CHECK.YESTERDAY.RTE.REC
        END
    END ELSE
        GOSUB CHECK.YESTERDAY.RTE.REC

    END
RETURN

*************************
CHECK.YESTERDAY.RTE.REC:
*************************

    Y.LOOP.AMT.YSTRDY = ''
    Y.RTE.FLAG.RESET = ''

    Y.YESTERDAY.DATE = Y.CAL.TODAY
    CALL CDT('',Y.YESTERDAY.DATE,'-1C')
*    Y.LAST.RTE.ID = CUS.ACC.ID:'.':Y.YESTERDAY.DATE
    Y.LAST.RTE.ID = FIELD(Y.RTE.ID,'.',1):'.':Y.YESTERDAY.DATE
    CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
    IF R.REDO.RTE.CUST.CASHTXN.YSTRDY THEN
        Y.YSTRDY.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT>
        Y.YSTRDY.AMT.CNT = DCOUNT(Y.YSTRDY.AMOUNT.LIST,@VM)
        X.VAR = Y.YSTRDY.AMT.CNT
*        FOR X = Y.YSTRDY.AMT.CNT TO 1
        LOOP
        WHILE X.VAR NE 0 ;*R22 Auto Conversion
            Y.TRANS.DATE.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.TRANS.DATE,X.VAR> ;*R22 Auto Conversion
            Y.FLAG.RESET.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> ;*R22 Auto Conversion
            Y.CURRENT.TIME.YSTRDY = OCONV(TIME(),'MTS')
            Y.CURRENT.SECS.YSTRDY = ICONV(Y.CURRENT.TIME.YSTRDY,'MTH')
            Y.TRANS.DATE.SECS.YSTRDY = ICONV(Y.TRANS.DATE.YSTRDY[1,8],'MTH')
            BEGIN CASE

                CASE Y.FLAG.RESET.YSTRDY EQ 'STARTED'
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR> ;*R22 Auto Conversion
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CUR.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
                            GOSUB UPDATE.CUST.CASHTXN
                        END
                    END ELSE
                        Y.LOOP.AMT.YSTRDY.CUR = Y.LOOP.AMT.YSTRDY + R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY.CUR + Y.LOOP.AMT.TDY
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED' ;*R22 Auto Conversion
                            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY)
                            Y.RTE.TOT.AMT = CUR.TXN.AMT / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.CUST.CASHTXN       ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
                                VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                                TEXT    = VAR.OVERRIDE.ID
                                CALL STORE.OVERRIDE(CURR.NO+1)
                            END ELSE
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.CUST.CASHTXN
                            END
                        END ELSE

                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED' ;*R22 Auto Conversion
                            GOSUB RTE.RESET.CHECK
                            Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CUR.TXN.AMT
                            Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                GOSUB UPDATE.CUST.CASHTXN       ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
                                VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                                TEXT    = VAR.OVERRIDE.ID
                                CALL STORE.OVERRIDE(CURR.NO+1)
                            END ELSE
                                GOSUB UPDATE.CUST.CASHTXN
                            END
                        END
*                Y.RTE.FLAG.RESET = 'STARTED'
*                    GOSUB UPDATE.CUST.CASHTXN
                    END
                    BREAK         ;* The loop should break as we have already found the STARTED flag in ystrdy record.

                CASE OTHERWISE
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR> ;*R22 Auto Conversion
                    END ELSE
                        R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED' ;*R22 Auto Conversion
                        GOSUB RTE.RESET.CHECK

                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CUR.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
*                    Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
*                    Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.
                        END
                        BREAK
                    END
            END CASE
            X.VAR -= 1 ;*R22 Auto Conversion
        REPEAT

    END ELSE

        IF Y.AMT.CNT GE 1 THEN
            FOR L = 1 TO Y.AMT.CNT
                IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,L> NE '' THEN
                    R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,L> = 'STARTED'
                    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                    Y.RTE.FLAG.RESET = ''
                    Y.RTE.TDY.TXN.FLAG = 1
                    BREAK
                END
            NEXT L
            IF Y.RTE.TDY.TXN.FLAG NE 1 THEN
                Y.RTE.FLAG.RESET = 'STARTED'
            END
        END ELSE
            Y.RTE.FLAG.RESET = 'STARTED'
        END
        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + CUR.TXN.AMT
        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
            GOSUB UPDATE.CUST.CASHTXN   ;* Update the Current RTE amount and the corresponding values in the RTE table.
            CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
            TEXT    = VAR.OVERRIDE.ID
            CALL STORE.OVERRIDE(CURR.NO+1)

        END ELSE
            GOSUB UPDATE.CUST.CASHTXN   ;* Update the Current RTE amount and the corresponding values in the RTE table.
        END
    END

RETURN
*****************
RTE.RESET.CHECK:
*****************
    P = X.VAR+1 ;*R22 Auto Conversion
    IF P GT Y.YSTRDY.AMT.CNT THEN
        Y.RTE.YSTRDY.TXN.FLAG = ''
        IF Y.AMT.CNT GE 1 THEN
            FOR S.VAR = 1 TO Y.AMT.CNT ;*R22 Auto Conversion
                IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,S.VAR> NE '' THEN
                    R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,S.VAR> = 'STARTED' ;*R22 Auto Conversion
                    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                    Y.RTE.FLAG.RESET = ''
                    Y.RTE.YSTRDY.TXN.FLAG = 1
                    BREAK
                END
            NEXT S.VAR ;*R22 Auto Conversion
            IF Y.RTE.YSTRDY.TXN.FLAG NE 1 THEN
                Y.RTE.FLAG.RESET = 'STARTED'
            END
        END ELSE
            Y.RTE.FLAG.RESET = 'STARTED'
        END
    END ELSE
        FOR M.VAR = P TO Y.YSTRDY.AMT.CNT ;*R22 Auto Conversion
            IF R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,M.VAR> NE '' THEN ;*R22 Auto Conversion
                R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,M.VAR> = 'STARTED' ;*R22 Auto Conversion
                Y.YSTRDY.BRK.FLAG = 1
                BREAK
            END
        NEXT M.VAR ;*R22 Auto Conversion
        IF Y.YSTRDY.BRK.FLAG NE 1 THEN
            Y.RTE.YSTRDY.TXN.FLAG = ''
            IF Y.AMT.CNT GE 1 THEN
                FOR S.VAR = 1 TO Y.AMT.CNT ;*R22 Auto Conversion
                    IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,S.VAR> NE '' THEN ;*R22 Auto Conversion
                        R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,S.VAR> = 'STARTED' ;*R22 Auto Conversion
                        CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                        Y.RTE.FLAG.RESET = ''
                        Y.RTE.YSTRDY.TXN.FLAG = 1
                        BREAK
                    END
                NEXT S.VAR ;*R22 Auto Conversion
                IF Y.RTE.YSTRDY.TXN.FLAG NE 1 THEN
                    Y.RTE.FLAG.RESET = 'STARTED'
                END
            END ELSE
                Y.RTE.FLAG.RESET = 'STARTED'
            END
        END
    END

    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY)

RETURN



END
