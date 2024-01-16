* @ValidationCode : MjoxOTIzODExMzQ0OlVURi04OjE2ODk3NDk2NTc5Mzg6SVRTUzotMTotMTo2MTQ0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 6144
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.INP.RTEAML.TFS.CHECK
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : APAP
*Program   Name    : REDO.APAP.INP.RTEAML.TFS.CHECK
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine checks if the total customer amount is greater
*                    than the threshold amount defined in the local parameter table REDO.AML.PARAM then
*                    throws override and generates the deal slip
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date            Who                 Reference                     Description
* ------          -----               -------------                 -------------
* 09 Jan 2017     APAP                RTE FIX                       Initial Creation
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,F to CACHE and F.CURR variable removed,SM to @SM,FM to @FM,VM to @VM,J to J.VAR,K to K.VAR,S to S.VAR,M to M.VAR,X to X.VAR,END added at if condition
* 17-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES ;*R22 Auto Conversion
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.AML.PARAM ;*R22 Auto Conversion
    $INSERT I_F.OVERRIDE
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*R22 Auto Conversion
    $INSERT I_F.VERSION
    $INSERT I_F.DATES
    $INSERT I_F.REDO.RTE.CUST.CASHTXN

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB OPEN.PARA
        GOSUB PROCESS.PARA
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION  = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.CURR = 'F.CURRENCY'
    F.CURR  = ''
    CALL OPF(FN.CURR,F.CURR)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT  = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.REDO.AML.PARAM = 'F.REDO.AML.PARAM'
    F.REDO.AML.PARAM  = ''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE  = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

    FN.REDO.RTE.CUST.CASHTXN = "F.REDO.RTE.CUST.CASHTXN"
    F.REDO.RTE.CUST.CASHTXN = ""
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    R.REDO.AML.PARAM  = ''
    REDO.AML.PARAM.ER = ''
    REDO.AML.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,REDO.AML.PARAM.ID,R.REDO.AML.PARAM,REDO.AML.PARAM.ER)

    PROCESS.GOAHEAD = ''
    Y.AMT.FLAG = ''
    Y.TFS.LIST = ''
    Y.TXN.UPDATED = ''
    Y.RTE.AMOUNT = ''
    Y.RTE.FLAG.RESET = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB READ.REDO.AML.PARAM

    RTE.TXN.CCY = 'USD'
    R.CURRENCY  = ''
    CURRENCY.ERR = ''
    CALL CACHE.READ(FN.CURR, RTE.TXN.CCY, R.CURRENCY, CURRENCY.ERR) ;*R22 Auto Conversion
    CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,LOC.L.CU.AMLBUY.RT.POS>

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GET.APPLICATION = 'TELLER'

        CASE ID.NEW[1,2] EQ 'FT'
            GET.APPLICATION = 'FUNDS.TRANSFER'

        CASE ID.NEW[1,5] EQ 'T24FS'
            GET.APPLICATION = 'T24.FUND.SERVICES'

        CASE OTHERWISE
            Y.FLAG = 1

    END CASE

    Y.CURRENT.VERSION = GET.APPLICATION:PGM.VERSION
    LOCATE 'CASHDEP' IN R.NEW(TFS.TRANSACTION)<1,1> SETTING TXN.POS THEN
        PROCESS.GOAHEAD = ''
        YDR.UNIT = R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS>
        Y.DENOM.COUNT = DCOUNT(YDR.UNIT,@SM)
        Y.COUNT = 1
        LOOP
        WHILE Y.COUNT LE Y.DENOM.COUNT
            IF R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS,Y.COUNT> GT 0 THEN
                YDR.TOT.UNIT  += R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS,Y.COUNT>
                PROCESS.GOAHEAD = 1
                BREAK
            END
            Y.COUNT += 1
        REPEAT
        IF PROCESS.GOAHEAD THEN
            Y.ACCOUNT.ID = R.NEW(TFS.LOCAL.REF)<1,LOC.L.FT.ADD.INFO.POS>
            CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT.REC,F.ACCOUNT,ACC.ERR)
            IF R.ACCOUNT.REC THEN
                CUS.ACC.ID = R.ACCOUNT.REC<AC.CUSTOMER>
                Y.JOINT.CUSTOMERS = ''
                IF CUS.ACC.ID THEN
                    IF R.ACCOUNT.REC<AC.JOINT.HOLDER> NE '' THEN
                        Y.JOINT.CUSTOMERS = R.ACCOUNT.REC<AC.JOINT.HOLDER>
                    END
                END
                IF CUS.ACC.ID EQ '' THEN
                    PROCESS.GOAHEAD = ''
                END

            END ELSE
                PROCESS.GOAHEAD = ''
            END
            Y.TOT.TXN.AMT = R.NEW(TFS.AMOUNT)<1,TXN.POS>
            Y.VAR.CCY.CHECK = R.NEW(TFS.CURRENCY)<1,TXN.POS>
            IF Y.VAR.CCY.CHECK NE LCCY THEN
                R.CURR  = ''
                CURRENCY.ER = ''
                CALL CACHE.READ(FN.CURR, Y.VAR.CCY.CHECK, R.CURR, CURRENCY.ER) ;*R22 Auto Conversion
                Y.AML.BUY.RATE = R.CURR<EB.CUR.LOCAL.REF,LOC.L.CU.AMLBUY.RT.POS>
                Y.TOT.TXN.AMT = Y.TOT.TXN.AMT * Y.AML.BUY.RATE
            END
        END
    END

    LOCATE 'CASHDEPC' IN R.NEW(TFS.TRANSACTION)<1,1> SETTING TXN.POS THEN
        PROCESS.GOAHEAD = ''
        YDR.UNIT = R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS>
        Y.DENOM.COUNT = DCOUNT(YDR.UNIT,@SM)
        Y.COUNT = 1
        LOOP
        WHILE Y.COUNT LE Y.DENOM.COUNT
            IF R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS,Y.COUNT> GT 0 THEN
                YDR.TOT.UNIT  += R.NEW(TFS.DR.DEN.UNIT)<1,TXN.POS,Y.COUNT>
                PROCESS.GOAHEAD = 1
                BREAK
            END
            Y.COUNT += 1
        REPEAT
    END

    IF PROCESS.GOAHEAD THEN
        LOCATE 'CASHDEPD' IN R.NEW(TFS.TRANSACTION)<1,1> SETTING TXN.POS THEN
            ACCOUNT.ID = R.NEW(TFS.SURROGATE.AC)<1,TXN.POS>
            R.ACCOUNT  = ''
            ACCOUNT.ER = ''
            CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
            CUS.ACC.ID = R.ACCOUNT<AC.CUSTOMER>
            Y.JOINT.CUSTOMERS = ''
            IF CUS.ACC.ID THEN
                IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
                    Y.JOINT.CUSTOMERS = R.ACCOUNT<AC.JOINT.HOLDER>
                END
            END
            IF CUS.ACC.ID EQ '' THEN
                PROCESS.GOAHEAD = ''
            END

            Y.TOT.TXN.AMT = R.NEW(TFS.ACTUAL.DEPOSIT)
            Y.VAR.CCY.CHECK = R.NEW(TFS.CURRENCY)<1,TXN.POS>
            IF Y.VAR.CCY.CHECK NE LCCY THEN
                R.CURR  = ''
                CURRENCY.ER = ''
                CALL CACHE.READ(FN.CURR, Y.VAR.CCY.CHECK, R.CURR, CURRENCY.ER) ;*R22 Auto Conversion
                Y.AML.BUY.RATE = R.CURR<EB.CUR.LOCAL.REF,LOC.L.CU.AMLBUY.RT.POS>
                Y.TOT.TXN.AMT = Y.TOT.TXN.AMT * Y.AML.BUY.RATE
            END
        END
    END
    IF YDR.TOT.UNIT GT 0 AND PROCESS.GOAHEAD THEN
        Y.RTE.ID = CUS.ACC.ID:'.':Y.CAL.TODAY
        Y.CUR.TXN.AMT = Y.TOT.TXN.AMT
        PROCESS.GOAHEAD = 1
*        CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
        CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
* Changes based on the new requirement
        GOSUB VERIFY.RTE.CASH.TXN

        Y.CUST.CNT = DCOUNT(Y.JOINT.CUSTOMERS,@VM)
        FOR J.VAR = 1 TO Y.CUST.CNT
            Y.RTE.ID = CUS.ACC.ID:'.':Y.CAL.TODAY
            Y.RTE.ID = Y.JOINT.CUSTOMERS<1,J.VAR>:'.':Y.CAL.TODAY
*            CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
            CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
            GOSUB VERIFY.RTE.CASH.TXN
        NEXT J.VAR

*        GOSUB UPDATE.RTE.FILE

*        R.REDO.RTE.CUST.CASHTXN = ''
*        REDO.RTE.CUST.CASHTXN.ERR = ''
*        CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
*        IF R.REDO.RTE.CUST.CASHTXN THEN
*            Y.CASH.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>
*            Y.AMT.CNT = DCOUNT(Y.CASH.AMOUNT.LIST,VM)
*            FOR J = 1 TO Y.AMT.CNT
*                Y.VERS.TOT.AMT += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,J>
*            NEXT J
*        END
*        IF Y.VERS.TOT.AMT EQ '' THEN
*            Y.CUR.TXN.AMT = Y.TOT.TXN.AMT
*        END
*        ELSE
*            Y.CUR.TXN.AMT = Y.VERS.TOT.AMT
*        END
    END

*    IF PROCESS.GOAHEAD THEN
*        IF Y.CUR.TXN.AMT GE R.REDO.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY> THEN
*            CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),VM)+1
*            TEXT='AML.TXN.AMT.EXCEED'
*            CALL STORE.OVERRIDE(CURR.NO)
*        END

RETURN

*****************
UPDATE.RTE.FILE:
*****************
    Y.FUNC = V$FUNCTION
    Y.PGM.VER = FIELD(PGM.VERSION,',',2)

    Y.DATE.TIME = TIMEDATE()
    Y.INITIAL.ID = ''
    IF (V$FUNCTION EQ 'D' AND R.NEW(TFS.RECORD.STATUS) EQ 'INAU') OR (R.NEW(TFS.RECORD.STATUS) EQ 'INAO' AND V$FUNCTION EQ 'D') OR (R.NEW(TFS.RECORD.STATUS) EQ '' AND V$FUNCTION EQ 'R') OR (R.NEW(TFS.RECORD.STATUS) EQ 'RNAU' AND V$FUNCTION EQ 'D') OR (R.NEW(TFS.RECORD.STATUS) EQ 'RNAO' AND V$FUNCTION EQ 'D') THEN
        IF Y.JOINT.CUSTOMERS THEN
            Y.CUS.ACC.ID = CUS.ACC.ID:@VM:Y.JOINT.CUSTOMERS
        END ELSE
            Y.CUS.ACC.ID = CUS.ACC.ID
        END
        Y.CUST.CNT = DCOUNT(Y.CUS.ACC.ID,@VM)
        FOR K.VAR = 1 TO Y.CUST.CNT
            Y.RTE.ID =  Y.CUS.ACC.ID<1,K.VAR>:'.':Y.CAL.TODAY
            REDO.RTE.CUST.CASHTXN.ERR = ''
            CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,RTE)
            IF R.REDO.RTE.CUST.CASHTXN THEN

                LOCATE ID.NEW IN R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,1> SETTING RTE.ID.POS THEN
                    IF ((V$FUNCTION EQ 'D') AND (R.NEW(TFS.RECORD.STATUS) EQ 'INAU' OR R.NEW(TFS.RECORD.STATUS) EQ 'INAO')) THEN
                        R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,RTE.ID.POS> = ''
                        R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,RTE.ID.POS> = Y.FUNC
                        R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,RTE.ID.POS> = 'REVERTED'
                    END
                    ELSE
                        IF (R.NEW(TFS.RECORD.STATUS) EQ '' AND V$FUNCTION EQ 'R') THEN
                            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,RTE.ID.POS> = ''
                            R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,RTE.ID.POS> = Y.FUNC
                            R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG,RTE.ID.POS> = 'REVERTED'
                        END
                        ELSE
                            IF ((R.NEW(TFS.RECORD.STATUS) EQ 'RNAU' OR R.NEW(TFS.RECORD.STATUS) EQ 'RNAO') AND V$FUNCTION EQ 'D') THEN
                                R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,RTE.ID.POS> = Y.TOT.TXN.AMT
                                R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION,RTE.ID.POS> = 'I'
                            END
                        END
                    END
                    CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
                    PROCESS.GOAHEAD = ''
                END
                CALL F.WRITE(F.FILE.PATH,Y.RTE.ID,R.DVERSION.DETAILS)
                PROCESS.GOAHEAD = ''
            END
        NEXT K.VAR
    END
    ELSE
        REDO.RTE.CUST.CASHTXN.ERR = ''
        CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,RTE)
        IF R.REDO.RTE.CUST.CASHTXN THEN
            LOCATE ID.NEW IN R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,1> SETTING RTE.ID.POS ELSE
                R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,-1> = ID.NEW
                R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID,-1> = Y.INITIAL.ID
                R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE,-1> = ID.COMPANY
                R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,-1> = Y.TOT.TXN.AMT
*            R.REDO.RTE.CUST.CASHTXN<RTE.VERSION.TYPE,-1> = R.VERSION(EB.VER.VERSION.TYPE)
                R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,-1> = Y.DATE.TIME
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
            R.REDO.RTE.CUST.CASHTXN<RTE.INITIAL.ID> = Y.INITIAL.ID
*            R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE> = R.NEW(TFS.CO.CODE)
            R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE> = ID.COMPANY
            R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT> = Y.TOT.TXN.AMT
*            R.REDO.RTE.CUST.CASHTXN<RTE.VERSION.TYPE> = R.VERSION(EB.VER.VERSION.TYPE)
            R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE> = Y.DATE.TIME
            R.REDO.RTE.CUST.CASHTXN<RTE.ACTUAL.VERSION> = Y.CURRENT.VERSION
            R.REDO.RTE.CUST.CASHTXN<RTE.FUNCTION> = Y.FUNC
            IF Y.RTE.FLAG.RESET EQ '' THEN
                Y.RTE.FLAG.RESET = 'IN PROGRESS'
            END
            R.REDO.RTE.CUST.CASHTXN<RTE.RTE.RESET.FLAG> = Y.RTE.FLAG.RESET
            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.REDO.RTE.CUST.CASHTXN)
        END
    END

RETURN

*-----------------------------------------------------------------------------------------------------------------------
********************
READ.REDO.AML.PARAM:
********************

    R.REDO.AML.PARAM  = ''
    REDO.AML.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.AML.PARAM,REDO.AML.PARAM.ID,R.REDO.AML.PARAM,REDO.AML.PARAM.ER)
    Y.AMT.LIMIT.FCY = R.REDO.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************

    APPL.ARRAY = 'TRANSACTION':@FM:'CURRENCY':@FM:'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TR.AML.CHECK':@FM:'L.CU.AMLBUY.RT':@FM:'L.RTE.FORM':@VM:'L.FT.ADD.INFO'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.TR.AML.CHECK.POS = FLD.POS<1,1>
    LOC.L.CU.AMLBUY.RT.POS = FLD.POS<2,1>
    LOC.L.RTE.FORM.POS     = FLD.POS<3,1>
    LOC.L.FT.ADD.INFO.POS = FLD.POS<3,2>

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
VERIFY.RTE.CASH.TXN:
*********************

    Y.LOOP.AMT = ''
    Y.BREAK.FLAG = ''
    Y.LOOP.AMT.TDY = ''

* RTE - TODAY RECORD reverse LOOP
    IF R.REDO.RTE.CUST.CASHTXN THEN
        Y.CASH.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>
        Y.AMT.CNT = DCOUNT(Y.CASH.AMOUNT.LIST,@VM)
*        FOR J = Y.AMT.CNT TO 1
        J.VAR = Y.AMT.CNT
        LOOP
        WHILE J.VAR NE 0
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
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + Y.TOT.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.RTE.FILE     ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
                            GOSUB UPDATE.RTE.FILE
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
*    CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
    CALL F.READU(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.REDO.RTE.CUST.CASHTXN.YSTRDY THEN
        Y.YSTRDY.AMOUNT.LIST = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT>
        Y.YSTRDY.AMT.CNT = DCOUNT(Y.YSTRDY.AMOUNT.LIST,@VM)
        X.VAR = Y.YSTRDY.AMT.CNT
*        FOR X = Y.YSTRDY.AMT.CNT TO 1
        LOOP
        WHILE X.VAR NE 0
            Y.TRANS.DATE.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.TRANS.DATE,X.VAR>
            Y.FLAG.RESET.YSTRDY = R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR>
            Y.CURRENT.TIME.YSTRDY = OCONV(TIME(),'MTS')
            Y.CURRENT.SECS.YSTRDY = ICONV(Y.CURRENT.TIME.YSTRDY,'MTH')
            Y.TRANS.DATE.SECS.YSTRDY = ICONV(Y.TRANS.DATE.YSTRDY[1,8],'MTH')
            BEGIN CASE
                CASE Y.FLAG.RESET.YSTRDY EQ 'STARTED'
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + Y.TOT.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            GOSUB UPDATE.RTE.FILE     ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
                            GOSUB UPDATE.RTE.FILE
                        END
                    END ELSE
                        Y.LOOP.AMT.YSTRDY.CUR = Y.LOOP.AMT.YSTRDY + R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY.CUR + Y.LOOP.AMT.TDY
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                            CALL F.WRITE(FN.REDO.RTE.CUST.CASHTXN,Y.LAST.RTE.ID,R.REDO.RTE.CUST.CASHTXN.YSTRDY)
                            Y.RTE.TOT.AMT = Y.TOT.TXN.AMT / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.RTE.FILE ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
                                VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                                TEXT    = VAR.OVERRIDE.ID
                                CALL STORE.OVERRIDE(CURR.NO+1)
                            END ELSE
                                Y.RTE.FLAG.RESET = 'STARTED'
                                GOSUB UPDATE.RTE.FILE
                            END
                        END ELSE

                            R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                            GOSUB RTE.RESET.CHECK
                            Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + Y.TOT.TXN.AMT
                            Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                            IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
                                GOSUB UPDATE.RTE.FILE ;* Update the Current RTE amount and the corresponding values in the RTE table.
                                CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
                                VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                                TEXT    = VAR.OVERRIDE.ID
                                CALL STORE.OVERRIDE(CURR.NO+1)
                            END ELSE
                                GOSUB UPDATE.RTE.FILE
                            END
                        END
*                    Y.RTE.FLAG.RESET = 'STARTED'
*                    GOSUB UPDATE.RTE.FILE
                    END
                    BREAK         ;* The loop should break as we have already found the STARTED flag in ystrdy record.
                CASE OTHERWISE
                    IF Y.TRANS.DATE.SECS.YSTRDY GE Y.CURRENT.SECS.YSTRDY THEN
                        Y.LOOP.AMT.YSTRDY += R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.CASH.AMOUNT,X.VAR>
                    END ELSE
                        R.REDO.RTE.CUST.CASHTXN.YSTRDY<RTE.RTE.RESET.FLAG,X.VAR> = 'COMPLETED'
                        GOSUB RTE.RESET.CHECK

                        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.YSTRDY + Y.LOOP.AMT.TDY + Y.TOT.TXN.AMT
                        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
                        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
*                        Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.RTE.FILE     ;* Update the Current RTE amount and the corresponding values in the RTE table.
                            CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
                            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
                            TEXT    = VAR.OVERRIDE.ID
                            CALL STORE.OVERRIDE(CURR.NO+1)
                        END ELSE
*                        Y.RTE.FLAG.RESET = 'STARTED'
                            GOSUB UPDATE.RTE.FILE     ;* Update the Current RTE amount and the corresponding values in the RTE table.
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
        Y.RTE.TOT.AMT.TMP = Y.LOOP.AMT.TDY + Y.TOT.TXN.AMT
        Y.RTE.TOT.AMT =  Y.RTE.TOT.AMT.TMP / CUR.AMLBUY.RATE
        IF Y.RTE.TOT.AMT GE Y.AMT.LIMIT.FCY THEN
            GOSUB UPDATE.RTE.FILE       ;* Update the Current RTE amount and the corresponding values in the RTE table.
            CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)
            VAR.OVERRIDE.ID  = 'AML.TXN.AMT.EXCEED'
            TEXT    = VAR.OVERRIDE.ID
            CALL STORE.OVERRIDE(CURR.NO+1)
        END ELSE
            GOSUB UPDATE.RTE.FILE       ;* Update the Current RTE amount and the corresponding values in the RTE table.
        END
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
