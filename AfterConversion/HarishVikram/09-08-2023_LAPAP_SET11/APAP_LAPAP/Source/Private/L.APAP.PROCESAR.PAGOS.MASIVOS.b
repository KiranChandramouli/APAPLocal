* @ValidationCode : MjotODg0MDIwODA6Q3AxMjUyOjE2OTE1NzM4MjI0ODM6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Aug 2023 15:07:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>734</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.PROCESAR.PAGOS.MASIVOS(Y.PARAM, Y.USR_CREDENTIALS ,Y.RABBIT.MQ.OUT)
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 09-08-2023      Harishvikram C   Manual R22 conversion      BP Removed, $INCLUDE to $INSERT, CALL routine format modified
*-----------------------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT  I_F.LAPAP.BULK.PAYROLL
    $INSERT  I_F.DATES
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.AC.LOCKED.EVENTS
    $INSERT  I_F.LAPAP.GENERIC.PARAMS

    GOSUB INITIALISE
    GOSUB LOAD.VARIABLES
    GOSUB REQUEST
    GOSUB PROCESS.N.RESPONSE

RETURN

INITIALISE:

    MSG = ''
    MSG<-1> = 'Inicio proceso : ': TIMEDATE()
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

    Y.G.LOG.ID = "BULK.PAYROLL." : TIMESTAMP()
    Y.TODAY.DATE = DATE()
    Y.TODAY.DATE = OCONV(Y.TODAY.DATE, "D4")

    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.PROCESS.RABBIT.JSON.REQ'

    Y.TRANSACTION.SUCCESS.GLOBAL = ''
    Y.TRANSACTION.FAIL.GLOBAL = ''
    Y.MSG.ERROR = ''

    JSON.REQUEST = ''
    JSON.RESPONSE = ''

    Y.DYN.REQUEST.KEY = ''
    Y.DYN.REQUEST.VALUE = ''
    Y.DYN.REQUEST.TYPE = ''

    Y.DYN.REQUEST.OFS.KEY = ''
    Y.DYN.REQUEST.OFS.TYPE = ''

    Y.DYN.RESPONSE.KEY = ''
    Y.DYN.RESPONSE.VALUE = ''
    Y.DYN.RESPONSE.TYPE = ''

    Y.DYN.MAPPING.IN = ''
    Y.RABBIT.MQ.IN = ''

    Y.DYN.MAPPING.OUT = ''
    Y.RABBIT.MQ.OUT = ''

    Y.OFS.IN.REQUEST = ''
    Y.OFS.IN.RESPONSE =  ''

    Y.OFS.OUT.REQUEST = ''
    Y.OFS.OUT.RESPONSE = ''

    Y.OBJECT.TYPE = ''
    Y.ADDNL.INFO = ''

    Y.REASONS = ''
    Y.OFS.MESSAGES = ''

RETURN

REQUEST:


    IF TRIM(Y.PARAM, " ", "R") = ""  THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = "BLANK MESSAGE"
        RETURN
    END

*--------------JSON.REQUEST  = Y.PARAM----------------------------
*    CALL L.APAP.JSON.STRINGIFY(Y.PARAM , JSON.REQUEST)
    APAP.LAPAP.lApapJsonStringify(Y.PARAM , JSON.REQUEST)   ;*Manual R22 conversion

*----------------LOAD DYN FROM JSON ---------------------------
*    CALL L.APAP.JSON.TO.DYN.OFS(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)
    APAP.LAPAP.lApapJsonToDynOfs(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)     ;*Manual R22 conversion
    IF Y.ERROR<1> = 1 THEN
        RETURN
    END

    Y.ID.PAGO        = Y.DYN.REQUEST.VALUE<1>
    Y.TRANSACCIONES  = Y.DYN.REQUEST.VALUE<4>
    Y.DEBIT.CURRENCY = Y.DYN.REQUEST.VALUE<3>
    Y.DEBIT.ACCOUNT  = Y.DYN.REQUEST.VALUE<2>
    Y.TODAY = R.DATES(EB.DAT.TODAY)
    DATE.STAMP = Y.TODAY
    TIME.STAMP = TIMEDATE()
    DATE.TIME  = DATE.STAMP:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    Y.PAYROLL.ID = 'APAP01.' : DATE.TIME

    Y.SALIDA = ""

    MSG<-1> = Y.DYN.REQUEST.VALUE<2>    ;*Debit account
    MSG<-1> = Y.DYN.REQUEST.VALUE<3>    ;*Debit ccy
    MSG<-1> = 'Valor Y.TODAY: ' : Y.TODAY
    MSG<-1> = 'Valor Y.TODAY.DATE = ' : Y.TODAY.DATE
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

    Y.TXN.ARR = ''
    Y.TOT.AMT = 0
    CHANGE ']'  TO @VM IN Y.TRANSACCIONES

    CANT_OBJECT = DCOUNT(Y.TRANSACCIONES, @VM)
    FOR CONTA=1 TO CANT_OBJECT STEP 1

        Y.REGISTER= Y.TRANSACCIONES<1,CONTA>
        CHANGE ',' TO @FM IN Y.REGISTER
        CHANGE ':' TO @VM IN Y.REGISTER

        Y.PAYMENT.ID.EXT = CHANGE(Y.REGISTER<1,2>,'"','') ;
        Y.CREDIT.BANK            =  CHANGE(Y.REGISTER<2,2>,'"','')
        Y.CREDIT.ACCOUNT         =  CHANGE(Y.REGISTER<3,2>,'"','')
        Y.CREDIT.CURRENCY        =  CHANGE(Y.REGISTER<4,2>,'"','')
        Y.CREDIT.AMOUNT          =  CHANGE(Y.REGISTER<5,2>,'"','')
        Y.IDENTIFICATION.NUMBER  =  CHANGE(Y.REGISTER<6,2>,'"','')
        Y.FULLNAME   =  CHANGE(Y.REGISTER<7,2>,'"','')
        Y.DESCRIPTION            =  CHANGE(CHANGE(Y.REGISTER<8,2>,'"',''),'}','')

        Y.REC.ID = Y.PAYROLL.ID : '.' : Y.IDENTIFICATION.NUMBER : '.' : CONTA
        R.PR.D = ''
        R.PR.D<ST.LAP4.PAYROLL.ID> = Y.PAYROLL.ID
        R.PR.D<ST.LAP4.CREDIT.CCY> = Y.CREDIT.CURRENCY
        R.PR.D<ST.LAP4.CREDIT.ACCOUNT> = Y.CREDIT.ACCOUNT
        R.PR.D<ST.LAP4.CREDIT.AMOUNT> = Y.CREDIT.AMOUNT
        R.PR.D<ST.LAP4.COMMENTS> = Y.DESCRIPTION
        IF Y.CREDIT.BANK EQ '47940900' THEN
            R.PR.D<ST.LAP4.PAYROLL.TYPE> = "APAP"
        END ELSE
            R.PR.D<ST.LAP4.PAYROLL.TYPE> = "OTHER.BANK"
        END
        R.PR.D<ST.LAP4.BEN.IDENTIFICATION> = Y.IDENTIFICATION.NUMBER
        R.PR.D<ST.LAP4.PAYMENT.STATUS> = "PENDING"
        R.PR.D<ST.LAP4.BEN.BANK> = Y.CREDIT.BANK
        R.PR.D<ST.LAP4.BEN.FULL.NAME> = Y.FULLNAME

        R.PR.D<ST.LAP4.PAYMENT.ID> = Y.PAYMENT.ID.EXT

        CALL F.WRITE(FN.BPRDET, Y.REC.ID, R.PR.D)
        CALL JOURNAL.UPDATE('')
        Y.TOT.AMT += Y.CREDIT.AMOUNT


    NEXT CONTA

    MSG = ''
    MSG<-1> = 'Tot Amt: ' : Y.TOT.AMT

*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

    GOSUB DO.CHECK.ACC
    MSG = ''
    MSG<-1> = 'Account msg: ' : A.ACC.MSG
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)
*************************************************
*--------------------------------------------------------------------------------------------
    IF Y.ACC.ERROR EQ 0 THEN

        GOSUB DO.MAKE.FUNDS.RETENTION
*Y.FT.ID = ''
*R.FT.M<FT.TRANSACTION.TYPE> = 'AC2E'
*R.FT.M<FT.DEBIT.ACCT.NO> = Y.DEBIT.ACCOUNT
*R.FT.M<FT.CREDIT.CURRENCY> = Y.DEBIT.CURRENCY
*R.FT.M<FT.CREDIT.AMOUNT> = Y.TOT.AMT
*R.FT.M<FT.DEBIT.VALUE.DATE> = TODAY
*R.FT.M<FT.CREDIT.ACCT.NO> = 'DOP1792039010039'
*R.FT.M<FT.LOCAL.REF,DESCRIPTION.POS,1> = 'Debito pago nomina'
*R.FT.M<FT.LOCAL.REF,L.PAYROLL.ID.POS,1> = Y.PAYROLL.ID

*Y.TRANS.ID = ""
*Y.APP.NAME = "FUNDS.TRANSFER"
*Y.VER.NAME = Y.APP.NAME :",PAYROLL.MASTER"
*Y.VERSION.NAME = 'PAYROLL.MASTER'
*Y.FUNC = "I"
*Y.PRO.VAL = "PROCESS"
*Y.GTS.CONTROL = ""
*Y.NO.OF.AUTH = "0"
*FINAL.OFS = ""
*OPTIONS = ""

*Y.TXN.RESULT = ''
*CALL LAPAP.OFS.BUILDER(Y.APP.NAME,Y.VERSION.NAME,Y.FUNC,Y.NO.OF.AUTH,Y.PRO.VAL,Y.GTS.CONTROL,Y.OFS.USER,'',"DO0010001",Y.TRANS.ID,R.FT.M,OUT.OFS)
*CALL OFS.BULK.MANAGER(OUT.OFS, Y.TXN.RESULT, '')

*MSG = ''
*MSG<-1> = 'OFS to send: ' : OUT.OFS
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

*Y.TXN.NEW.ID = FIELD(Y.TXN.RESULT,'/',1)
*Y.TXN.RES.CODE = FIELD(Y.TXN.RESULT,'/',3)
*Y.TXN.RES.CODE = FIELD(Y.TXN.RES.CODE,',',1)
*Y.TXN.MESSAGE = FIELD(Y.TXN.RESULT,'/',3)
*Y.TXN.MESSAGE = FIELD(Y.TXN.MESSAGE,',',2)

*MSG = ''

*MSG<-1> = "Y.SUCCESS.IND = " : Y.TXN.RES.CODE
*MSG<-1> = "Y.ID.NEW.FT = " : Y.TXN.NEW.ID
*MSG<-1> = Y.TXN.RESULT

*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

        Y.SUCCESS.IND = Y.TXN.RES.CODE
*Y.SALIDA<-1> = 'MASTER FUNDS.TRANSFER = ' : Y.TXN.NEW.ID
        Y.SALIDA<-1> = 'MASTER FUNDS HOLD = ' : Y.TXN.NEW.ID
        Y.SALIDA<-1> = 'SUCCESS INDICADOR = ' : Y.TXN.RES.CODE

    END ELSE
        Y.SUCCESS.IND = "-1"
        Y.RABBIT.MQ.OUT<-1> = A.ACC.MSG

        MSG = ''
        MSG<-1> = "Y.SUCCESS.IND = " : Y.SUCCESS.IND
        MSG<-1> = "Account error = " : A.ACC.MSG
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)
    END
*--------------------------------------------------------------------------------------------
*************************************************

    R.HDR  = ''
    R.HDR<ST.LAP39.PAYROLL.ID> = Y.PAYROLL.ID
    R.HDR<ST.LAP39.DEBIT.ACCOUNT> = Y.DEBIT.ACCOUNT
    R.HDR<ST.LAP39.DEBIT.CCY> = Y.DEBIT.CURRENCY
    R.HDR<ST.LAP39.TRANS.ACCOUNT> = Y.TRANS.ACCOUNT
    R.HDR<ST.LAP39.PAYROLL.AMOUNT> = Y.TOT.AMT

    IF Y.SUCCESS.IND[1,1] EQ "1" THEN
        R.HDR<ST.LAP39.OUR.REFERENCE> = ''
        R.HDR<ST.LAP39.LOCK.EVENT.ID> = Y.TXN.NEW.ID
    END ELSE
        R.HDR<ST.LAP39.OUR.REFERENCE> = ''
    END


    XDATE = OCONV(DATE(),"D-")
    X = XDATE[9,2]:XDATE[1,2]:XDATE[4,2]:TIMEDATE()[1,2]:TIMEDATE()[4,2]

    R.HDR<ST.LAP39.PAYROLL.DATE> = OCONV(ICONV(X[1,6],"D2/"),'D4Y'):X[3,4]

    IF Y.SUCCESS.IND[1,1] EQ "1" THEN
        R.HDR<ST.LAP39.PAYROLL.STATUS> = 'PENDING'
        Y.SALIDA<-1> = 'Payroll ' : Y.PAYROLL.ID : ' , inserted with status: ' : 'PENDING'
    END ELSE
        R.HDR<ST.LAP39.PAYROLL.STATUS> = 'NOT.APPLIED'
        Y.SALIDA<-1> = 'Payroll ' : Y.PAYROLL.ID : ' , inserted with status: ' : 'NOT.APPLIED'
    END
    R.HDR<ST.LAP39.PAYMENT.ID> = Y.ID.PAGO

    R.HDR<ST.LAP39.DATE.TIME> = X


*--------------------------------------------------------------------------------------------
    Y.TRANS.ID = Y.PAYROLL.ID
    Y.APP.NAME = "ST.LAPAP.BULK.PAYROLL"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = "0"
    FINAL.OFS = ""
    OPTIONS = ""
*Modificar aqui, usar F.LIVE.WRITE(FL,ID,REC)
*CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.HDR,FINAL.OFS)
*RUNNING.UNDER.BATCH = 1
*CALL OFS.POST.MESSAGE(FINAL.OFS,'',"PAYROLL.OFS",'')
*RUNNING.UNDER.BATCH = 0
*CALL F.LIVE.WRITE(FN.BPR,Y.TRANS.ID,R.HDR)
    CALL F.WRITE(FN.BPR, Y.TRANS.ID, R.HDR)
    CALL JOURNAL.UPDATE(Y.TRANS.ID)
    CRT 'Record ' : Y.TRANS.ID : ' , wrote to ': FN.BPR
    Y.SALIDA<-1> = 'Record ' : Y.TRANS.ID : ' , wrote to ': FN.BPR
    MSG = ''
    MSG<-1> = 'OFS Message = '
    MSG<-1> = FINAL.OFS
    MSG<-1> = 'Fin proceso : ': TIMEDATE()
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

*Send Notification to Rabbit if any error

    CRT 'Y.ACC.ERROR value: ' : Y.ACC.ERROR
    CRT 'A.ACC.MSG value: ' : A.ACC.MSG
    CRT 'Success Ind: ' : Y.SUCCESS.IND
    V.EB.API.ID = 'PAYROLL.INTERFACE'
    IF Y.ACC.ERROR EQ 1 THEN
*Y.PARAMETRO.ENVIO = Y.ID.PAGO : '@' : "Not applied" : '@' : '00000000-0000-0000-0000-000000000000^^Failed^':A.ACC.MSG
        Y.PARAMETRO.ENVIO = Y.ID.PAGO : '@' : "Not applied" : '@' : '' : '@' : '' :'@' : '00000000-0000-0000-0000-000000000000^^Failed^Master payment was not successfull'
        CRT 'Y.PARAMETRO.ENVIO ->' : Y.PARAMETRO.ENVIO
        CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
        CRT 'CALLJ response: ' : Y.RESPONSE
        CRT 'CALLJ Error : ' : Y.CALLJ.ERROR

        RETURN
    END
    IF Y.SUCCESS.IND[1,1] NE "1" THEN
*Y.PARAMETRO.ENVIO = Y.ID.PAGO : '@' : "Not applied" : '@' : '00000000-0000-0000-0000-000000000000^^Failed^':Y.TXN.RESULT
        Y.PARAMETRO.ENVIO = Y.ID.PAGO : '@' : "Not applied" : '@' : '' : '@' : '' :'@' : '00000000-0000-0000-0000-000000000000^^Failed^':Y.TXN.RESULT
        CRT 'Y.PARAMETRO.ENVIO ->' : Y.PARAMETRO.ENVIO

        CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
        CRT 'CALLJ response: ' : Y.RESPONSE
        CRT 'CALLJ Error : ' : Y.CALLJ.ERROR

        RETURN
    END

*--------------------------------------------------------------------------------------------


RETURN
*--------------------------------------------------------------------------------------------
DO.MAKE.FUNDS.RETENTION:
    Y.ACLE.ID = ''
    R.ACLE<AC.LCK.ACCOUNT.NUMBER> = Y.DEBIT.ACCOUNT
    R.ACLE<AC.LCK.DESCRIPTION> = 'RET. FONDOS NOMINA'
    R.ACLE<AC.LCK.FROM.DATE> = TODAY
    Y.END.DATE = TODAY
    DAY.COUNT = "+1W"
    CALL CDT('', Y.END.DATE, DAY.COUNT)
    R.ACLE<AC.LCK.TO.DATE> = Y.END.DATE


    Y.AMT.TO.LOCK = Y.TOT.AMT * 1.0015
    CALL EB.ROUND.AMOUNT('DOP',Y.AMT.TO.LOCK,2,"")

    R.ACLE<AC.LCK.LOCKED.AMOUNT> = Y.AMT.TO.LOCK

    Y.TRANS.ID = ""
    Y.APP.NAME = "AC.LOCKED.EVENTS"
    Y.VER.NAME = Y.APP.NAME :",LAPAP.PAYROLL"
    Y.VERSION.NAME = 'LAPAP.PAYROLL'
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = "0"
    FINAL.OFS = ""
    OPTIONS = ""

    Y.TXN.RESULT = ''
*    CALL LAPAP.OFS.BUILDER(Y.APP.NAME,Y.VERSION.NAME,Y.FUNC,Y.NO.OF.AUTH,Y.PRO.VAL,Y.GTS.CONTROL,Y.OFS.USER,'',"DO0010001",Y.TRANS.ID,R.ACLE,OUT.OFS)
    APAP.LAPAP.lapapOfsBuilder(Y.APP.NAME,Y.VERSION.NAME,Y.FUNC,Y.NO.OF.AUTH,Y.PRO.VAL,Y.GTS.CONTROL,Y.OFS.USER,'',"DO0010001",Y.TRANS.ID,R.ACLE,OUT.OFS)  ;*Manual R22 conversion
    CALL OFS.BULK.MANAGER(OUT.OFS, Y.TXN.RESULT, '')


    Y.TXN.NEW.ID = FIELD(Y.TXN.RESULT,'/',1)
    Y.TXN.RES.CODE = FIELD(Y.TXN.RESULT,'/',3)
    Y.TXN.RES.CODE = FIELD(Y.TXN.RES.CODE,',',1)
    Y.TXN.MESSAGE = FIELD(Y.TXN.RESULT,'/',3)
    Y.TXN.MESSAGE = FIELD(Y.TXN.MESSAGE,',',2)


RETURN
*--------------------------------------------------------------------------------------------
***************
LOAD.VARIABLES:
***************
    IF PUTENV('OFS_SOURCE=PAYROLL') THEN NULL
    CALL JF.INITIALISE.CONNECTION

    APPL.NAME.ARR = "FUNDS.TRANSFER"
    FLD.NAME.ARR = "L.COMMENTS" : @VM : "L.FT.CONCEPT" : @VM : "L.PAYROLL.ID"

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    DESCRIPTION.POS = FLD.POS.ARR<1,1>
    L.PAYROLL.ID.POS  = FLD.POS.ARR<1,3>

    FN.BPRDET = 'FBNK.ST.LAPAP.BULK.PAYROLL.DET' ;
    F.BPRDET= ''
    CALL OPF(FN.BPRDET, F.BPRDET)

    FN.BPR = 'F.ST.LAPAP.BULK.PAYROLL'
    F.BPR= ''
    CALL OPF(FN.BPR,F.BPR)

    FN.ACCOUNT = 'FBNK.ACCOUNT' ;
    F.ACCOUNT= ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.PARAMETERS = 'F.ST.LAPAP.GENERIC.PARAMS'
    F.PARAMETERS = ''
    CALL OPF(FN.PARAMETERS,F.PARAMETERS)

    OFS$SOURCE.ID.BACKUP = "PAYROLL"

    Y.OFS.USER = ''
    IF GETENV("PAYROLL_OFS_USER", Y.OFS.USER) THEN
        MSG = ''
        CRT 'OFS.USER TO USE'
        CRT Y.OFS.USER
    END ELSE
        CRT 'OFS USER NOT SET'
        CRT Y.OFS.USER
    END
*Y.OFS.USER = 'NOMINAT24'

    CALL F.READ(FN.PARAMETERS,'BULK.PAYROLL',R.PARAMETER,F.PARAMETERS,ERR.PARAMETERS)
    Y.TRANS.ACCOUNT = ''
    IF(R.PARAMETER) THEN
        Y.KEY.LIST = R.PARAMETER<ST.LAP77.PARAM.KEY>
        FINDSTR "TRANS.ACCOUNT" IN Y.KEY.LIST SETTING fieldPos, valuePos THEN
            Y.TRANS.ACCOUNT = R.PARAMETER<ST.LAP77.PARAM.VALUE,valuePos>
        END
    END
RETURN


PROCESS.N.RESPONSE:

*Y.RABBIT.MQ.OUT = Y.OFS.MESSAGES;
    CHANGE @FM TO '|' IN Y.SALIDA
    Y.RABBIT.MQ.OUT = Y.SALIDA
RETURN
*--------------------------------------------------------------------------------------------------
DO.CHECK.ACC:
    Y.ACC.ID = Y.DEBIT.ACCOUNT
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)

    Y.ACC.ERROR = 0
    A.ACC.MSG = ''

    MSG = ''
    MSG<-1> = 'Checking Account'
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)

    IF (R.ACCOUNT) THEN

        Y.ONLINE.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
        IF Y.ONLINE.BAL LE Y.TOT.AMT THEN
            Y.ACC.ERROR = 1
            A.ACC.MSG = 'Insufficient balance on account'
            RETURN
        END
        Y.AC.POSTING.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
        IF Y.AC.POSTING.RESTRICT NE '' THEN
            Y.POST.RESTRICT.COUNT = DCOUNT(Y.AC.POSTING.RESTRICT,@VM)
            FOR PR.CNT = 1 TO Y.POST.RESTRICT.COUNT STEP 1
                Y.POSTR = Y.AC.POSTING.RESTRICT<1,PR.CNT>
                IF Y.POSTR EQ '3' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 3'
                    RETURN
                END
                IF Y.POSTR EQ '1' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 1'
                    RETURN
                END
                IF Y.POSTR EQ '4' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 4'
                    RETURN
                END
                IF Y.POSTR EQ '5' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 5'
                    RETURN
                END
                IF Y.POSTR EQ '50' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 50'
                    RETURN
                END
                IF Y.POSTR EQ '80' THEN
                    Y.ACC.ERROR = 1
                    A.ACC.MSG = 'Posting Restrict number 80'
                    RETURN
                END
            NEXT PR.CNT
        END

    END ELSE
        Y.ACC.ERROR = 1
        A.ACC.MSG = 'Account record not found.'

        MSG = ''
        MSG<-1> = 'Account record does not exists'
*CALL LAPAP.LOGGER('TESTLOG',Y.G.LOG.ID,MSG)
    END


RETURN

*--------------------------------------------------------------------------------------------------
END
