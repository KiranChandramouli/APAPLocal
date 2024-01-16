$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AUT.RTE.OVERRIDE.CHK
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : APAP
*Program   Name    : REDO.AUT.RTE.OVERRIDE.CHK
*--------------------------------------------------------------------------------------------------------------
* Input  Arg : N/A
* Output Arg : N/A
* Deals With : To validate the AML Check and to provide the user with RTE Transactions to get the RTE override
* Linked With: Attached as a After Unauth routine in the VERSION.CONTROL of TELLER
*--------------------------------------------------------------------------------------------------------------
* Who           Date           Dev Ref           Modification
* APAP          09 Jan 2017    RTE Fix           Initial Draft
*--------------------------------------------------------------------------------------------------------------

*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     T24.BP,TAM.BP,ATM.BP,is Removed,sm,vm,fmTO @sm,@fm,@vm,D to D.VAR
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_TT.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_DEAL.SLIP.COMMON ;*R22 Auto code cmversion
    $INSERT I_RC.COMMON
*
    $INSERT I_F.TELLER ;*R22 Auto code cmversion

    $INSERT I_F.CURRENCY ;*R22 Auto code cmversion

    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_F.OVERRIDE
    $INSERT I_F.VERSION
*
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_F.REDO.AA.OVERPAYMENT

    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.RTE.CUST.CASHTXN
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_System
    $INSERT I_F.REDO.TRANSACTION.CHAIN

    COMMON/SYSTEM.VARIABLE.COMMON/System.variableNames, System.variableValues
*

    GOSUB INITIALISE
*    GOSUB OPEN.FILES
    FN.REDO.RTE.CUST.CASHTXN = "F.REDO.RTE.CUST.CASHTXN"
    F.REDO.RTE.CUST.CASHTXN = ""
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    R.REDO.H.REPORTS.PARAM = ''
    RTE.PARAM.ERR = ''
    RTE.PARAM.ID = 'REDO.RTE.FORM'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,RTE.PARAM.ID,R.REDO.H.REPORTS.PARAM,RTE.PARAM.ERR)

    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "CASH.VERSION" IN Y.FIELD.NME.ARR<1,1> SETTING CASH.VER.POS THEN
        Y.CASH.VERSION = Y.FIELD.VAL.ARR<1,CASH.VER.POS>
    END
    Y.CASH.VERSION = CHANGE(Y.CASH.VERSION,@SM,@VM)

    LOCATE "CASH.WITHDRAWAL" IN Y.FIELD.NME.ARR<1,1> SETTING WTDWL.VER.POS THEN
        Y.WITHDRAWAL.VERSIONS = Y.FIELD.VAL.ARR<1,WTDWL.VER.POS>
    END
    Y.WITHDRAWAL.VERSIONS = CHANGE(Y.WITHDRAWAL.VERSIONS,@SM,@VM)

    LOCATE "CASH.RETURN" IN Y.FIELD.NME.ARR<1,1> SETTING CRETURN.VER.POS THEN
        Y.CASHRETURN.VERSIONS = Y.FIELD.VAL.ARR<1,CRETURN.VER.POS>
    END
    Y.CASHRETURN.VERSIONS = CHANGE(Y.CASHRETURN.VERSIONS,@SM,@VM)

    LOCATE "OVERPAYMENT.CASH" IN Y.FIELD.NME.ARR<1,1> SETTING OVERP.VER.POS THEN
        Y.OVERPAY.VERSIONS = Y.FIELD.VAL.ARR<1,OVERP.VER.POS>
    END
    Y.OVERPAY.VERSIONS = CHANGE(Y.OVERPAY.VERSIONS,@SM,@VM)

    LOCATE "CASH.FX" IN Y.FIELD.NME.ARR<1,1> SETTING FX.VER.POS THEN
        Y.FX.VERSIONS = Y.FIELD.VAL.ARR<1,FX.VER.POS>
    END
    Y.FX.VERSIONS = CHANGE(Y.FX.VERSIONS,@SM,@VM)

    LOCATE "RTE.VERSIONS" IN Y.FIELD.NME.ARR<1,1> SETTING RTE.VER.POS THEN
        Y.RTE.VERSIONS = Y.FIELD.VAL.ARR<1,RTE.VER.POS>
    END
    Y.RTE.VERSIONS = CHANGE(Y.RTE.VERSIONS,@SM,@VM)

    LOCATE "RTE.CHQ" IN Y.FIELD.NME.ARR<1,1> SETTING CHQ.VER.POS THEN
        Y.CHQ.VERSIONS = Y.FIELD.VAL.ARR<1,CHQ.VER.POS>
    END
    Y.CHQ.VERSIONS = CHANGE(Y.CHQ.VERSIONS,@SM,@VM)

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GET.APPLICATION = 'TELLER'

        CASE ID.NEW[1,2] EQ 'FT'
            GET.APPLICATION = 'FUNDS.TRANSFER'

        CASE OTHERWISE
            Y.FLAG = 1

    END CASE

    Y.CURRENT.VERSION = GET.APPLICATION:PGM.VERSION
    IF ID.NEW[1,2] EQ 'TT' THEN
        Y.INITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.IN.ID>
        Y.NEXT.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.NXT.VERSION>
    END ELSE
        IF ID.NEW[1,2] EQ 'FT' THEN
            Y.INITIAL.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.IN.ID>
            Y.NEXT.VERSION = R.NEW(FT.LOCAL.REF)<1,POS.FT.NXT.VERSION>
        END
    END
    LOCATE Y.CURRENT.VERSION IN Y.WITHDRAWAL.VERSIONS<1,1> SETTING VER.CHK.POS THEN
        IF Y.INITIAL.ID EQ ID.NEW OR Y.INITIAL.ID EQ '' THEN
            RETURN
        END
    END

    IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'FX' THEN
        LOCATE Y.CURRENT.VERSION IN Y.FX.VERSIONS<1,1> SETTING VER.CHK.POS THEN
            Y.FX.TXN.FLAG = 'Y'
        END ELSE
            RETURN
        END
    END
    Y.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.PARAM.ID,R.AML.PARAM,AML.ERR)
    Y.AMT.LIMIT.LCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>
    Y.AMT.LIMIT.FCY = R.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>

    IF Y.CURRENT.VERSION EQ 'TELLER,L.APAP.PAY.EPAYIT.DGII' THEN
        GOSUB GET.TRANSACTION.AMOUNT
        IF CUR.TXN.AMT LT Y.AMT.LIMIT.LCY THEN
            RETURN
        END
    END

    READ R.TMP.RTC FROM F.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID THEN
        LOCATE ID.NEW IN R.TMP.RTC<RTC.TRANS.ID,1> SETTING TMP.POS THEN
            IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'A' THEN
                Y.RTE.TXNS = System.getVariable('CURRENT.RTE.TXNS')
            END ELSE
                Y.RTE.TXNS = ''
            END
        END ELSE
            Y.RTE.TXNS = ''
        END
    END ELSE
        Y.RTE.TXNS = ''
    END
    GOSUB CHECK.RTE.CASH.TXNS

RETURN

*********************
CHECK.RTE.CASH.TXNS:
*********************
* If Current variable is set with some values, then process the current variable array one by one. Read the array and trigger the transactions through EB.SET.NEW.TASK
* IF Y.RTE.TXNS EQ '' OR Y.RTE.TXNS EQ 'CURRENT.RTE.TXNS' THEN

    IF Y.RTE.TXNS EQ '' THEN
        IF Y.NEXT.VERSION EQ '' AND V$FUNCTION NE 'D' AND V$FUNCTION NE 'A' THEN
            CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
            IF R.RTC THEN
                TXN.CHAIN.IDS = R.RTC<RTC.TRANS.ID>
                TXN.CHAIN.VERS = R.RTC<RTC.TRANS.VERS>
                TXN.ID.CNT = DCOUNT(TXN.CHAIN.IDS,@VM)
                FOR A = 1 TO TXN.ID.CNT
                    BEGIN CASE
                        CASE R.RTC<RTC.TRANS.VERS,A> EQ Y.CASH.VERSION
                            Y.CASH.AMT += R.RTC<RTC.TRANS.AMOUNT,A>
                        CASE R.RTC<RTC.TRANS.VERS,A> EQ Y.CASHRETURN.VERSIONS
                            Y.CASH.RETURN += R.RTC<RTC.TRANS.AMOUNT,A>
                    END CASE
                    LOCATE R.RTC<RTC.TRANS.VERS,A> IN Y.RTE.VERSIONS<1,1> SETTING RTE.VER.POS THEN
                        Y.TXN.ID = R.RTC<RTC.TRANS.ID,A>
                        BEGIN CASE
                            CASE Y.TXN.ID[1,2] EQ 'TT'
                                R.TELLER.NAU = ''
                                CALL F.READ(FN.TT.NAU,Y.TXN.ID,R.TELLER.NAU,F.TT.NAU,ERR.TELLER.NAU)
                                IF R.TELLER.NAU THEN

                                    Y.ACCT.ID = R.TELLER.NAU<TT.TE.ACCOUNT.2>
                                    IF PGM.VERSION EQ Y.OVERPAY.VERSIONS THEN
                                        Y.ACCT.ID = R.TELLER.NAU<TT.TE.NARRATIVE.1><1,1>
                                    END
                                    RTE.TXN.CCY = R.TELLER.NAU<TT.TE.CURRENCY.1>
                                    LOCATE R.RTC<RTC.TRANS.VERS,A> IN Y.FX.VERSIONS<1,1> SETTING VER.CHK.POS THEN
                                        Y.ID.VAL.TXN.FLAG = 'Y'
                                    END
                                    GOSUB GET.CUSTOMER.ID
***----------------------------------------------------todo
                                    GOSUB GET.EPAYIT.VERSION
***-------------------------------------------------------
                                    IF CUS.ACC.ID EQ '' THEN
                                        CONTINUE
                                    END
                                    GOSUB GET.TRANSACTION.AMOUNT

                                    GOSUB CUST.TXN.ARRAY
                                END
                            CASE Y.TXN.ID[1,2] EQ 'FT'
                                R.FT.NAU = ''
                                CALL F.READ(FN.FT.NAU,Y.TXN.ID,R.FT.NAU,F.FT.NAU,FT.NAU.ERR)
                                IF R.FT.NAU THEN
                                    Y.ACCT.ID = R.FT.NAU<FT.CREDIT.ACCT.NO>
                                    RTE.TXN.CCY = R.FT.NAU<FT.CREDIT.CURRENCY>
                                    GOSUB GET.CUSTOMER.ID
                                    IF CUS.ACC.ID EQ '' THEN
                                        CONTINUE
                                    END
                                    GOSUB GET.TRANSACTION.AMOUNT
                                    GOSUB CUST.TXN.ARRAY
                                END
                        END CASE
                    END
                    IF A EQ TXN.ID.CNT THEN
                        IF Y.CASH.AMT NE '' THEN
                            GOSUB VALIDATE.RTE.TXNS
                            IF Y.FIRST.RTE.TXN EQ '' THEN
                                R.RTE.TXNS = "CURRENT.RTE.TXNS"
*                                R.RTE.TXNS<1,1> = 'END'
                                CALL System.setVariable("CURRENT.RTE.TXNS", R.RTE.TXNS)
                                Y.STR = "ENQ NOFILE.REDO.NV.E.AUTHOR @ID EQ " : Y.INITIAL.ID
                                OFS$NEW.COMMAND = Y.STR
                            END ELSE
                                R.RTE.TXNS<1,-1> = 'PASS'
                                R.RTE.TXNS<1,-1> = Y.FIRST.RTE.TXN
                                CALL System.setVariable("CURRENT.RTE.TXNS", R.RTE.TXNS)
                            END
                        END ELSE
                            R.RTE.TXNS = "CURRENT.RTE.TXNS"
                            CALL System.setVariable("CURRENT.RTE.TXNS", R.RTE.TXNS)
                            Y.STR = "ENQ NOFILE.REDO.NV.E.AUTHOR @ID EQ " : Y.INITIAL.ID
                            OFS$NEW.COMMAND = Y.STR
                        END
                    END
                NEXT A
            END
        END
    END ELSE
        Y.NXT.TXN.ID = FIELD(Y.RTE.TXNS<1,1>,'*',1)
        Y.CUST.TXN.VERS = FIELD(Y.RTE.TXNS<1,1>,'*',2)
        IF Y.NXT.TXN.ID NE 'PASS' THEN

            Y.RTE.TXNS<1,-1> = Y.RTE.TXNS<1,1>
            DEL Y.RTE.TXNS<1,1>
            CALL System.setVariable("CURRENT.RTE.TXNS", Y.RTE.TXNS)
            NEXT.TASK = Y.CUST.TXN.VERS:' ':'I':' ':Y.NXT.TXN.ID
            CALL EB.SET.NEW.TASK(NEXT.TASK)
        END ELSE

            Y.STR = "ENQ NOFILE.REDO.NV.E.AUTHOR @ID EQ " : Y.INITIAL.ID        ;* Changed
            OFS$NEW.COMMAND = Y.STR
        END
    END
RETURN

******************
VALIDATE.RTE.TXNS:
******************

    Y.TOT.CASH.AMT = Y.CASH.AMT + Y.CASH.RETURN

    Y.ACT.TXN.CNT = DCOUNT(R.CUSTOMER.DETAILS<1>,@VM)
    Y.TOT.CASH.AMT.TMP = Y.TOT.CASH.AMT
    PASS.TXN = 1
    FOR C = 1 TO Y.ACT.TXN.CNT
        IF Y.TOT.CASH.AMT.TMP GT 0 THEN
            Y.RTE.ID = R.CUSTOMER.DETAILS<1,C>:'.':Y.CAL.TODAY
            Y.CUST.DETAILS.TEMP = R.CUSTOMER.DETAILS<1,C>
            Y.CUST.TXN.CNT = DCOUNT(R.CUSTOMER.DETAILS<2,C>,@SM)
            Y.CUST.TOT.DEP.AMT = 0

            REDO.RTE.CUST.CASHTXN.ERR = ''
*            CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
            CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
* Changes as per the new requirement.
*   GOSUB VERIFY.RTE.CASH.TXN

*            IF R.REDO.RTE.CUST.CASHTXN THEN
*                Y.CASH.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>
*                Y.AMT.CNT = DCOUNT(Y.CASH.AMOUNT.LIST,VM)
*                FOR J = 1 TO Y.AMT.CNT
*                    Y.VERS.TOT.AMT += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J>
*                NEXT J
*            END

            FOR D.VAR = 1 TO Y.CUST.TXN.CNT ;*R22 Auto code cmversion

                IF Y.TOT.CASH.AMT.TMP GT 0 THEN
                    Y.RTE.FLAG.RESET = ''
                    Y.CUST.TXN.ID = R.CUSTOMER.DETAILS<2,C,D.VAR>
                    Y.CUST.TXN.AMT = R.CUSTOMER.DETAILS<3,C,D.VAR>
                    Y.CUST.TXN.VERS = R.CUSTOMER.DETAILS<4,C,D.VAR>
                    Y.TOT.CASH.AMT.TMP -= Y.CUST.TXN.AMT
                    IF Y.TOT.CASH.AMT.TMP GE 0 THEN
                        CASH.AMT.CUR.TXN = Y.CUST.TXN.AMT
*                        GOSUB UPDATE.CUST.CASHTXN
                        Y.CUST.TOT.DEP.AMT += Y.CUST.TXN.AMT
                        GOSUB UPDATE.JOINT.HOLDER
*                        Y.CUST.TOT.DEP.AMT += Y.CUST.TXN.AMT
                    END ELSE
                        CASH.AMT.TMP = Y.TOT.CASH.AMT.TMP + Y.CUST.TXN.AMT
                        Y.CUST.TOT.DEP.AMT += CASH.AMT.TMP
                        CASH.AMT.CUR.TXN = CASH.AMT.TMP
*                       GOSUB UPDATE.CUST.CASHTXN
                        GOSUB UPDATE.JOINT.HOLDER
                    END
*                    Y.RTE.TOTAL.AMT = Y.VERS.TOT.AMT + Y.CUST.TOT.DEP.AMT
*                    Y.RTE.TOTAL.AMT = Y.RTE.TOTAL.AMT / CUR.AMLBUY.RATE
*                    IF Y.RTE.TOTAL.AMT GE Y.AMT.LIMIT.FCY THEN
*                        IF PASS.TXN EQ '1' THEN
*                            NEXT.TASK = Y.CUST.TXN.VERS:' ':'I':' ':Y.CUST.TXN.ID
*                            CALL EB.SET.NEW.TASK(NEXT.TASK)
*                            Y.FIRST.RTE.TXN = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
*                            PASS.TXN += 1
*                        END ELSE
*                            R.RTE.TXNS<1,-1> = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
*                        END
*                    END ELSE
*                        IF Y.JOINT.FLAG EQ 1 AND Y.JOINT.RTE.FLAG EQ 1 THEN
*                            IF PASS.TXN EQ '1' THEN
*                                NEXT.TASK = Y.CUST.TXN.VERS:' ':'I':' ':Y.CUST.TXN.ID
*                                CALL EB.SET.NEW.TASK(NEXT.TASK)
*                                Y.FIRST.RTE.TXN = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
*                                PASS.TXN += 1
*                            END ELSE
*                                R.RTE.TXNS<1,-1> = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
*                            END
*                        END
*                    END
*
                END ELSE
                    BREAK
                END
            NEXT D.VAR

        END ELSE
            BREAK
        END
    NEXT C
RETURN

********************
UPDATE.JOINT.HOLDER:
********************

    Y.CUSTOMER.IDS = R.CUSTOMER.DETAILS<5,C,D.VAR>
    CHANGE '*' TO @VM IN Y.CUSTOMER.IDS
    Y.CUST.CNT = DCOUNT(Y.CUSTOMER.IDS,@VM)
    IF Y.CUST.CNT GT 1 THEN
        Y.JOINT.FLAG = 1
    END

    FOR K.VAR = 1 TO Y.CUST.CNT
        Y.RTE.ID = Y.CUSTOMER.IDS<1,K.VAR>:'.':Y.CAL.TODAY
* Changes as per the new requirement.
        IF K.VAR GT 1 THEN
            Y.JOINT.RTE.FLAG = 1
        END

*        CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
        CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
        Y.RTE.FLAG.RESET = ''
        GOSUB VERIFY.RTE.CASH.TXN
*        GOSUB UPDATE.CUST.CASHTXN
*        IF K GT 1 THEN
*            Y.JOINT.TOT.AMT = SUM(R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>)
*            Y.JOINT.TOT.AMT = Y.JOINT.TOT.AMT / CUR.AMLBUY.RATE
*            IF Y.JOINT.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
*                Y.JOINT.RTE.FLAG = 1
*            END
*        END
    NEXT K.VAR

RETURN

******************
GET.CUSTOMER.ID:
******************

    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUSTOMER.CODE = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUSTOMER.CODE THEN
        CUS.ACC.ID = Y.CUSTOMER.CODE
    END ELSE
        Y.CUSTOMER.CODE = R.TELLER.NAU<TT.TE.LOCAL.REF><1,POS.CUSTOMER.CODE>

        IF NUM(Y.CUSTOMER.CODE[1,2]) AND Y.CUSTOMER.CODE NE '' THEN
            CUS.ACC.ID = Y.CUSTOMER.CODE
        END
    END
* To handle the Foreign Currency exchange
    IF (Y.FX.TXN.FLAG EQ 'Y' OR Y.ID.VAL.TXN.FLAG EQ 'Y') AND (CUS.ACC.ID EQ '' OR CUS.ACC.ID EQ 'NA') THEN
        YLEG.TT.VAL = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.LEGAL.ID>
        IF Y.ID.VAL.TXN.FLAG EQ 'Y' THEN
            YLEG.TT.VAL = R.TELLER.NAU<TT.TE.LOCAL.REF,POS.TT.LEGAL.ID>
        END
        IF YLEG.TT.VAL THEN
            CUS.ACC.ID = FIELD(YLEG.TT.VAL,'.',1):'.':FIELD(YLEG.TT.VAL,'.',2)
        END
    END
* To include the RTE transactions for the Joint Holder Customer
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
************************
GET.TRANSACTION.AMOUNT:
************************

    RTE.CCY = 'USD'
    CALL CACHE.READ(FN.CURRENCY,RTE.CCY,R.CURRENCY,CURR.ERR)
    CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,POS.L.CU.AMLBUY.RT>

    BEGIN CASE
        CASE Y.TXN.ID[1,2] EQ 'TT'

            RTE.TXN.AMT = R.TELLER.NAU<TT.TE.AMOUNT.LOCAL.1>
            IF Y.FX.TXN.FLAG EQ 'Y' OR Y.ID.VAL.TXN.FLAG EQ 'Y' THEN
                IF RTE.TXN.CCY EQ 'USD' THEN
                    Y.FCY.AMT.1 =  R.NEW(TT.TE.AMOUNT.FCY.1)
                    IF Y.FCY.AMT.1 NE '' THEN
                        RTE.TXN.AMT = Y.FCY.AMT.1 * CUR.AMLBUY.RATE
                    END
                END ELSE
                    IF RTE.TXN.CCY EQ 'EUR' THEN
                        Y.AMT.LOCAL.2 = R.NEW(TT.TE.AMOUNT.LOCAL.2)
                        IF Y.AMT.LOCAL.2 NE '' THEN
                            LOCATE '10' IN R.CURRENCY<EB.CUR.CURRENCY.MARKET,1> SETTING CCY.MARKET.POS THEN
                                Y.USD.CONV.AMT = Y.AMT.LOCAL.2 * R.CURRENCY<EB.CUR.SELL.RATE,CCY.MARKET.POS>
                                IF Y.USD.CONV.AMT NE '' THEN
                                    RTE.TXN.AMT = Y.USD.CONV.AMT * CUR.AMLBUY.RATE
                                END
                            END
                        END
                    END
                END

            END
            LOCATE R.RTC<RTC.TRANS.VERS,A> IN Y.CHQ.VERSIONS<1,1> SETTING VER.CHQ.POS THEN
                RTE.TXN.AMT = R.TELLER.NAU<TT.TE.NET.AMOUNT>
            END
        CASE Y.TXN.ID[1,2] EQ 'FT'
            RTE.TXN.AMT = R.FT.NAU<FT.CREDIT.AMOUNT>
    END CASE

    CUR.TXN.AMT = RTE.TXN.AMT

RETURN
****************
CUST.TXN.ARRAY:
****************

    LOCATE CUS.ACC.ID IN R.CUSTOMER.DETAILS<1,1> SETTING CUST.POS THEN
        R.CUSTOMER.DETAILS<2,CUST.POS,-1> =  Y.TXN.ID
*        R.CUSTOMER.DETAILS<3,CUST.POS,-1> = ABS(R.RTC<RTC.TRANS.AMOUNT,A>)
        R.CUSTOMER.DETAILS<3,CUST.POS,-1> = CUR.TXN.AMT
        R.CUSTOMER.DETAILS<4,CUST.POS,-1> = R.RTC<RTC.TRANS.VERS,A>
        IF Y.JOINT.CUSTOMERS NE '' THEN
            CHANGE @VM TO '*' IN Y.JOINT.CUSTOMERS
            R.CUSTOMER.DETAILS<5,CUST.POS,-1> = CUS.ACC.ID:'*':Y.JOINT.CUSTOMERS
        END ELSE
            R.CUSTOMER.DETAILS<5,CUST.POS,-1> = CUS.ACC.ID
        END
    END ELSE
        R.CUSTOMER.DETAILS<1,CUST.POS> = CUS.ACC.ID
        R.CUSTOMER.DETAILS<2,CUST.POS,1> = Y.TXN.ID
*        R.CUSTOMER.DETAILS<3,CUST.POS,1> = ABS(R.RTC<RTC.TRANS.AMOUNT,A>)
        R.CUSTOMER.DETAILS<3,CUST.POS,1> = CUR.TXN.AMT
        R.CUSTOMER.DETAILS<4,CUST.POS,1> = R.RTC<RTC.TRANS.VERS,A>
        IF Y.JOINT.CUSTOMERS NE '' THEN
            CHANGE @VM TO '*' IN Y.JOINT.CUSTOMERS
            R.CUSTOMER.DETAILS<5,CUST.POS,1> = CUS.ACC.ID:'*':Y.JOINT.CUSTOMERS
        END ELSE
            R.CUSTOMER.DETAILS<5,CUST.POS,1> = CUS.ACC.ID
        END
    END

RETURN

********************
UPDATE.CUST.CASHTXN:
********************

    Y.FUNC = V$FUNCTION
    REDO.RTE.CUST.CASHTXN.ERR = ''
    CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,RTE)
    IF R.REDO.RTE.CUST.CASHTXN THEN
        LOCATE ID.NEW IN R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,1> SETTING RTE.ID.POS ELSE
            R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,-1> = R.CUSTOMER.DETAILS<2,C,D.VAR> ;*R22 Auto code cmversion
*            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = R.CUSTOMER.DETAILS<3,C,D>
            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = CASH.AMT.CUR.TXN
*            R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,-1> = R.CUSTOMER.DETAILS<2,C,D>
            R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID,-1> = Y.INITIAL.ID
            R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE,-1> = ID.COMPANY
*            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = R.CUSTOMER.DETAILS<3,C,D>
            R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,-1> = TIMEDATE()
            R.REDO.RTE.CUST.CASHTXN<RTE.ACTUAL.VERSION,-1> = R.CUSTOMER.DETAILS<4,C,D.VAR>
            R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,-1> = Y.FUNC
            IF Y.RTE.FLAG.RESET EQ '' THEN
                Y.RTE.FLAG.RESET = 'IN PROGRESS'
            END
            R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,-1> = Y.RTE.FLAG.RESET
            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
        END
    END
    ELSE
        R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID> = R.CUSTOMER.DETAILS<2,C,D.VAR>
*        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = R.CUSTOMER.DETAILS<3,C,D>
        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = CASH.AMT.CUR.TXN
*        R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID> = R.CUSTOMER.DETAILS<2,C,D>
        R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID> = Y.INITIAL.ID
        R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE> = ID.COMPANY
*        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = R.CUSTOMER.DETAILS<3,C,D>
        R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE> = TIMEDATE()
        R.REDO.RTE.CUST.CASHTXN<RTE.ACTUAL.VERSION> = R.CUSTOMER.DETAILS<4,C,D.VAR>
        R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION> = Y.FUNC
        IF Y.RTE.FLAG.RESET EQ '' THEN
            Y.RTE.FLAG.RESET = 'IN PROGRESS'
        END
        R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG> = Y.RTE.FLAG.RESET
        CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
    END

RETURN

************
INITIALISE:
************

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')

    LRF.APP   = 'TRANSACTION' : @FM : 'CURRENCY' : @FM : 'TELLER' : @FM : 'FUNDS.TRANSFER'
    LRF.FIELD = 'L.TR.AML.CHECK' : @FM : 'L.CU.AMLBUY.RT' : @FM : 'L.RTE.FORM' : @VM :'L.TT.CLIENT.COD' : @VM : 'L.INITIAL.ID':@VM:'L.ACT.INT':@VM:'L.NATIONALITY': @VM : 'L.PEP.INTERM' : @VM :'L.TYPE.PEP.INT' : @VM : 'L.NEXT.VERSION': @VM : 'L.ACTUAL.VERSIO': @VM : 'L.TT.LEGAL.ID' : @FM : 'L.ACTUAL.VERSIO':@VM:'L.INITIAL.ID':@VM:'L.NEXT.VERSION'
    LRF.POS   = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.L.TR.AML.CHECK = LRF.POS<1,1>
    POS.L.CU.AMLBUY.RT = LRF.POS<2,1>
    POS.L.RTE.FORM     = LRF.POS<3,1>
    POS.CUSTOMER.CODE  = LRF.POS<3,2>
    POS.IN.ID  = LRF.POS<3,3>
    POS.TT.INT = LRF.POS<3,4>
    POS.TT.NAT = LRF.POS<3,5>
    POS.TT.INTERM = LRF.POS<3,6>
    POS.TT.TYPE = LRF.POS<3,7>
    POS.TT.NXT.VERSION = LRF.POS<3,8>
    POS.TT.ACT.VERSION = LRF.POS<3,9>
    POS.TT.LEGAL.ID = LRF.POS<3,10>
    POS.FT.ACT.VERSION = LRF.POS<4,1>
    POS.FT.IN.ID = LRF.POS<4,2>
    POS.FT.NXT.VERSION = LRF.POS<4,3>

    TOT.TODAY.TXN.AMT = ''
    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT  = ''

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY  = ''

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER  = ''

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''

    FN.REDO.AML.PARAM = 'F.REDO.AML.PARAM'
    F.REDO.AML.PARAM  = ''

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE  = ''

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.TT.NAU = 'F.TELLER$NAU'
    F.TT.NAU = ''
    CALL OPF(FN.TT.NAU,F.TT.NAU)

    Y.CASH.FLAG = ''
    CUR.TXN.AMT = ''
    Y.DR.UNIT = ''
    YDR.UNIT = ''
    Y.VERS.TOT.AMT = ''
    R.VERSION.DETAILS = ''
    INITIAL.ACCT.ID = ''
    Y.TXN.UPDATED = ''
    Y.DR.DENOM = ''
    Y.DR.AMT = ''
    Y.FX.TXN.FLAG = ''
    Y.CASH.AMT = ''
    Y.CASH.RETURN = ''
    Y.JOINT.FLAG = ''
    Y.JOINT.RTE.FLAG = ''
    Y.FCY.AMT.1 = ''
    Y.AMT.LOCAL.2 = ''
    Y.USD.CONV.AMT = ''

    Y.RTE.FLAG.RESET = ''

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
        J.VAR = Y.AMT.CNT
        LOOP
        WHILE J.VAR NE 0
*        FOR J = Y.AMT.CNT TO 1
*         Y.VERS.TOT.AMT += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J>

            Y.TRANS.DATE = R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,J.VAR>
            Y.FLAG.RESET = R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,J.VAR>
            Y.CURRENT.TIME = OCONV(TIME(),'MTS')
            Y.CURRENT.SECS = ICONV(Y.CURRENT.TIME,'MTH')
            Y.TRANS.DATE.SECS = ICONV(Y.TRANS.DATE[1,8],'MTH')

            BEGIN CASE
                CASE Y.FLAG.RESET EQ 'STARTED'
                    IF Y.TRANS.DATE.SECS LE Y.CURRENT.SECS THEN
                        Y.LOOP.AMT.TDY += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J.VAR>
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + CASH.AMT.CUR.TXN
*                    Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + Y.CUST.TOT.DEP.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.

                            IF K.VAR EQ 1 THEN
                                GOSUB SET.NEW.TASK
                                Y.INITIAL.RTE.FLAG = 1
                            END ELSE
                                IF K.VAR GT 1 THEN        ;* To raise the RTE if the joint holder RTE limit exceeds.
                                    IF Y.INITIAL.RTE.FLAG NE 1 THEN
                                        GOSUB SET.NEW.TASK
                                        Y.INITIAL.RTE.FLAG = ''
                                    END
                                END
                            END

*      CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)
*      VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
*      TEXT    = VAR.OVERRIDE.ID
*      CALL STORE.OVERRIDE(CURR.NO+1)
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
    Y.LAST.RTE.ID = Y.CUSTOMER.IDS<1,K.VAR>:'.':Y.YESTERDAY.DATE
*    CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
    CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.REDO.RTE.CUST.CASHTXN.YSTRDY THEN
        Y.YSTRDY.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT>
        Y.YSTRDY.AMT.CNT = DCOUNT(Y.YSTRDY.AMOUNT.LIST,@VM)
        X.VAR = Y.YSTRDY.AMT.CNT
        LOOP
        WHILE X.VAR NE 0
*        FOR X = Y.YSTRDY.AMT.CNT TO 1
            Y.TRANS.DATE.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.TRANS.DATE,X.VAR>
            Y.FLAG.RESET.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR>
            Y.CURRENT.TIME.YSTRDY = OCONV(TIME(),'MTS')
            Y.CURRENT.SECS.YSTRDY = ICONV(Y.CURRENT.TIME.YSTRDY,'MTH')
            Y.TRANS.DATE.SECS.YSTRDY = ICONV(Y.TRANS.DATE.YSTRDY[1,8],'MTH')
            BEGIN CASE
                CASE Y.FLAG.RESET.YSTRDY EQ 'STARTED'
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>

                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CASH.AMT.CUR.TXN
*                    Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + Y.CUST.TOT.DEP.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.

                            IF K.VAR EQ 1 THEN
                                GOSUB SET.NEW.TASK
                                Y.INITIAL.RTE.FLAG = 1
                            END ELSE
                                IF K.VAR GT 1 THEN        ;* To raise the RTE if the joint holder RTE limit exceeds.
                                    IF Y.INITIAL.RTE.FLAG NE 1 THEN
                                        GOSUB SET.NEW.TASK
                                        Y.INITIAL.RTE.FLAG = ''
                                    END
                                END
                            END

*      CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)
*      VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
*      TEXT    = VAR.OVERRIDE.ID
*      CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
                            GOSUB UPDATE.CUST.CASHTXN
                        END
                    END ELSE
                        Y.LOOP.AMT.YSTRDY.CUR = Y.LOOP.AMT.YSTRDY + R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY.CUR + Y.LOOP.AMT.TDY
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY)
*                        Y.RTE.TOT.AMT = Y.CUST.TOT.DEP.AMT / CUR.AMLBUY.RATE
                            Y.RTE.TOT.AMT = CASH.AMT.CUR.TXN / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.CUST.CASHTXN       ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                IF K.VAR EQ 1 THEN
                                    GOSUB SET.NEW.TASK
                                    Y.INITIAL.RTE.FLAG = 1
                                END ELSE
                                    IF K.VAR GT 1 THEN    ;* To raise the RTE if the joint holder RTE limit exceeds.
                                        IF Y.INITIAL.RTE.FLAG NE 1 THEN
                                            GOSUB SET.NEW.TASK
                                            Y.INITIAL.RTE.FLAG = ''
                                        END
                                    END
                                END
                            END ELSE
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.CUST.CASHTXN
                            END
                        END ELSE

                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                            GOSUB RTE.RESET.CHECK
                            Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CUR.TXN.AMT
                            Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                GOSUB UPDATE.CUST.CASHTXN       ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                IF K.VAR EQ 1 THEN
                                    GOSUB SET.NEW.TASK
                                    Y.INITIAL.RTE.FLAG = 1
                                END ELSE
                                    IF K.VAR GT 1 THEN    ;* To raise the RTE if the joint holder RTE limit exceeds.
                                        IF Y.INITIAL.RTE.FLAG NE 1 THEN
                                            GOSUB SET.NEW.TASK
                                            Y.INITIAL.RTE.FLAG = ''
                                        END
                                    END
                                END
                            END ELSE
                                GOSUB UPDATE.CUST.CASHTXN
                            END
                        END
*                    Y.RTE.FLAG.RESET = 'STARTED'
*                    GOSUB UPDATE.CUST.CASHTXN
                    END

                    BREAK         ;* The loop should break as we have already found the STARTED flag in ystrdy record.

                CASE OTHERWISE
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                    END ELSE
*     Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CASH.AMT.CUR.TXN
                        R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                        GOSUB RTE.RESET.CHECK

*                    Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + Y.CUST.TOT.DEP.AMT
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + CASH.AMT.CUR.TXN
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
*                        Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.

                            IF K.VAR EQ 1 THEN
                                GOSUB SET.NEW.TASK
                                Y.INITIAL.RTE.FLAG = 1
                            END ELSE
                                IF K.VAR GT 1 THEN        ;* To raise the RTE if the joint holder RTE limit exceeds.
                                    IF Y.INITIAL.RTE.FLAG NE 1 THEN
                                        GOSUB SET.NEW.TASK
                                        Y.INITIAL.RTE.FLAG = ''
                                    END
                                END
                            END

*      CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)
*      VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
*      TEXT    = VAR.OVERRIDE.ID
*      CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
*                        Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.CUST.CASHTXN ;* Update the Current RTE amount and the corresponding values in the RTE table.
                        END
                        BREAK
                    END

            END CASE
            X.VAR -= 1
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
        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + CASH.AMT.CUR.TXN
*        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + Y.CUST.TOT.DEP.AMT
        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
            Y.RTE.FLAG.RESET = 'STARTED'
            GOSUB UPDATE.CUST.CASHTXN   ;* Update the Current RTE amount and the corresponding values in the RTE table.

            IF K.VAR EQ 1 THEN
                GOSUB SET.NEW.TASK
                Y.INITIAL.RTE.FLAG = 1
            END ELSE
                IF K.VAR GT 1 THEN          ;* To raise the RTE if the joint holder RTE limit exceeds.
                    IF Y.INITIAL.RTE.FLAG NE 1 THEN
                        GOSUB SET.NEW.TASK
                        Y.INITIAL.RTE.FLAG = ''
                    END
                END
            END
        END ELSE
*            Y.RTE.FLAG.RESET = 'STARTED'
            GOSUB UPDATE.CUST.CASHTXN   ;* Update the Current RTE amount and the corresponding values in the RTE table.
        END
    END

RETURN

**************
SET.NEW.TASK:
**************

    IF PASS.TXN EQ '1' THEN
        NEXT.TASK = Y.CUST.TXN.VERS:' ':'I':' ':Y.CUST.TXN.ID
        CALL EB.SET.NEW.TASK(NEXT.TASK)
        Y.FIRST.RTE.TXN = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
        PASS.TXN += 1
    END ELSE
        R.RTE.TXNS<1,-1> = Y.CUST.TXN.ID:'*':Y.CUST.TXN.VERS
    END

RETURN

*****************
RTE.RESET.CHECK:
*****************
    P = X.VAR+1
    IF P GT Y.YSTRDY.AMT.CNT THEN
        Y.RTE.YSTRDY.TXN.FLAG = ''
        IF Y.AMT.CNT GE 1 THEN
            FOR S.VAR = 1 TO Y.AMT.CNT
                IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,S.VAR> NE '' THEN
                    R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,S.VAR> = 'STARTED'
                    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                    Y.RTE.FLAG.RESET = ''
                    Y.RTE.YSTRDY.TXN.FLAG = 1
                    BREAK
                END
            NEXT S.VAR
            IF Y.RTE.YSTRDY.TXN.FLAG NE 1 THEN
                Y.RTE.FLAG.RESET = 'STARTED'
            END
        END ELSE
            Y.RTE.FLAG.RESET = 'STARTED'
        END
    END ELSE
        FOR M.VAR = P TO Y.YSTRDY.AMT.CNT
            IF R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,M.VAR> NE '' THEN
                R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,M.VAR> = 'STARTED'
                Y.YSTRDY.BRK.FLAG = 1
                BREAK
            END
        NEXT M.VAR
        IF Y.YSTRDY.BRK.FLAG NE 1 THEN
            Y.RTE.YSTRDY.TXN.FLAG = ''
            IF Y.AMT.CNT GE 1 THEN
                FOR S.VAR = 1 TO Y.AMT.CNT
                    IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,S.VAR> NE '' THEN
                        R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,S.VAR> = 'STARTED'
                        CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                        Y.RTE.FLAG.RESET = ''
                        Y.RTE.YSTRDY.TXN.FLAG = 1
                        BREAK
                    END
                NEXT S.VAR
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
