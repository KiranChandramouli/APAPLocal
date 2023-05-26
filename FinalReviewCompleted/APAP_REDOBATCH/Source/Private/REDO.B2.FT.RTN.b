* @ValidationCode : MjoyMjY0ODExMjM6Q3AxMjUyOjE2ODQ4NTQ0MDM0NDU6SVRTUzotMTotMTozNTE5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 3519
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B2.FT.RTN(ENQ.DATA)
*
* Subroutine Type : ENQUIRY NOFILE
* Attached to     : SS NOFILE.REDO.B2.FT - ENQ REDO.B2.FT
* Attached as     : ENQUIRY NOFILE
* Primary Purpose : To get data for paymenents to insurance companies
*
* Incoming:
* ---------
* N/A
*
* Outgoing:
* ---------
*
*
* Error Variables:
* N/A
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Santiago Jijon - TAM Latin America
* Date            : Jul, 18 - 2012
* Modify by       :
* Modify date     :
* Notes           :
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND VAR1- TO -= AND VAR1+ TO += AND I TO I.VAR AND X TO X.VAR
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.PAYMENT.RULES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.CUSTOMER
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.OVERDUE

    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.B2.FT.PARAMETERS
    $INSERT I_F.REDO.B2.RECORD.INS.PAY

***<region name = MAIN.LOGIC>
*---------------------------------------------------------------------------------------------------------
MAIN.LOGIC:

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
***</region>

***<region name = INITIALISE>
*---------------------------------------------------------------------------------------------------------
INITIALISE:

    Y.TOTGEN = 0
    Y.TYPE.ENQ = 'NORMAL'

    FN.PARAM = 'F.REDO.B2.FT.PARAMETERS'
    F.PARAM = ''
    R.PARAM = ''
    CALL OPF (FN.PARAM, F.PARAM)

    FN.BILL = 'F.AA.BILL.DETAILS'
    F.BILL = ''
    R.BILL = ''
    CALL OPF (FN.BILL, F.BILL)

    FN.AC.DET = 'F.AA.ACCOUNT.DETAILS'
    F.AC.DET = ''
    R.AC.DET = ''
    CALL OPF (FN.AC.DET, F.AC.DET)

    FN.INSURANCE = 'F.APAP.H.INSURANCE.DETAILS'
    F.INSURANCE = ''
    R.INSURANCE = ''
    CALL OPF (FN.INSURANCE, F.INSURANCE)

    FN.REDO.ACCT.MRKWOF.HIST = 'F.REDO.ACCT.MRKWOF.HIST'
    F.REDO.ACCT.MRKWOF.HIST = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.POLICY = 'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY = ''
    R.POLICY = ''
    CALL OPF (FN.POLICY, F.POLICY)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''
    CALL OPF (FN.CUSTOMER, F.CUSTOMER)

    FN.PAYRULE = 'F.AA.PRD.DES.PAYMENT.RULES'
    F.PAYRULE = ''
    R.PAYRULE = ''
    CALL OPF (FN.PAYRULE, F.PAYRULE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    CALL OPF (FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE = ''
    CALL OPF (FN.AC.BALANCE.TYPE,F.AC.BALANCE.TYPE)

    LOC.REF.POS = 0
    LOC.REF.APPL = "CUSTOMER":@FM:"AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS = "L.CU.TIPO.CL":@FM:'L.LOAN.COND':@VM:'L.LOAN.STATUS.1'
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.TIPOCLI.POS  = LOC.REF.POS<1,1>
    Y.LN.CD = LOC.REF.POS<2,1>
    Y.LN.S = LOC.REF.POS<2,2>

    FN.REDO.LAST.INS.PAY.GRP = 'F.REDO.LAST.INS.PAY.GRP'
    F.REDO.LAST.INS.PAY.GRP = ''
    CALL OPF(FN.REDO.LAST.INS.PAY.GRP,F.REDO.LAST.INS.PAY.GRP)

    FN.REDO.B2.RECORD.INS.PAY = 'F.REDO.B2.RECORD.INS.PAY'
    F.REDO.B2.RECORD.INS.PAY = ''
    CALL OPF(FN.REDO.B2.RECORD.INS.PAY,F.REDO.B2.RECORD.INS.PAY)

RETURN
***</region>

***<region name = PROCESS>
*---------------------------------------------------------------------------------------------------------
PROCESS:

    LOCATE  "INS.POLICY.TYPE"  IN  D.FIELDS  SETTING POLICY.POS ELSE
        POLICY.POS = ''
    END
    LOCATE  "INS.COMPANY"  IN  D.FIELDS  SETTING COMPANY.POS ELSE
        COMPANY.POS     = ''
    END
    LOCATE  "INS.FECHA"   IN  D.FIELDS  SETTING FECHA.POS ELSE
        FECHA.POS      = ''
    END
    LOCATE  "CLASS.POLICY"  IN  D.FIELDS  SETTING CLASS.POS ELSE
        CLASS.POS = ''
    END

    Y.POLIZA = ENQ.SELECTION<4,POLICY.POS>
    Y.COMPAN = ENQ.SELECTION<4,COMPANY.POS>
    Y.FECHA  = ENQ.SELECTION<4,FECHA.POS>
    Y.CLASS  = ENQ.SELECTION<4,CLASS.POS>

    Y.ID = Y.POLIZA:'*':Y.CLASS:'*':Y.COMPAN

    CALL F.READ(FN.REDO.B2.RECORD.INS.PAY,Y.ID,R.REDO.B2.RECORD.INS.PAY,F.REDO.B2.RECORD.INS.PAY,GRP.ER)
    GOSUB CHECK.DATES

    Y.FEC = Y.FECHA[5,2]
    IF Y.FEC EQ '01' THEN
        Y.FECHA.FRM = Y.FECHA[1,4]-1:'12':'01'
        Y.FECHA.TO = Y.FECHA[1,4]-1:'12':'31'
    END ELSE
        Y.FECHA.FRM = Y.FECHA[1,4]:FMT(Y.FECHA[5,2]-1,'R%2'):'01'
        COMI = Y.FECHA.FRM
        CALL LAST.DAY.OF.THIS.MONTH
        Y.FECHA.TO = COMI
    END


    CALL F.READ(FN.PARAM,Y.POLIZA,R.PARAM,F.PARAM,Y.ERR)
    Y.CORTE = R.PARAM<PAY.PAR.FECHA.CORTE>
    Y.PAYRULE = R.PARAM<PAY.PAR.ID.DESEMBOLSOS>

    CALL F.READ(FN.POLICY,Y.POLIZA,R.POLICY,F.POLICY,YERR)
    LOCATE 'CHARGE-1' IN R.POLICY<INS.POL.TYP.FIELD.NAME,1> SETTING X.VAR THEN
        Y.CHARGE = R.POLICY<INS.POL.TYP.FIELD.VALUES,X.VAR>
    END

    IF Y.POLIZA EQ 'FHA' THEN
        Y.TYPE.ENQ = 'FHA'
    END


    SEL.CMD = 'SELECT ' : FN.INSURANCE : ' WITH INS.POLICY.TYPE EQ ': Y.POLIZA : ' AND INS.COMPANY EQ ' : Y.COMPAN : ' AND CLASS.POLICY EQ ': Y.CLASS :' BY-DSND DATE.TIME'
    CALL EB.READLIST(SEL.CMD,Y.LIST1,'',NO.OF.REG,RET.CODE)

    IF Y.TYPE.ENQ NE 'FHA' THEN
        CALL F.READ(FN.INSURANCE,Y.LIST1<1>,R.INSURANCE,F.INSURANCE,Y.ERR)
        BEGIN CASE
            CASE R.INSURANCE<INS.DET.PAYMENT.TYPE> EQ ''
                Y.TYPE.ENQ = 'DESEMBOLSO'
                GOSUB DESEM.PROCESS

            CASE R.INSURANCE<INS.DET.PAYMENT.TYPE> EQ 'INSURANCE'
                Y.TYPE.ENQ = 'NORMAL'
                GOSUB NORMAL.PROCESS

        END CASE
    END ELSE
        Y.COMP.VALS = R.PARAM<PAY.PAR.INS.COMPANY> ; Y.CLAS.VAL = CHANGE(Y.COMP.VALS,@SM,@VM)
        LOCATE Y.CLASS IN R.PARAM<PAY.PAR.CLASS.POLICY,1> SETTING POS.CL THEN
            LOCATE Y.COMPAN IN R.PARAM<PAY.PAR.INS.COMPANY,POS.CL,1> SETTING POS.CM THEN
                Y.FHA.PERC = R.PARAM<PAY.PAR.FHA.PERCENTAGE,POS.CL,POS.CM>
            END
        END
        GOSUB FHA.PROCESS
    END

RETURN

CHECK.DATES:

    Y.NM.DATE = R.REDO.B2.RECORD.INS.PAY<REC.INS.DATES>
    Y.D.CNT = DCOUNT(Y.NM.DATE,@VM) ; FLG.H = ''
    LOOP
    WHILE Y.D.CNT GT 0 DO
        FLG.H += 1
        Y.DATE.Q = Y.NM.DATE<1,FLG.H>
        IF Y.FECHA[1,6] EQ Y.DATE.Q[1,6] THEN
            ENQ.ERROR = 'EB-PAYMENT.DONE.INS'
            Y.D.CNT = 0
            GOSUB PGM.END
        END
        Y.D.CNT -= 1
    REPEAT

RETURN

NORMAL.PROCESS:

    LOOP
        REMOVE Y.INSURANCE FROM Y.LIST1 SETTING POS1
    WHILE Y.INSURANCE:POS1

        CALL F.READ(FN.INSURANCE,Y.INSURANCE,R.INSURANCE,F.INSURANCE,Y.ERR)
        Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRAN,F.AA.ARRANGEMENT,AA.ARR.ER)
        IF R.AA.ARRAN THEN
            IF R.AA.ARRAN<AA.ARR.ARR.STATUS> EQ 'CURRENT' THEN
                CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,Y.AA.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)
                IF R.REDO.ACCT.MRKWOF.HIST EQ '' THEN
                    Y.CHR.TYPE = R.INSURANCE<INS.DET.CHARGE>
                    Y.CUSTOMER = R.INSURANCE<INS.DET.CUSTOMER>
                    GOSUB GET.CUSTOMER
                    GOSUB GET.BILL.DETAILS
                END
            END
        END
    REPEAT

    GOSUB GET.CURRENT.VALUES

RETURN

GET.CURRENT.VALUES:


    CALL System.setVariable("CURRENT.VALUE",Y.TOTGEN)
    CALL System.setVariable("CURRENT.POLIZA",Y.POLIZA)
    CALL System.setVariable("CURRENT.COMPAN",Y.COMPAN)
    CALL System.setVariable("CURRENT.NEWCLOSDATE",Y.FECHA)
    CALL System.setVariable("CURRENT.CHARGE",Y.CHARGE)
    CALL System.setVariable("CURRENT.TYPE.ENQ",Y.TYPE.ENQ)
    CALL System.setVariable("CURRENT.CLS.POL",Y.CLASS)

RETURN

DESEM.PROCESS:


    LOOP
        REMOVE Y.INSURANCE FROM Y.LIST1 SETTING POS1
    WHILE Y.INSURANCE:POS1
        CALL F.READ(FN.INSURANCE,Y.INSURANCE,R.INSURANCE,F.INSURANCE,Y.ERR)
        Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>

        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRAN,F.AA.ARRANGEMENT,AA.ARR.ER)
        IF R.AA.ARRAN THEN
            IF R.AA.ARRAN<AA.ARR.ARR.STATUS> EQ 'CURRENT' THEN
                CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,Y.AA.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)
                IF R.REDO.ACCT.MRKWOF.HIST EQ '' THEN
                    Y.CHR.TYPE = R.INSURANCE<INS.DET.CHARGE>
                    Y.CUSTOMER = R.INSURANCE<INS.DET.CUSTOMER>
                    GOSUB GET.CUSTOMER
                    GOSUB GET.BILL.DET.DIS
                END
            END
        END
    REPEAT

    GOSUB GET.CURRENT.VALUES

RETURN

FHA.PROCESS:

    LOOP
        REMOVE Y.INSURANCE FROM Y.LIST1 SETTING POS1
    WHILE Y.INSURANCE:POS1
        CALL F.READ(FN.INSURANCE,Y.INSURANCE,R.INSURANCE,F.INSURANCE,Y.ERR)
        Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>
        Y.CUSTOMER = R.INSURANCE<INS.DET.CUSTOMER>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRAN,F.AA.ARRANGEMENT,AA.ARR.ER)
        IF R.AA.ARRAN THEN
            IF R.AA.ARRAN<AA.ARR.ARR.STATUS> EQ 'CURRENT' THEN
                CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,Y.AA.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)
                IF R.REDO.ACCT.MRKWOF.HIST EQ '' THEN
                    GOSUB GET.CUSTOMER
                    GOSUB ENQ.FHA
                END
            END
        END
    REPEAT

    GOSUB GET.CURRENT.VALUES

RETURN

***</region>

***<region name = GET.CUSTOMER>
*---------------------------------------------------------------------------------------------------------
GET.CUSTOMER:
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    Y.TIPOCLI  = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.TIPOCLI.POS>
    IF Y.TIPOCLI EQ 'COMERCIAL'  THEN
        Y.TIPOCLI = 'PERSONA JURIDICA'
    END ELSE
        Y.TIPOCLI = 'PERSONAL'
    END
RETURN
***</region>

***<region name = GET.BILL.DETAILS>
*---------------------------------------------------------------------------------------------------------
GET.BILL.DETAILS:

    R.AC.DET = ''
    YERR = '' ; FLG.1 = ''
    CALL F.READ(FN.AC.DET,Y.AA.ID,R.AC.DET,F.AC.DET,YERR)
    Y.BLS.DATES = R.AC.DET<AA.AD.BILL.PAY.DATE>
    Y.BLS.IDS = R.AC.DET<AA.AD.BILL.ID>

    IF R.AC.DET THEN
        LOCATE Y.FECHA IN Y.BLS.DATES<1,1> BY 'AR' SETTING POS.ART THEN
            GOSUB BIL.FCK.1
        END ELSE
            GOSUB BIL.FCK.2
        END
    END

RETURN

BIL.FCK.1:

    SL.PS = POS.ART -1
    Y.RSP.DATE = Y.BLS.DATES<1,SL.PS>
    IF Y.RSP.DATE GE Y.FECHA.FRM AND Y.RSP.DATE LE Y.FECHA.TO THEN
        Y.RSP.BL.IDS = Y.BLS.IDS<1,SL.PS>
        Y.RSP.BL.IDS = CHANGE(Y.RSP.BL.IDS,@SM,@VM)
        GOSUB PROCESS.BLSS
    END

RETURN

BIL.FCK.2:

    SL.PS = POS.ART -1
    IF Y.BLS.DATES<1,SL.PS>[1,6] EQ Y.FECHA[1,6] THEN
        IF Y.BLS.DATES<1,SL.PS> LT Y.FECHA THEN
            SL.PS -= 1
        END
    END
    IF SL.PS GT 0 THEN
        Y.RSP.DATE = Y.BLS.DATES<1,SL.PS>
        IF Y.RSP.DATE GE Y.FECHA.FRM AND Y.RSP.DATE LE Y.FECHA.TO THEN
            Y.RSP.BL.IDS = Y.BLS.IDS<1,SL.PS>
            Y.RSP.BL.IDS = CHANGE(Y.RSP.BL.IDS,@SM,@VM)
            GOSUB PROCESS.BLSS
        END
    END

RETURN

PROCESS.BLSS:

    Y.NUM.BILLS = DCOUNT(Y.RSP.BL.IDS,@VM) ; I.VAR = ''
    LOOP
    WHILE Y.NUM.BILLS GT 0 DO
        I.VAR += 1
        Y.BILL.ID = Y.RSP.BL.IDS<1,I.VAR>
        R.BILL = ''
        YERR = ''
        CALL F.READ(FN.BILL,Y.BILL.ID,R.BILL,F.BILL,YERR)
        LOCATE Y.CHR.TYPE IN R.BILL<AA.BD.PROPERTY,1> SETTING PRP.PSO THEN
            LOCATE "INSURANCE" IN R.BILL<AA.BD.PAYMENT.TYPE,1> SETTING INSUR.POS THEN
                GOSUB ENQ.NORMAL
            END
        END
        Y.NUM.BILLS -= 1
    REPEAT

RETURN

GET.BILL.DET.DIS:

    R.AC.DET = ''
    YERR = '' ; FLG.1 = ''
    CALL F.READ(FN.AC.DET,Y.AA.ID,R.AC.DET,F.AC.DET,YERR)
    Y.BLS.DATES = R.AC.DET<AA.AD.BILL.PAY.DATE>
    Y.BLS.IDS = R.AC.DET<AA.AD.BILL.ID>

    IF R.AC.DET THEN
        LOCATE Y.FECHA IN Y.BLS.DATES<1,1> BY 'AR' SETTING POS.ART THEN
            GOSUB BIL.DES.FCK.1
        END ELSE
            GOSUB BIL.DES.FCK.2
        END
    END

RETURN

BIL.DES.FCK.1:

    SL.PS = POS.ART -1
    Y.RSP.DATE = Y.BLS.DATES<1,SL.PS>
    IF Y.RSP.DATE GE Y.FECHA.FRM AND Y.RSP.DATE LE Y.FECHA.TO THEN
        Y.RSP.BL.IDS = Y.BLS.IDS<1,SL.PS>
        Y.RSP.BL.IDS = CHANGE(Y.RSP.BL.IDS,@SM,@VM)
        GOSUB PROCESS.BLSS.DIS
    END

RETURN

BIL.DES.FCK.2:


    SL.PS = POS.ART -1
    IF Y.BLS.DATES<1,SL.PS>[1,6] EQ Y.FECHA[1,6] THEN
        IF Y.BLS.DATES<1,SL.PS> LT Y.FECHA THEN
            SL.PS -= 1
        END
    END
    IF SL.PS NE 0 THEN
        Y.RSP.DATE = Y.BLS.DATES<1,SL.PS>
        IF Y.RSP.DATE GE Y.FECHA.FRM AND Y.RSP.DATE LE Y.FECHA.TO THEN
            Y.RSP.BL.IDS = Y.BLS.IDS<1,SL.PS>
            Y.RSP.BL.IDS = CHANGE(Y.RSP.BL.IDS,@SM,@VM)
            GOSUB PROCESS.BLSS.DIS
        END
    END

RETURN

PROCESS.BLSS.DIS:

    Y.NUM.BILLS = DCOUNT(Y.RSP.BL.IDS,@VM) ; I.VAR = ''
    LOOP
    WHILE Y.NUM.BILLS GT 0 DO
        I.VAR += 1
        Y.BILL.ID = Y.RSP.BL.IDS<1,I.VAR>
        R.BILL = ''
        YERR = ''
        CALL F.READ(FN.BILL,Y.BILL.ID,R.BILL,F.BILL,YERR)
        LOCATE Y.CHR.TYPE IN R.BILL<AA.BD.PROPERTY,1> SETTING PRP.PSO THEN
            GOSUB ENQ.DESEMBOLSO
        END
        Y.NUM.BILLS -= 1
    REPEAT

RETURN

***</region>

***<region name = ENQ.NORMAL>
*---------------------------------------------------------------------------------------------------------
ENQ.NORMAL:
    Y.TOTGEN = Y.TOTGEN + R.INSURANCE<INS.DET.MON.TOT.PRE.AMT> + R.INSURANCE<INS.DET.EXTRA.AMT>
    Y.PRIM.AM = R.INSURANCE<INS.DET.MON.POL.AMT> + R.INSURANCE<INS.DET.EXTRA.AMT>
    ENQ.DATA<-1> = Y.AA.ID: '*' : R.INSURANCE<INS.DET.SEN.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.INS.POLICY.TYPE>: '*' :R.INSURANCE<INS.DET.INS.AMOUNT>: '*' :R.INSURANCE<INS.DET.MON.POL.AMT>: '*' :R.INSURANCE<INS.DET.EXTRA.AMT>: '*' :Y.PRIM.AM: '*' :Y.TIPOCLI

RETURN
***</region>

***<region name = ENQ.DESEMBOLSO>
*---------------------------------------------------------------------------------------------------------
ENQ.DESEMBOLSO:
    Y.TOTGEN = Y.TOTGEN + R.INSURANCE<INS.DET.TOTAL.PRE.AMT>
    ENQ.DATA<-1> = Y.AA.ID: '*' : R.INSURANCE<INS.DET.SEN.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.INS.POLICY.TYPE>: '*' :R.INSURANCE<INS.DET.INS.AMOUNT>: '*' :                                : '*':                               : '*' :R.INSURANCE<INS.DET.TOTAL.PRE.AMT>: '*' :Y.TIPOCLI

RETURN
***</region>

***<region name = ENQ.FHA>
*---------------------------------------------------------------------------------------------------------
ENQ.FHA:
    GOSUB GET.AMOUNT
    Y.TOTGEN += Y.FHA.AMT
    ENQ.DATA<-1> = Y.AA.ID: '*' : R.INSURANCE<INS.DET.SEN.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.POLICY.NUMBER>: '*' :R.INSURANCE<INS.DET.INS.POLICY.TYPE>: '*' :P.TOTAL.OUT: '*' :                                 : '*' :                             : '*' : Y.FHA.AMT : '*' : Y.TIPOCLI

RETURN
***</region>

***<region name = GET.AMOUNT>
*---------------------------------------------------------------------------------------------------------
GET.AMOUNT:
    Y.PROCESS.DATE              = TODAY
    Y.OUT.AA.AMOUNT             = 0
    Y.BALANCE.TO.CHECK          = ""
    Y.BAL.DETAILS               = ""
    Y.DATE.OPTIONS              = ''
    Y.DATE.OPTIONS<2>           = ""      ;* Request NAU movements
    Y.DATE.OPTIONS<4>           = "ECB"   ;*Type Of Balance
    Y.PRESENT.VALUE             = ''      ;* THe current balance figure
    Y.BALANCE.TYPE              = ''

    R.AA.ARRANGEMENT = ''
    YERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,YERR)

    Y.ACCOUNT.ID  =  R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
* Get all balance types when the ID conteins ACCOUNT and REPORTING.TYPE equal to NON-CONTINGENT
    Y.SEL.COMAND  = 'SELECT ' : FN.AC.BALANCE.TYPE
    Y.SEL.COMAND := ' WITH @ID LIKE ...ACCOUNT AND @ID UNLIKE UNC... AND @ID UNLIKE UND...'
    Y.SEL.COMAND := ' AND REPORTING.TYPE EQ "NON-CONTINGENT"'

    CALL EB.READLIST(Y.SEL.COMAND,Y.BALANCE.TYPE,'',NO.OF.RECO,Y.ERR3)

    P.TOTAL.OUT = '' ; Y.FHA.AMT = ''
*For each balance type get the value
    LOOP
        REMOVE Y.BALANCE.TYPE.ID FROM Y.BALANCE.TYPE SETTING Y.POS
    WHILE  Y.POS:Y.BALANCE.TYPE.ID
        Y.BALANCE.TO.CHECK = Y.BALANCE.TYPE.ID
*Get the balance value
        CALL AA.GET.PERIOD.BALANCES(Y.ACCOUNT.ID, Y.BALANCE.TO.CHECK, Y.DATE.OPTIONS, Y.PROCESS.DATE, Y.PROCESS.DATE, '', Y.BAL.DETAILS, "")
        P.TOTAL.OUT += ABS(Y.BAL.DETAILS<4>)
    REPEAT

    P.TOTAL.OUT = ABS(P.TOTAL.OUT)

    Y.FHA.AMT = ( P.TOTAL.OUT * Y.FHA.PERC ) / 100

RETURN
***</region>

PGM.END:

END
