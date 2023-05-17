SUBROUTINE REDO.FI.FT.PROCESS.POST

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.CANCELLED
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.TEMP.FI.CONTROL
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.APAP.PARAM.EMAIL
    $INSERT I_F.REDO.ISSUE.EMAIL
    $INSERT I_F.REDO.NOMINA.DET
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*----

    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""

    FN.REDO.APAP.PARAM.EMAIL = "F.REDO.APAP.PARAM.EMAIL"
    F.REDO.APAP.PARAM.EMAIL  = ""

    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED  = ''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    FN.REDO.L.NCF.UNMAPPED = 'F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED  = ''
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

    FN.REDO.L.NCF.STATUS = 'F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS  = ''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.REDO.L.NCF.CANCELLED = 'F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED  = ''
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,'SYSTEM',R.EMAIL,MAIL.ERR)
    Y.FILE.PATH   = R.EMAIL<REDO.PRM.MAIL.IN.PATH.MAIL>
    Y.ATTACH.PATH = R.EMAIL<REDO.PRM.MAIL.ATTACH.PATH.MAIL>

    FN.REDO.TEMP.FI.CONTROL='F.REDO.TEMP.FI.CONTROL'
    F.REDO.TEMP.FI.CONTROL =''
    CALL OPF(FN.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL)

    FN.REDO.FI.CONTROL     ='F.REDO.FI.CONTROL'
    F.REDO.FI.CONTROL      =''
    CALL OPF(FN.REDO.FI.CONTROL,F.REDO.FI.CONTROL)
    GOSUB INIT.SEC
RETURN
*--------
INIT.SEC:
*--------
    FN.HRMS.DET.FILE        = Y.FILE.PATH
    F.HRMS.DET.FILE         = ""
    CALL OPF(FN.HRMS.DET.FILE,F.HRMS.DET.FILE)

    FN.HRMS.ATTACH.FILE        = Y.ATTACH.PATH
    F.HRMS.ATTACH.FILE         = ""
    CALL OPF(FN.HRMS.ATTACH.FILE,F.HRMS.ATTACH.FILE)

    FN.REDO.ISSUE.MAIL = 'F.REDO.ISSUE.EMAIL'
    F.REDO.ISSUE.MAIL = ''
    R.REDO.ISSUE.MAIL = ''
    Y.ISSUE.EMAIL.ERR = ''
    CALL OPF(FN.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL)
*  CALL F.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ; * Tus End
    IF R.REDO.ISSUE.MAIL THEN
        Y.FROM.MAIL.ADD.VAL =  R.REDO.ISSUE.MAIL<ISS.ML.MAIL.ID>
    END

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    R.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    R.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE  = ''
    R.FT.CHARGE.TYPE  = ''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)


    FN.REDO.NOMINA.TEMP='F.REDO.NOMINA.TEMP'
    F.REDO.NOMINA.TEMP =''
    CALL OPF(FN.REDO.NOMINA.TEMP,F.REDO.NOMINA.TEMP)

    FN.REDO.NOMINA.DET  ='F.REDO.NOMINA.DET'
    F.REDO.NOMINA.DET   =''
    CALL OPF(FN.REDO.NOMINA.DET,F.REDO.NOMINA.DET)

    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    LREF.POS = ''
    LREF.APP = 'FUNDS.TRANSFER':@FM:'TELLER'
    LREF.FIELD = 'L.TT.TAX.AMT':@FM:'L.TT.TAX.AMT'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    Y.L.FT.TAX.AMT.POS = LREF.POS<1,1>
    Y.L.TT.TAX.AMT.POS = LREF.POS<2,1>
RETURN
*-------
PROCESS:
*-------
    Y.SEL.CMD='SELECT ':FN.REDO.NOMINA.TEMP
    CALL EB.READLIST(Y.SEL.CMD,Y.REC.LIST,'',NO.OF.FI.CON,Y.ERR)

    Y.REC.CNT=1
    LOOP
    WHILE Y.REC.CNT LE NO.OF.FI.CON

        W.REC.FT.OK =''
        W.TOT.FT.OK =''
        W.REC.FT.ERR=''
        W.TOT.FT.ERR=''
        FI.DATO.MONTO.TOTAL=''
        Y.MAIL.MSG  =''
        Y.ERR.MSG   =''
        FI.PAYMENT.REF=''
        CALL F.READ(FN.REDO.NOMINA.TEMP,Y.REC.LIST<Y.REC.CNT>,R.REDO.NOMINA.TEMP,F.REDO.NOMINA.TEMP,Y.ERR)
        CALL F.READ(FN.REDO.NOMINA.DET,Y.REC.LIST<Y.REC.CNT>,R.REDO.NOMINA.DET,F.REDO.NOMINA.DET,Y.ERR)

        FI.W.REDO.FI.CONTROL   =''
        FI.W.REDO.FI.CONTROL.ID=Y.REC.LIST<Y.REC.CNT>
        CALL F.READ(FN.REDO.FI.CONTROL,Y.REC.LIST<Y.REC.CNT>,FI.W.REDO.FI.CONTROL,F.REDO.FI.CONTROL,ERR)

        Y.FI.TMP.TOT=DCOUNT(R.REDO.NOMINA.TEMP,@FM)

        FI.CTA.DESTINO     =R.REDO.NOMINA.DET<RE.NM.DET.CTA.DESTINO>
        Y.FI.INTERFACE     =R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.NAME>
        Y.FI.INTERFACE.TYPE=R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.TYPE>
        FI.FILE.ID         =FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.NAME>

        GOSUB GET.FTTC.DATA
        Y.FI.TMP.CNT=1
        LOOP
        WHILE Y.FI.TMP.CNT LE Y.FI.TMP.TOT

            CALL F.READ(FN.REDO.TEMP.FI.CONTROL,R.REDO.NOMINA.TEMP<Y.FI.TMP.CNT>,R.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL,ERR)
            R.PARAM=R.REDO.TEMP.FI.CONTROL<FI.TEMP.PARAM.VAL>
            CHANGE @VM TO @FM IN R.PARAM
            Y.TEMP.MAIL.MESSAGE=R.REDO.TEMP.FI.CONTROL<FI.TEMP.MAIL.MSG>
            OUT.RESP       =R.REDO.TEMP.FI.CONTROL<FI.TEMP.RESP.MSG>
            OUT.REF        =R.REDO.TEMP.FI.CONTROL<FI.TEMP.FT.REF>
            CALL REDO.FI.RECORD.TXN.DETAILS(R.PARAM,OUT.RESP,OUT.REF,OUT.ARRAY)
            GOSUB REPORT.FORMAT
            CALL F.DELETE(FN.REDO.TEMP.FI.CONTROL,R.REDO.NOMINA.TEMP<Y.FI.TMP.CNT>)
            Y.FI.TMP.CNT += 1
        REPEAT
        GOSUB BAL.SET.PROCESS
        Y.REC.CNT += 1
    REPEAT
RETURN
*---------------
BAL.SET.PROCESS:
*---------------
    BEGIN CASE
        CASE Y.FI.INTERFACE.TYPE EQ 'ORANGE'

            GOSUB ORANGE.PROCESS
            Y.REF.FILE.NAME   =  'ORANGE STATUS'

        CASE Y.FI.INTERFACE.TYPE EQ 'BACEN'
            GOSUB FI.SUM.UPD
            GOSUB BALANCE.SET.BACEN
            Y.REF.FILE.NAME =  'BANCO CENTRAL STATUS'

        CASE Y.FI.INTERFACE.TYPE EQ 'INTNOMINA'
            GOSUB FI.SUM.UPD
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>       = ''

            GOSUB BAL.SET.INTNOMINA
            Y.REF.FILE.NAME =  'INTERNAL NOMINA STATUS'

        CASE Y.FI.INTERFACE.TYPE EQ 'EXTNOMINA'
            GOSUB FI.SUM.UPD
            IF W.TOT.FT.ERR GT 0 THEN
                Y.COMP.ID = FIELD(FI.W.REDO.FI.CONTROL.ID,'.',2)
                Y.COMP.ID = Y.COMP.ID[1,4]
                CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.COMP.ID,R.REDO.INTERFACE.PARAM.COMP,F.REDO.INTERFACE.PARAM,Y.COMP.ERR)
                FI.PAYMENT.REF=R.REDO.INTERFACE.PARAM.COMP<REDO.INT.PARAM.PAYMENT.REF>
                GOSUB BALANCE.SETTLEMENT
            END
            IF FI.PAYMENT.REF THEN
                Y.COMP.ID = FIELD(FI.W.REDO.FI.CONTROL.ID,'.',2)
                Y.COMP.ID = Y.COMP.ID[1,4]
                CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.COMP.ID,R.REDO.INTERFACE.PARAM.COMP,F.REDO.INTERFACE.PARAM,Y.COMP.ERR)
                R.REDO.INTERFACE.PARAM.COMP<REDO.INT.PARAM.PAYMENT.REF> = ''
                CALL F.WRITE(FN.REDO.INTERFACE.PARAM,Y.COMP.ID,R.REDO.INTERFACE.PARAM.COMP)
            END
            Y.REF.FILE.NAME =  'EXTERNAL NOMINA STATUS'
    END CASE


    CALL REDO.FI.RECORD.CONTROL(Y.ERR.MSG)

    GOSUB MAIL.GENERATION
    CALL F.DELETE(FN.REDO.NOMINA.TEMP,Y.REC.LIST<Y.REC.CNT>)
    CALL F.DELETE(FN.REDO.NOMINA.DET,Y.REC.LIST<Y.REC.CNT>)
RETURN
*----------
FI.SUM.UPD:
*----------

    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>    = W.REC.FT.OK
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>    = W.TOT.FT.OK
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>   = W.REC.FT.OK + W.REC.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>       = W.TOT.FT.OK + W.TOT.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL>  = W.REC.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL>  = W.TOT.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>       = ''
RETURN

*-------------
REPORT.FORMAT:
*-------------

    OUT.MSG  =R.REDO.TEMP.FI.CONTROL<FI.TEMP.RESP.MSG>
    Y.ERR.MSG=''
    IF FIELD(OUT.MSG,'/',1)[1,2] NE 'FT' THEN
        Y.ERR.MSG=OUT.MSG
    END

    IF Y.ERR.MSG NE "" THEN
        W.STATUS          = "04"
        W.ERROR.MSG       = Y.ERR.MSG
        Y.MAIL.MSG<-1>    = Y.TEMP.MAIL.MESSAGE
    END ELSE
        W.STATUS          = "01"
        W.ERROR.MSG       = "OK"
        Y.MAIL.MSG<-1>    = Y.TEMP.MAIL.MESSAGE
    END

    IF Y.ERR.MSG NE "" THEN
        IF R.PARAM<10> EQ "N" THEN
            W.REC.FT.ERR += 1
            W.TOT.FT.ERR +=R.PARAM<7>
        END
    END ELSE
        IF R.PARAM<10> EQ "N" THEN
            W.REC.FT.OK += 1
            W.TOT.FT.OK += R.PARAM<7>
            FI.DATO.MONTO.TOTAL = W.TOT.FT.OK
        END
    END
RETURN
*--------------
GET.FTTC.DATA:
*--------------
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, Y.FI.INTERFACE, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING"
        CALL ERR
    END

    RIP.PARAM        = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE        = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    DR.TXN.CODE      = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DR.TXN.CODE>
    CR.TXN.CODE      = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.CR.TXN.CODE>
    RET.TXN.CODE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TXN.CODE>
    RET.TAX.CODE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TAX.CODE>

    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, DR.TXN.CODE, R.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ERR)
    Y.PAYROLL.COMM.TYPE       = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    Y.PAYROLL.CHG.TYPE        = R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>
    IF Y.PAYROLL.CHG.TYPE THEN
        Y.PAYROLL.CHG.TYPE<2,-1> = 'CHG'
    END

    Y.PAY.COM.FLAT.AMT =''
    Y.PAY.COM.PERCENT  =''
    Y.PAY.CATEG.ACCOUNT=''

    IF Y.PAYROLL.COMM.TYPE THEN
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.PAYROLL.COMM.TYPE, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ERR)
        Y.PAY.COM.FLAT.AMT  = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,1>
        Y.PAY.COM.PERCENT   = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,1,1>
        Y.PAY.CATEG.ACCOUNT = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    END

    CTA.INTERMEDIA = "CTA.INTERMEDIA"
    WPARAM.POS = 1
    FI.CTA.INTERMEDIA=''
    LOCATE CTA.INTERMEDIA IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.CTA.INTERMEDIA = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END

RETURN
* ---------------
MAIL.GENERATION:
* ---------------

    Y.TRANS.DATE = TODAY
    Y.TRANS.TIME= OCONV(TIME(), "MT")
    CHANGE ":" TO '' IN Y.TRANS.TIME
    Y.UNIQUE.ID    = FI.W.REDO.FI.CONTROL.ID:"_":Y.TRANS.DATE:"_":Y.TRANS.TIME
    Y.REQUEST.FILE = Y.UNIQUE.ID:'.TXT'
    Y.ATTACH.FILENAME = 'ATTACHMENT':'_':Y.UNIQUE.ID:'.TXT'
    R.RECORD1 = ''
    CALL REDO.FI.MAIL.FORMAT.GEN(FI.W.REDO.FI.CONTROL.ID,Y.MAIL.DESCRIPTION)
    R.RECORD1 = Y.FROM.MAIL.ADD.VAL:"#":Y.TO.MAIL.VALUE:'#':Y.REF.FILE.NAME:'#':Y.REF.FILE.NAME
    IF Y.MAIL.MSG THEN
        WRITE Y.MAIL.DESCRIPTION TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME
    END
    WRITE R.RECORD1 TO F.HRMS.DET.FILE,Y.REQUEST.FILE

RETURN
*-------------------
BALANCE.SETTLEMENT:
*-----------------


    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = Y.FI.INTERFACE
    R.PARAM<8>  = "DOP"
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"

    Y.PARENT.REF    =''
    Y.PARENT.TAX.AMT=''
    Y.PARENT.FT.REF =''


    IF FI.PAYMENT.REF THEN
        Y.PARENT.REF = FI.PAYMENT.REF
        CALL F.READ(FN.TELLER,FI.PAYMENT.REF,R.TELLER.SETTLE,F.TELLER,TT.ERR)
        Y.PARENT.TAX.AMT =  R.TELLER.SETTLE<TT.TE.LOCAL.REF,Y.L.TT.TAX.AMT.POS>
    END ELSE
        Y.PARENT.FT.REF=FI.W.REDO.FI.CONTROL<REDO.FI.CON.PARENT.FT.REF>
        Y.PARENT.REF   =Y.PARENT.FT.REF
        CALL F.READ(FN.FUNDS.TRANSFER,Y.PARENT.FT.REF,R.FUNDS.TRANSFER.SETTLE,F.FUNDS.TRANSFER,FT.ERR)
        Y.PARENT.TAX.AMT =  R.FUNDS.TRANSFER.SETTLE<FT.LOCAL.REF,Y.L.FT.TAX.AMT.POS>
    END
* Settle Back the Failed Transaction Amount from Internal Account to Customer Account
    R.PARAM<3>  = W.TOT.FT.ERR
    R.PARAM<6>  = FI.CTA.INTERMEDIA
    R.PARAM<7>  = W.TOT.FT.ERR
    R.PARAM<11> = FI.CTA.DESTINO
    R.PARAM<12> = "NOMINASET"
    R.PARAM<13> = RET.TXN.CODE
    R.PARAM<14> = 'REVERSADO-':Y.PARENT.REF

    CALL REDO.FI.EXT.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.FT.REF> = OUT.RESP


* Settle Back the Complete Tax Amount from Tax Account to Customer Account

    IF Y.PARENT.TAX.AMT THEN
        R.PARAM<3>  = Y.PARENT.TAX.AMT
        R.PARAM<6>  = Y.PAY.CATEG.ACCOUNT
        R.PARAM<7>  = Y.PARENT.TAX.AMT
        R.PARAM<11> = FI.CTA.DESTINO
        R.PARAM<12> = "NOMINASET"
        R.PARAM<13> = RET.TAX.CODE
        R.PARAM<14> = 'REVERSADO-':Y.PARENT.REF
        CALL REDO.FI.EXT.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.TAX.FT.REF> = OUT.RESP
    END
* Generate the New Transaction so settle the Tax Amount for Successful Transactions

    Y.SUCCESS.TAX.AMT = W.TOT.FT.OK * (Y.PAY.COM.PERCENT/100)
    CALL EB.ROUND.AMOUNT("DOP",Y.SUCCESS.TAX.AMT,"","")
    IF Y.PAY.CATEG.ACCOUNT AND Y.SUCCESS.TAX.AMT GT 0 AND Y.PARENT.TAX.AMT THEN
        R.PARAM<3>  = Y.SUCCESS.TAX.AMT
        R.PARAM<6>  = FI.CTA.DESTINO
        R.PARAM<7>  = Y.SUCCESS.TAX.AMT
        R.PARAM<11> = Y.PAY.CATEG.ACCOUNT
        R.PARAM<12> = "REDO.FILE.TAX.GENERATION"
        R.PARAM<13> = ""
        R.PARAM<14> = 'REVERSADO-':Y.PARENT.REF
        CALL REDO.FI.EXT.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
    END
    IF Y.PARENT.TAX.AMT THEN
        GOSUB NCF.UPDATE.PARA
    END
RETURN
*---------------
NCF.UPDATE.PARA:
*---------------

    IF FI.PAYMENT.REF THEN
*        R.TELLER.SETTLE<TT.TE.LOCAL.REF,Y.L.TT.TAX.AMT.POS> = Y.SUCCESS.TAX.AMT
*        CALL F.WRITE(FN.TELLER,FI.PAYMENT.REF,R.TELLER.SETTLE)
        SEL.CMD = "SELECT ":FN.REDO.NCF.ISSUED:" WITH @ID LIKE ...":FI.PAYMENT.REF
    END ELSE
*        R.FUNDS.TRANSFER.SETTLE<FT.LOCAL.REF,Y.L.FT.TAX.AMT.POS> = Y.SUCCESS.TAX.AMT
*        CALL F.WRITE(FN.FUNDS.TRANSFER,Y.PARENT.FT.REF,R.FUNDS.TRANSFER.SETTLE)
        SEL.CMD = "SELECT ":FN.REDO.NCF.ISSUED:" WITH @ID LIKE ...":Y.PARENT.FT.REF
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR.SEL)
    REC.ID = SEL.LIST<1>

    IF REC.ID ELSE
        RETURN
    END


* Delete the Existing NCF Record

    CALL F.READ(FN.REDO.NCF.ISSUED,REC.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,NCF.ISS.ERR)
    IF R.REDO.NCF.ISSUED THEN
        CALL F.DELETE(FN.REDO.NCF.ISSUED,REC.ID)
    END ELSE
        CALL F.READ(FN.REDO.L.NCF.UNMAPPED,REC.ID,R.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,NCF.UNMAP.ERR)
        CALL F.DELETE(FN.REDO.L.NCF.UNMAPPED,REC.ID)
    END

* Moved to NCF Cancellation Table
    CALL F.READ(FN.REDO.L.NCF.CANCELLED,REC.ID,R.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED,ERR.CANCEL)
    R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.ID> = R.REDO.NCF.ISSUED<ST.IS.TXN.ID>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.TYPE> = R.REDO.NCF.ISSUED<ST.IS.TXN.TYPE>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.DATE> = R.REDO.NCF.ISSUED<ST.IS.DATE>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.CHARGE.AMOUNT> = R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.TAX.AMOUNT> = R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.NCF> = R.REDO.NCF.ISSUED<ST.IS.NCF>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.MODIFIED.NCF> = R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.ACCOUNT> = R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
    R.REDO.L.NCF.CANCELLED<NCF.CAN.CAN.TYPE>= '05'
    CALL F.WRITE(FN.REDO.L.NCF.CANCELLED,REC.ID,R.REDO.L.NCF.CANCELLED)

* Updating NCF status

    CALL F.READ(FN.REDO.L.NCF.STATUS,REC.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,ERR.STATUS)
    IF R.REDO.L.NCF.STATUS THEN
        R.REDO.L.NCF.STATUS<NCF.ST.STATUS>='CANCELLED'
        CALL F.WRITE(FN.REDO.L.NCF.STATUS,REC.ID,R.REDO.L.NCF.STATUS)
    END
RETURN
***************
ORANGE.PROCESS:
***************
    WRECORD.NUMBER    = Y.FI.TMP.TOT + 1
    X.TRANS.REFERENCE = FI.W.REDO.FI.CONTROL.ID:".":WRECORD.NUMBER
    X.THEIR.REFERENCE = FI.W.REDO.FI.CONTROL.ID:".":WRECORD.NUMBER
    X.OUR.REFERENCE   = FI.W.REDO.FI.CONTROL.ID:".":WRECORD.NUMBER
    DATO.OUT = "D":"|":FI.CTA.INTERMEDIA:"|":W.TOT.FT.OK:"|":"DOP|":"-|":X.TRANS.REFERENCE:"|":X.THEIR.REFERENCE:"|":X.OUR.REFERENCE:"|":WRECORD.NUMBER

    R.PARAM<1> = "NULL"
    R.PARAM<2> = "N"
    R.PARAM<3> = W.TOT.FT.OK
    R.PARAM<4> = FI.FILE.ID
    R.PARAM<5> = Y.FI.INTERFACE
    R.PARAM<6> = FI.CTA.INTERMEDIA
    R.PARAM<7> = W.TOT.FT.OK
    R.PARAM<8> = "DOP"
    R.PARAM<9> = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"
    R.PARAM<11> = FI.CTA.DESTINO
    R.PARAM<12> = "ORANGEC"
    R.PARAM<13> = DR.TXN.CODE

    OUT.RESP = ''
    OUT.RESP<1> = ''
    OUT.ERR = ''

    IF W.TOT.FT.OK GT 0 THEN
        CALL REDO.FI.DEBIT.PROCES.ORANGE(R.PARAM, OUT.RESP, OUT.ERR)
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PARENT.FT.REF> = OUT.RESP
        Y.STT.REC = 'PROCESADO'
        IF FIELD(OUT.ERR,'/',1)[1,2] NE 'FT' THEN
            Y.ERR.MSG = OUT.ERR
            Y.STT.REC = "FALLIDO"
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG<1>
        END

    END ELSE
        Y.ERR.MSG = "ALL TRANSACTION FAILED"
        Y.STT.REC = "FALLIDO"
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
        W.TOT.FT.ERR = 0
        W.TOT.FT.ERR += W.TOT.FT.OK
    END

    Y.IN.MSG =  WRECORD.NUMBER:",":"DOP":",03,":Y.STT.REC:",":FI.CTA.DESTINO:",":OUT.ERR<1>:",":W.TOT.FT.OK:",":Y.ERR.MSG

    CALL REDO.FI.PREFORMAT.MSG(Y.FI.INTERFACE,"D",Y.IN.MSG,OUT.MSG,Y.ERR.MSG)

    IF Y.ERR.MSG NE "" THEN
        W.STATUS = "04"
        W.ERROR.MSG = Y.ERR.MSG
    END

    Y.ERR.MSG = ''
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>    = W.REC.FT.OK
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>    = W.TOT.FT.OK
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>   = W.REC.FT.OK + W.REC.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>       = W.TOT.FT.OK + W.TOT.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL>  = W.REC.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL>  = W.TOT.FT.ERR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>       = Y.STT.REC
RETURN
*-----------------
BAL.SET.INTNOMINA:
*-----------------

    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<3>  = W.TOT.FT.ERR
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = Y.FI.INTERFACE
    R.PARAM<6>  = FI.CTA.INTERMEDIA
    R.PARAM<7>  = W.TOT.FT.ERR
    R.PARAM<8>  = "DOP"
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"
    R.PARAM<11> = FI.CTA.DESTINO
    R.PARAM<12> = "NOMINASET"
    R.PARAM<13> = RET.TXN.CODE
    IF W.TOT.FT.ERR GT 0 THEN
        CALL REDO.FI.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.FT.REF> = OUT.RESP
        Y.COMMISSION.AMT = W.TOT.FT.ERR * (Y.PAY.COM.PERCENT/100)
        CALL EB.ROUND.AMOUNT("DOP",Y.COMMISSION.AMT,"","")
        IF Y.PAY.CATEG.ACCOUNT AND Y.COMMISSION.AMT GT 0 THEN
            R.PARAM<6> = Y.PAY.CATEG.ACCOUNT
            R.PARAM<7> = Y.COMMISSION.AMT
            R.PARAM<13> = RET.TAX.CODE
            CALL REDO.FI.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.TAX.FT.REF> = OUT.RESP

        END
    END
RETURN

*-----------------
BALANCE.SET.BACEN:
*-----------------

    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<3>  = W.TOT.FT.ERR
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = Y.FI.INTERFACE
    R.PARAM<6>  = FI.CTA.INTERMEDIA
    R.PARAM<7>  = W.TOT.FT.ERR
    R.PARAM<8>  = "DOP"
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"
    R.PARAM<11> = FI.CTA.DESTINO
    R.PARAM<12> = "BACENSET"
    R.PARAM<13> = RET.TXN.CODE
    IF W.TOT.FT.ERR GT 0 THEN

        CALL REDO.FI.DEBIT.PROCES.BACEN(R.PARAM, OUT.RESP, OUT.ERR)
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.FT.REF> = OUT.RESP
        Y.COMMISSION.AMT = W.TOT.FT.ERR * (Y.PAY.COM.PERCENT/100)
        CALL EB.ROUND.AMOUNT("DOP",Y.COMMISSION.AMT,"","")
        IF Y.PAY.CATEG.ACCOUNT AND Y.COMMISSION.AMT GT 0 THEN
            R.PARAM<6> = Y.PAY.CATEG.ACCOUNT
            R.PARAM<7> = Y.COMMISSION.AMT
            R.PARAM<13> = RET.TAX.CODE
            CALL REDO.FI.DEBIT.PROCES.BACEN(R.PARAM, OUT.RESP, OUT.ERR)
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.RET.TAX.FT.REF> = OUT.RESP
        END
    END
RETURN
END
