SUBROUTINE REDO.TT.DATE.TIME.FMT(Y.FIELD.NAME)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT
*coment

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 14-10-2016   Vignesh Kumaar R     PACS00465448   CUSTOMER NAME Truncate and display only 35 characters
* 12-11-2022   APAP                 MDP-2943       CONFIGURACION DE NUMERO DE CAJERO Y SUCURSAL EN LOS COMPROBANTES DE TRANSACCIONES EN T24
*                                                  Se modifico el campo Y.CO.CODE removiendole los espacios en blanco a
*                                                  izquierdad asi también y la palabra "APAP"
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CURRENCY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT I_System

    GOSUB INITIALISE
    GOSUB MAIN.PROCESS
RETURN



*----------------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    BEGIN CASE

* Fix for PACS00465448 [CUSTOMER NAME Truncate and display only 35 characters]

        CASE Y.FIELD.NAME EQ 'Y.CUS.CARD'
            GET.CREDIT.CUS.NAME = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS>
            Y.FIELD.NAME = GET.CREDIT.CUS.NAME[1,35]
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"35R")
            RETURN

* End of Fix

        CASE Y.FIELD.NAME EQ 'Y.DATE.TIME'
            GET.DATE.TIME = R.NEW(TT.TE.DATE.TIME)
            GOSUB GET.DATE.TIME.INFO
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CO.CODE'

*GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":R.NEW(TT.TE.TELLER.ID.1)
*Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")
            GET.CO.CODE = R.COMPANY(EB.COM.COMPANY.NAME):"-":R.NEW(TT.TE.TELLER.ID.1)
            Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.ACCT.TITLE.1'
            GET.ACCT.TITLE = R.NEW(TT.TE.ACCOUNT.1)
            GOSUB GET.ACCT.DETAILS
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.ACCT.TITLE.2'
            GET.ACCT.TITLE = R.NEW(TT.TE.ACCOUNT.2)
            GOSUB GET.ACCT.DETAILS
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CUS.NAME.2'
            GET.ACCT.NO = R.NEW(TT.TE.ACCOUNT.2)
            GOSUB B78.GET.CUS.NAME
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CUS.NAME.1'
            GET.ACCT.NO = R.NEW(TT.TE.ACCOUNT.1)
            GOSUB B78.GET.CUS.NAME
            RETURN

    END CASE

    GOSUB MAIN.NEXT

RETURN

*--------*
MAIN.NEXT:
*--------*

    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'Y.CCY'
            Y.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
            CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR)
            IF  Y.CURRENCY EQ 'DOP' THEN
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
                Y.CURRENCY="RD$(":Y.CURRENCY:")"
            END ELSE
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
            END
            Y.FIELD.NAME=FMT(Y.CURRENCY,"22R")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CHK.AMT'
            Y.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
            IF Y.CURRENCY EQ LCCY THEN
                Y.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
            END ELSE
                Y.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)
            END
            Y.FIELD.NAME = FMT(Y.AMOUNT,"18R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'AMT.FCY'
            CALL REDO.DS.AMOUNT.FCY(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"18R,2")
            RETURN
        CASE Y.FIELD.NAME EQ 'Y.CONCEPT'

            Y.TELL.TRANS = R.NEW(TT.TE.TRANSACTION.CODE)
            FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
            F.TELLER.TRANSACTION = ''
            CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

            CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TELL.TRANS, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ERR)
            Y.TELLER.TRANS.CODE = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>

            FN.TRANSACTION = 'F.TRANSACTION'
            F.TRANSACTION = ''
            CALL OPF(FN.TRANSACTION,F.TRANSACTION)

            CALL CACHE.READ(FN.TRANSACTION, Y.TELLER.TRANS.CODE, R.TRANSACTION, TRANSACTION.ERR)
            Y.GET.DESCRIPTION = R.TRANSACTION<AC.TRA.NARRATIVE,2>
            Y.FIELD.NAME = FMT(Y.GET.DESCRIPTION,"35R")
            RETURN

    END CASE

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'L.TT.LEGAL.ID'
            IF TT.LEGAL.ID THEN
                Y.FIELD.NAME = TT.LEGAL.ID<2>
            END ELSE
                Y.FIELD.NAME = ''
            END
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"27R")
            RETURN

        CASE Y.FIELD.NAME EQ 'AMT.LCY'
            CALL REDO.DS.AMOUNT.FCY(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"18R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'CLIENT.TYPE'
            CALL REDO.DS.CLIENT.TYPE(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"27R")
            RETURN

        CASE Y.FIELD.NAME EQ 'SEL.DST'
            CALL REDO.DS.SEL.DST(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"18R")
            RETURN

        CASE Y.FIELD.NAME EQ 'CUSTOMER.NO'
            CALL REDO.S.GET.CUS.NUMBER(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"12R")
            RETURN

        CASE Y.FIELD.NAME EQ 'RCEP.MTHD'
            CALL REDO.DS.RCEP.MTHD(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"18R")
            RETURN

        CASE Y.FIELD.NAME EQ 'PAY.METHOD'
            CALL REDO.DS.PAY.METHOD(Y.FIELD.NAME)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"20R")
            RETURN

    END CASE
    GOSUB SECOND.PROCESS
RETURN

*----------------------------------------------------------------------------------------------------------------------
SECOND.PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'Y.TAX.COMM.UNO'
            GOSUB GET.TAX.COMM.DETAIL.UNO
            Y.FIELD.NAME = FMT(Y.TOTAL.UNO<1,1>,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.TAX.COMM'
            GOSUB GET.TAX.COMM.DETAIL
            Y.FIELD.NAME = FMT(Y.TAX.AMT,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.NCF.NO'
            IF L.NCF.NUMBER.TAX THEN
                Y.SPACE = '             '
                Y.FIELD.NAME = L.NCF.NUMBER.TAX:@FM:Y.SPACE:L.NCF.NUMBER
            END ELSE
                Y.FIELD.NAME = L.NCF.NUMBER
            END
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.TAX.COMM.DOS.1'
            GOSUB GET.TAX.COMM.DETAIL.DOS.COMM
            Y.FIELD.NAME = FMT(Y.TAX.COM.TOT<1,1>,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.TAX.COMM.DOS.2'
            GOSUB GET.TAX.COMM.DETAIL.DOS.COMM
            Y.FIELD.NAME = FMT(Y.TAX.COM.TOT<1,2>,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.GET.COMMISSION'
            GET.COMM.AMT = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.FIELD.NAME = FIELD(GET.COMM.AMT,@SM,1)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.GET.TAX'
            GET.COMM.AMT = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.FIELD.NAME = FIELD(GET.COMM.AMT,@SM,2)
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"10R,2")
            RETURN

    END CASE
    GOSUB SECOND.NEXT
RETURN

*----------*
SECOND.NEXT:
*----------*

    BEGIN CASE
        CASE Y.FIELD.NAME EQ 'Y.NCF.TOT'
            GET.COMM.AMT = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.COMM = FIELD(GET.COMM.AMT,@SM,1)
            Y.TAX = FIELD(GET.COMM.AMT,@SM,2)
            Y.FIELD.NAME = Y.COMM + Y.TAX
            Y.FIELD.NAME = FMT(Y.FIELD.NAME,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'L.TT.TAX.AMT'
            GOSUB GET.TAX.AMT.DETAIL
            Y.FIELD.NAME = FMT(Y.TAX.COM1,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'L.TT.COMM.AMT'
            GOSUB GET.COMM.DETAIL
            Y.FIELD.NAME = FMT(Y.TAX.COMM88,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'L.TT.COMM.AMT1'
            GOSUB GET.COMM.DETAIL1
            Y.FIELD.NAME = FMT(Y.TAX.COMM98,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'L.NCF.TAX.NUM'
            Y.FIELD.NAME = FMT(L.NCF.NUMBER,"19R")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.TAX.COMMBOTH'
            GOSUB GET.TAX.COMM.DETAIL.BOTH
            Y.FIELD.NAME = FMT(Y.TOTAL.COMM,"10R,2")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.TT.LEGAL.ID'
            Y.CUSTOMER.IDENTITY = TT.LEGAL.ID<1>:" ":TT.LEGAL.ID<2>
            Y.CUSTOMER.IDENTITY=Y.CUSTOMER.IDENTITY[1,18]
            Y.FIELD.NAME = FMT(Y.CUSTOMER.IDENTITY,'R#18')
            RETURN

        CASE Y.FIELD.NAME EQ 'NAME'
            CUSTOMER.NAME = TT.LEGAL.ID<3>
            Y.FIELD.NAME = FMT(CUSTOMER.NAME,'R#35')
            RETURN

    END CASE
    GOSUB THIRD.PROCESS
RETURN
*-------------------------------------------------------------------------
THIRD.PROCESS:
*-------------------------------------------------------------------------

    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'Y.CUSTOMER.NO'
            CUS.IDENTITY.TYPE = TT.LEGAL.ID<1>
            CUSTOMER.IDE = TT.LEGAL.ID<2>
            GOSUB TYPE.PROOF.CHECK.TT
            Y.FIELD.NAME = FMT(CUSTOMER.NO,'R#14')
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CCY2'
            Y.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
            CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR)
            IF  Y.CURRENCY EQ 'DOP' THEN
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
                Y.CURRENCY="RD$(":Y.CURRENCY:")"
            END ELSE
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
            END
            Y.FIELD.NAME=FMT(Y.CURRENCY,"22R")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CCY3'
            Y.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
            CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR)
            IF  Y.CURRENCY EQ 'DOP' THEN
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
                Y.CURRENCY="RD$(":Y.CURRENCY:")"
            END ELSE
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
            END
            Y.FIELD.NAME=FMT(Y.CURRENCY,"35R")
            RETURN

        CASE Y.FIELD.NAME EQ 'Y.DEAL.RATE'
            Y.DEAL.RATE = R.NEW(TT.TE.DEAL.RATE)
            IF INDEX(Y.DEAL.RATE,".",1) THEN
                Y.FIELD.NAME = FMT(Y.DEAL.RATE,'R#7')
            END ELSE
                Y.FIELD.NAME = FMT(Y.DEAL.RATE,'R7,2')          ;* Fix for PACS00395700 [TT/FT RATES NEED TO SHOW DECIMALS]
            END
            RETURN

    END CASE

RETURN
*-------------------------------------------------------------------------
GET.TAX.COMM.DETAIL.BOTH:
*-------------------------------------------------------------------------

    Y.WVB = 1
    Y.TOTAL.COMM = 0
    Y.PLUS.COMM=0
    Y.WV.COUNTING = DCOUNT(Y.WV.COMM,@VM)
    LOOP
    WHILE Y.WVB LE Y.WV.COUNTING

        IF  Y.WV.COMM<1,Y.WVB> EQ 'NO' THEN
            Y.AMT.COMM.VALUE = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.AMT.COMM.VALUE = CHANGE(Y.AMT.COMM.VALUE,@SM,@VM)
            Y.AMT.COMM.VALUE = CHANGE(Y.AMT.COMM.VALUE,@FM,@VM)
            Y.PLUS.COMM= Y.AMT.COMM.VALUE<1,Y.WVB>
            Y.TOTAL.COMM += Y.PLUS.COMM
        END

        Y.WVB += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.COMM.DETAIL:
*----------------------------------------------------------------------------------------------------------------------

    Y.WV.COMM88 = ''
    Y.WV88=1
    Y.WV.COUNT6 = 0

    Y.WV.COMM88 = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.COMM>
    Y.WV.COMM88 = CHANGE(Y.WV.COMM88,@SM,@VM)
    Y.WV.COMM88 = CHANGE(Y.WV.COMM88,@FM,@VM)
    Y.WV.COUNT6 = DCOUNT(Y.WV.COMM88,@VM)

    LOOP
    WHILE Y.WV88 LE Y.WV.COUNT6

        IF  Y.WV.COMM88 EQ 'NO' THEN
            Y.TAX.COMM88 = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.TAX.COMM88=CHANGE(Y.TAX.COMM88,@SM,@VM)
            Y.TAX.COMM88=CHANGE(Y.TAX.COMM88,@FM,@VM)
            Y.TAX.COMM88=Y.TAX.COMM88<1,Y.WV88>
        END

        Y.WV88 += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.COMM.DETAIL1:
*----------------------------------------------------------------------------------------------------------------------

    Y.WV.COMM98 = ''
    Y.WV98=1
    Y.WV.COUNT7 = 0

    Y.WV.COMM98 = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.COMM>
    Y.WV.COMM98 = CHANGE(Y.WV.COMM98,@SM,@VM)
    Y.WV.COMM98 = CHANGE(Y.WV.COMM98,@FM,@VM)
    Y.WV.COUNT7 = DCOUNT(Y.WV.COMM98,@VM)

    LOOP
    WHILE Y.WV98 LE Y.WV.COUNT7

        IF  Y.WV.COMM98 EQ 'NO' THEN
            Y.TAX.COMM98 = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.TAX.COMM98=CHANGE(Y.TAX.COMM98,@SM,@VM)
            Y.TAX.COMM98=CHANGE(Y.TAX.COMM98,@FM,@VM)
            Y.TAX.COMM98=Y.TAX.COMM98<1,Y.WV98>
        END

        Y.WV98 += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.TAX.COMM.DETAIL:
*----------------------------------------------------------------------------------------------------------------------

    Y.TT.TAX.AMT = 0

    IF Y.WV.TAX EQ 'NO' THEN
        Y.TAX.AMT = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.TAX.AMT.DETAIL:
*----------------------------------------------------------------------------------------------------------------------

    Y.WVT1 = 1
    Y.TOTAL = ''
    Y.WVT.COUNT1 = DCOUNT(Y.WV.TAX,@VM)

    LOOP
    WHILE Y.WVT1 LE Y.WVT.COUNT1
        IF Y.WV.TAX EQ 'NO' THEN
            Y.TAX.COM1 = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
            Y.TAX.COM1=CHANGE(Y.TAX.COM1,@SM,@VM)
            Y.TAX.COM1=CHANGE(Y.TAX.COM1,@FM,@VM)
            Y.TAX.COM1=Y.TAX.COM1<1,Y.WVT1>
        END
        Y.WVT1 += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.TAX.COMM.DETAIL.UNO:
*----------------------------------------------------------------------------------------------------------------------

    Y.VAR8 = 1
    Y.TOTAL.UNO = ''

    IF Y.WV.TAX EQ 'NO'  THEN
        Y.TOTAL.UNO<-1> = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
    END

    IF Y.WV.COMM EQ 'NO'  THEN
        Y.TOTAL.UNO<-1> = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
    END

    Y.TOTAL.UNO=CHANGE(Y.TOTAL.UNO,@FM,@VM)

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.TAX.COMM.DETAIL.DOS.COMM:
*----------------------------------------------------------------------------------------------------------------------

    Y.WV = 1
    Y.TOTAL.UNO = ''
    Y.TAX.COM.TOT=''

    Y.WV.COMM =R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.COMM>
    Y.WV.COMM=CHANGE(Y.WV.COMM,@SM,@VM)
    Y.WV.COUNT = DCOUNT(Y.WV.COMM,@VM)

    LOOP
    WHILE Y.WV LE Y.WV.COUNT
        IF Y.WV.COMM<1,Y.WV> EQ 'NO'  THEN
            Y.TAX.COM = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.COMM.AMT.POS>
            Y.TAX.COM=CHANGE(Y.TAX.COM,@SM,@VM)
            Y.TAX.COM.TOT<1,Y.WV>=Y.TAX.COM<1,Y.WV>
        END
        Y.TAX.COM.TOT=CHANGE(Y.TAX.COM.TOT,@FM,@VM)
        Y.WV += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.DATE.TIME.INFO:
*----------------------------------------------------------------------------------------------------------------------

    F1 = GET.DATE.TIME[1,2]
    F2 = GET.DATE.TIME[3,2]
    F3 = GET.DATE.TIME[5,2]
    F4 = GET.DATE.TIME[7,2]
    F5 = GET.DATE.TIME[9,2]

    Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
    Y.FIELD.NAME = FMT(Y.TIME,"15R")

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.ACCT.DETAILS:
*----------------------------------------------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.ACCT.TITLE = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    Y.FIELD.NAME = FMT(Y.ACCT.TITLE,"36R")

RETURN

*----------------------------------------------------------------------------------------------------------------------
B78.GET.CUS.NAME:
*----------------------------------------------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.ST.LAPAP.OCC.CUSTOMER = 'F.ST.LAPAP.OCC.CUSTOMER'
    F.ST.LAPAP.OCC.CUSTOMER = ''
    CALL OPF(FN.ST.LAPAP.OCC.CUSTOMER,F.ST.LAPAP.OCC.CUSTOMER)

    CALL F.READ(FN.ACCOUNT,GET.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

    IF NOT (R.CUSTOMER) THEN
        CALL F.READ(ST.LAPAP.OCC.CUSTOMER,Y.CUSTOMER.IDENTITY,R.CUST,F.Y.CUSTOMER.IDENTITY,CUST.ERR)
        Y.NAME1 = R.CUST<ST.L.OCC.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END

    GOSUB JOINT.HOLDER.CHECK
    Y.NAME = Y.NAME1
    IF Y.REL.DESC THEN
        Y.NAME = Y.NAME:' ':Y.REL.DESC
    END

    IF Y.NAME2 THEN
        Y.NAME = Y.NAME:' ':Y.NAME2
    END
    Y.NAME = Y.NAME[1,36]
    Y.FIELD.NAME = FMT(Y.NAME,"36R")
RETURN

*----------------------------------------------------------------------------------------------------------------------
JOINT.HOLDER.CHECK:
*----------------------------------------------------------------------------------------------------------------------

    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 529 THEN
        CALL F.READ(FN.RELATION,Y.RELATION.CODE,R.RELATION,F.RELATION,REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>
        CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        Y.NAME = R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS>
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "CLIENTE MENOR" THEN
            Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END ELSE
            IF R.CUSTOMER<EB.CUS.LOCAL.REF,GET.REF.POS> EQ "PERSONA JURIDICA" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END
        END
    END

RETURN

*----------------------------------------------------------------------------------
TYPE.PROOF.CHECK.TT:
*----------------------------------------------------------------------------------
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    WWVAR = "CURRENT.VAR.DETAILS" ; YPOS.VAR = ""
    LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
        WCVD = System.getVariable("CURRENT.VAR.DETAILS")
        WCUS.NUM = FIELD(WCVD,"*",4)
    END
*
    IF NOT(WCUS.NUM) THEN
        WWVAR = "CURRENT.CLIENTE.APAP" ; YPOS.VAR = ""
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WCCA = System.getVariable("CURRENT.CLIENTE.APAP")
            WCUS.NUM = WCCA
        END
    END
*
    IF NOT(WCUS.NUM) THEN
        GOSUB TP.APP.TT
        WCUS.NUM = CUSTOMER.NO
    END
*
    CUSTOMER.NO = WCUS.NUM
*
RETURN
*
*---------
TP.APP.TT:
*---------
*
    CUSTOMER.NO = ''
    BEGIN CASE
        CASE CUS.IDENTITY.TYPE EQ "CEDULA"
            R.CUS.CIDENT = ''
            CALL F.READ(FN.CUS.L.CU.CIDENT,CUSTOMER.IDE,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)
            CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)
*
        CASE CUS.IDENTITY.TYPE EQ "RNC"
            R.CUS.RNC = ''
            CALL F.READ(FN.CUS.L.CU.RNC,CUSTOMER.IDE,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
            CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)
*
        CASE CUS.IDENTITY.TYPE EQ "PASAPORTE"
            R.CUS.LEGAL = ''
            CALL F.READ(FN.CUS.LEGAL.ID,CUSTOMER.IDE,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
            CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)
*
    END CASE
*
RETURN

*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    Y.APPL = 'CUSTOMER':@FM:'TELLER'
    Y.FIELD = 'L.CU.TIPO.CL':@FM:'L.TT.TAX.AMT':@VM:'L.TT.COMM.AMT':@VM:'L.TT.WV.COMM':@VM:'L.TT.WV.TAX':@VM:'L.NCF.TAX.NUM':@VM:"L.TT.LEGAL.ID":@VM:'L.NCF.NUMBER':@VM:'L.TT.CLIENT.NME'

    Y.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELD,Y.FLD.POS)
    GET.REF.POS = Y.FLD.POS<1,1>
    L.TT.TAX.AMT.POS = Y.FLD.POS<2,1>
    L.TT.COMM.AMT.POS = Y.FLD.POS<2,2>
    L.TT.WV.COMM = Y.FLD.POS<2,3>
    L.TT.WV.TAX  = Y.FLD.POS<2,4>
    L.NCF.TAX.NUM.POS = Y.FLD.POS<2,5>
    L.TT.LEGAL.ID.POS = Y.FLD.POS<2,6>
    L.NCF.NUMBER.POS = Y.FLD.POS<2,7>
    L.TT.CLIENT.NME.POS = Y.FLD.POS<2,8>

    L.NCF.NUMBER =  R.NEW(TT.TE.LOCAL.REF)<1,L.NCF.TAX.NUM.POS>
    L.NCF.NUMBER.TAX = R.NEW(TT.TE.LOCAL.REF)<1,L.NCF.NUMBER.POS>

    Y.WV.TAX =  R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.TAX>
    Y.WV.COMM = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.COMM>
    Y.WV.COMM = CHANGE(Y.WV.COMM,@SM,@VM)
    Y.WV.COMM = CHANGE(Y.WV.COMM,@FM,@VM)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    TT.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS>
    CHANGE '.' TO @FM IN TT.LEGAL.ID

    FN.CUS.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.L.CU.RNC  = ''
    CALL OPF(FN.CUS.L.CU.RNC,F.CUS.L.CU.RNC)
*
    FN.CUS.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.L.CU.CIDENT  = ''
    CALL OPF(FN.CUS.L.CU.CIDENT,F.CUS.L.CU.CIDENT)
*
    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID  = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
