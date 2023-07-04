* @ValidationCode : MjotOTg4MDI2MTM5OkNwMTI1MjoxNjg0ODM2MDQ5Njc0OklUU1M6LTE6LTE6MTQyMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1423
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.REJ.DEBT.DETS(Y.FINAL.ARRAY)
********************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Routine   Name    : REDO.APAP.NOF.REJ.DEBT.DETS
*--------------------------------------------------------------------------------------------------------
*Description       : This Nofile enquiry routine is used to retrieve the records from  STANDING.ORDERS and
*                    CUSTOMER applications for generating the Report
*In Parameter      : -NA-
*Out Parameter     : Y.FINAL.ARRAY
*Linked With       : -NA-
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                        Reference                      Description
*   ------         ------                      -------------                   -------------
* 15/11/2010      Raj Kumar A C/Pradeep P    ODR-2010-03-0099                Initial Creation
* 17/06/2011      Riyas Dhivakar(solution)    PACS00072407                    added line 256 create one more CFQ to calculate multiple timer
*                                                                             If more then one display the amount else null
* 28/06/2011      Shankar Raju                PACS00072407- Kick Back        Change for INSTRUCTION column
*                                                                        Removing one MULTI.GET.LOC.REF [for code review issue]
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,SM to @SM, IF STATEMENT ADDED ,++ to +=,F.READ to CACHE.READ
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

********************************************************************************************************


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.USER
    $INSERT I_F.REDO.APAP.H.PAY.TYPE
    $INSERT I_F.BENEFICIARY

    GOSUB INIT
    GOSUB SEL.STMT.FORMATION
RETURN
*
INIT:
*------
    FN.STANDING.ORDER  = 'F.STANDING.ORDER'
    F.STANDING.ORDER   =  ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  =  ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.CUSTOMER        = 'F.CUSTOMER'
    F.CUSTOMER         = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.USER        = 'F.USER'
    F.USER         = ''
    CALL OPF(FN.USER,F.USER)

    FN.FUNDS.TRANSFER  = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER   = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.NAU  = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU   = ''
    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION  = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION, F.FT.TXN.TYPE.CONDITION)

    FN.ACCOUNT         = 'F.ACCOUNT'
    F.ACCOUNT          =  ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.THIRD.PARTY = ''
    Y.PAY.CARD = ''
    Y.PAY.LOAN = ''
    Y.DOMIC.05 = ''
    Y.DOMIC.04 = ''
    Y.DOMIC.OTHERS = ''
    Y.DOMIC.07 = ''
    Y.INSTRUCCION = ''


    FN.REDO.APAP.H.PAY.TYPE = 'F.REDO.APAP.H.PAY.TYPE'
    F.REDO.APAP.H.PAY.TYPE = ''
    CALL OPF(FN.REDO.APAP.H.PAY.TYPE,F.REDO.APAP.H.PAY.TYPE)

    GOSUB GET.LOCAL.REF
RETURN
*-------------
GET.LOCAL.REF:
*-------------
* PACS00072407- Kick Back >>>> S
    LOC.REF.APPL     = "CUSTOMER":@FM:"FT.TXN.TYPE.CONDITION":@FM:"BENEFICIARY"
    LOC.REF.FIELDS   = "L.CU.TIPO.CL":@FM:"L.FTTC.PAY.TYPE":@FM:"L.BEN.ACH.ARCIB"
    LOC.REF.POS      = ""
    Y.POS = ""

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.CLI.TYPE.POS      =  LOC.REF.POS<1,1>
    Y.PAY.TYPE          =  LOC.REF.POS<2,1>
    L.BEN.ACH.ARCIB.POS =  LOC.REF.POS<3,1>

RETURN
* PACS00072407- Kick Back >>>> E
*------------------
SEL.STMT.FORMATION:
*------------------

    SEL.FT.NAU.CMD = "SELECT ":FN.FUNDS.TRANSFER.NAU:" WITH INWARD.PAY.TYPE LIKE STO... AND RECORD.STATUS EQ IHLD"

    LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
        SEL.FT.NAU.CMD := ' AND PROCESSING.DATE EQ ':Y.DATE
    END ELSE
        SEL.FT.NAU.CMD := ' AND PROCESSING.DATE NE " "'
    END

    SEL.FT.NAU.CMD := " BY PROCESSING.DATE"

    CALL EB.READLIST(SEL.FT.NAU.CMD,Y.FT.LIST,'',Y.FT.CNT,Y.FT.SEL.ERR)
    LOOP
        REMOVE Y.FT.ID FROM Y.FT.LIST SETTING Y.FT.POS
    WHILE Y.FT.ID:Y.FT.POS

        CALL F.READ(FN.FUNDS.TRANSFER.NAU,Y.FT.ID,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,Y.FT.ERR.NAU)

        IF R.FUNDS.TRANSFER.NAU THEN
            Y.REA.FOR.REJ = R.FUNDS.TRANSFER.NAU<FT.IN.REASON.OVE>
            IF NOT(Y.REA.FOR.REJ) THEN
                Y.REA.FOR.REJ = R.FUNDS.TRANSFER.NAU<FT.OVERRIDE>
            END
            Y.DATE = R.FUNDS.TRANSFER.NAU<FT.PROCESSING.DATE>
            Y.STO.ID = R.FUNDS.TRANSFER.NAU<FT.INWARD.PAY.TYPE>

            VAL.2 = FIELD(Y.STO.ID,"-",3)
            VAL.3 = FIELD(Y.STO.ID,"-",4)
            Y.STO.ID = VAL.2:".":VAL.3

            CALL F.READ(FN.STANDING.ORDER,Y.STO.ID,R.STANDING.ORDER,F.STANDING.ORDER,Y.ST.ERR)
            CONTINUE.FLAG = ""
            GOSUB CHK.SELECTION.CRIT
            IF CONTINUE.FLAG EQ 1 THEN ;*R22 AUTO CODE CONVERSION - START
                CONTINUE
            END ;*R22 AUTO CODE CONVERSION - END

            GOSUB PROCESS
        END

    REPEAT

    CHANGE @VM TO "|" IN Y.FINAL.ARRAY
    Y.FINAL.ARRAY = SORT(Y.FINAL.ARRAY)
    CHANGE "|" TO @VM IN Y.FINAL.ARRAY

RETURN
*-------
PROCESS:
*-------

    IF R.STANDING.ORDER THEN

        GOSUB GET.STO.DETAILS

        CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.PAY.MTHD, R.FT.TXN.TYPE.CONDITION, Y.ERR.FT.TXN.TYPE.CONDITION) ;*R22 AUTO CODE CONVERSION

        IF R.FT.TXN.TYPE.CONDITION THEN
            GOSUB CHECK.PAY.TYPE
        END
        GOSUB GET.INSTRUCCION.VALUE
        CALL F.READ(FN.CUSTOMER, Y.CLNT.CODE, R.CUSTOMER, F.CUSTOMER, Y.CUS.ERR)
        IF R.CUSTOMER THEN
            Y.CLNT.TYPE    = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.CLI.TYPE.POS>
            Y.CLNT.NAME   = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
        Y.ACCT.ID = FIELD(Y.STO.ID,'.',1)
        CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
        IF R.ACCOUNT THEN
            Y.ACCT.NAME = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
        END
        Y.FINAL.ARRAY<-1> = Y.DATE:'*':Y.CLNT.CODE:'*':Y.CLNT.NAME:'*':Y.CLNT.TYPE:'*':Y.ACCT.EXE:'*':Y.ACCT.NR:'*':Y.ACCT.NAME:'*':Y.CCY:'*':Y.AMOUNT:'*':Y.DOMIC.05:"*":Y.DOMIC.04:"*":Y.DOMIC.OTHERS:"*":Y.DOMIC.07:"*":Y.INSTRUCCION:'*':Y.BENEF.BNK:'*':Y.ACCT.THRD.PAR:'*':Y.CR.CUS.NAME:'*':Y.REA.FOR.REJ
*                                1       2             3                4              5              6              7             8           9            10             11             12                  13               14            15              16                17                    18
    END

    GOSUB NULLIFY.VALUES

RETURN
*------------------
CHK.SELECTION.CRIT:
*------------------

    LOCATE 'CUSTOMER.CODE' IN D.FIELDS<1> SETTING Y.CUS.POS THEN
        Y.CLIENT = D.RANGE.AND.VALUE<Y.CUS.POS>
        IF Y.CLIENT NE R.STANDING.ORDER<STO.DEBIT.CUSTOMER> THEN
            CONTINUE.FLAG = 1
        END
    END

    LOCATE 'BENEFICIARY' IN D.FIELDS<1> SETTING Y.BEN.POS THEN
        Y.BENIFICIARY = D.RANGE.AND.VALUE<Y.BEN.POS>
        IF Y.BENIFICIARY NE R.STANDING.ORDER<STO.BENEFICIARY> THEN
            CONTINUE.FLAG = 1
        END
    END

    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGEN.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGEN.POS>
        IF Y.AGENCY NE R.STANDING.ORDER<STO.CO.CODE> THEN
            CONTINUE.FLAG = 1
        END
    END

RETURN
*---------------
GET.STO.DETAILS:
*---------------

    Y.ACCT.NR        = Y.STO.ID
    Y.CLNT.CODE      = R.STANDING.ORDER<STO.DEBIT.CUSTOMER>
    Y.CCY            = R.STANDING.ORDER<STO.CURRENCY>
    Y.TRANS.TYPE     = R.STANDING.ORDER<STO.PAY.METHOD>
    Y.ACCT.EXE       = R.STANDING.ORDER<STO.ACCT.OFFICER>
    Y.AMOUNT         = R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>
    Y.BENEF.BNK      = R.STANDING.ORDER<STO.ACCT.WITH.BANK>
    Y.ACCT.THRD.PAR  = R.STANDING.ORDER<STO.CPTY.ACCT.NO>
    Y.ACCT.CARD.LOAN = R.STANDING.ORDER<STO.CREDIT.CUSTOMER>
    Y.BEN.ID         = R.STANDING.ORDER<STO.BENEFICIARY.ID>

    IF NOT(Y.BENEF.BNK) AND Y.BEN.ID THEN
        CALL CACHE.READ(FN.BENEFICIARY, Y.BEN.ID, R.BENEFICIARY, BENEFICIARY.ERR) ;*R22 AUTO CODE CONVERSION
        Y.BENEF.BNK = R.BENEFICIARY<ARC.BEN.LOCAL.REF,L.BEN.ACH.ARCIB.POS>
    END
    Y.CR.CUS.NAME = ''


    IF Y.ACCT.CARD.LOAN THEN
        CALL F.READ(FN.CUSTOMER,Y.ACCT.CARD.LOAN,R.CUS,F.CUSTOMER,Y.CR.CUS)
        Y.CR.CUS.NAME = R.CUS<EB.CUS.SHORT.NAME>
    END ELSE
        Y.BENEFI = R.STANDING.ORDER<STO.BENEFICIARY>
        Y.CNT = DCOUNT(Y.BENEFI,@VM)
        Y.CNTR = 1
        LOOP
        WHILE Y.CNTR LE Y.CNT
            Y.BENEFI.CUS = Y.BENEFI<1,Y.CNTR>
            Y.BENI = NUM(Y.BENEFI.CUS)
            IF Y.BENI THEN
                CALL F.READ(FN.CUSTOMER,Y.BENEFI.CUS,R.BEN.CUS,F.CUSTOMER,Y.CR.CUS)
                Y.CR.CUS.NAME<-1> = R.BEN.CUS<EB.CUS.SHORT.NAME>
            END ELSE
                Y.CR.CUS.NAME<-1> = Y.BENEFI
            END
            Y.CNTR += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
    END

    CHANGE @SM TO @VM IN Y.CR.CUS.NAME
    CHANGE @FM TO @VM IN Y.CR.CUS.NAME

    Y.PAY.MTHD       = R.STANDING.ORDER<STO.PAY.METHOD>
RETURN
*---------------
CHECK.PAY.TYPE:
*---------------
    Y.FTTC.PAY.TYPE = R.FT.TXN.TYPE.CONDITION<FT6.LOCAL.REF,Y.PAY.TYPE>

    Y.USER.LANG=R.USER<EB.USE.LANGUAGE>
    IF Y.USER.LANG EQ 1 THEN
        Y.TXN.TYPE = R.FT.TXN.TYPE.CONDITION<FT6.SHORT.DESCR,1>
    END
    IF Y.USER.LANG EQ 2 THEN
        Y.TXN.TYPE = R.FT.TXN.TYPE.CONDITION<FT6.SHORT.DESCR,2>
    END


    CALL CACHE.READ(FN.REDO.APAP.H.PAY.TYPE,'SYSTEM',R.PAY.TYPE,Y.PT.ERR)
    Y.PAY.LOAN = R.PAY.TYPE<REDO.PAY.TYP.PAYMENT.LOAN>
    Y.PAY.CARD = R.PAY.TYPE<REDO.PAY.TYP.PAYMENT.CARD>
    Y.THIRD.PARTY = R.PAY.TYPE<REDO.PAY.TYP.THIRD.PTY.PAY>

    IF Y.FTTC.PAY.TYPE EQ Y.PAY.LOAN THEN
        Y.DOMIC.04 = Y.TXN.TYPE
    END ELSE
        IF Y.FTTC.PAY.TYPE EQ Y.PAY.CARD THEN
            Y.DOMIC.05 = Y.TXN.TYPE
        END ELSE
            IF Y.FTTC.PAY.TYPE EQ Y.THIRD.PARTY THEN
                Y.DOMIC.07 = Y.TXN.TYPE
            END ELSE
                Y.DOMIC.OTHERS = Y.TXN.TYPE
            END
        END
    END
RETURN
*----------------------
GET.INSTRUCCION.VALUE:
*----------------------
    Y.CUR.FRE = R.STANDING.ORDER<STO.CURRENT.FREQUENCY>
    COMI = Y.CUR.FRE
    CALL CFQ
*PACS00072407-S
    CALL CFQ

    Y.NEXT.DATE = COMI[1,8]
    Y.CUR.END.DATE = R.STANDING.ORDER<STO.CURRENT.END.DATE>
    IF Y.NEXT.DATE LT Y.CUR.END.DATE THEN

        Y.CURRENT.BAL=R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>
* PACS00072407- Kick Back >>>>S
        IN.DATE  = ''
        OUT.MASK = ''
        Y.FREQUENC = Y.CUR.FRE
        Y.DATE.1 = FIELD(Y.FREQUENC," ",1)
        Y.RECURRENCE = FIELD(Y.FREQUENC," ",2,6)

        IF Y.RECURRENCE NE '' THEN

            IN.DATE  = ''
            OUT.MASK = ''
            CALL EB.BUILD.RECURRENCE.MASK(Y.RECURRENCE, IN.DATE, OUT.MASK)
            Y.DATE.1 = ICONV(Y.DATE.1,"D2")
            Y.DATE.OCONV = OCONV(Y.DATE.1,"D4")
            Y.INSTRUCCION = Y.DATE.OCONV:" ":OUT.MASK

        END ELSE

            Y.DATE.1 = Y.FREQUENC[1,8]
            Y.RECURRENCE = Y.FREQUENC[9,50]

            Y.DATE.1 = ICONV(Y.DATE.1,"D2")
            Y.DATE.OCONV = OCONV(Y.DATE.1,"D4")
            Y.INSTRUCCION = Y.DATE.OCONV:" ":Y.RECURRENCE
        END
* PACS00072407- Kick Back >>>>S
* PACS00072407-E
    END ELSE
        Y.INSTRUCCION = ''
    END
RETURN
*--------------
NULLIFY.VALUES:
*--------------
    Y.DATE = ''
    Y.CLNT.CODE = ''
    Y.CLNT.NAME = ''
    Y.CLNT.TYPE = ''
    Y.ACCT.EXE = ''
    Y.ACCT.NR = ''
    Y.ACCT.NAME = ''
    Y.CCY = ''
    Y.AMOUNT = ''
    Y.INSTRUCCION = ''
    Y.BENEF.BNK = ''
    Y.ACCT.THRD.PAR = ''
    Y.CR.CUS.NAME = ''
    Y.REA.FOR.REJ = ''
    Y.DOMIC.OTHERS = ''
    Y.DOMIC.07 = ''
    Y.DOMIC.05 = ''
    Y.DOMIC.04 = ''
*
RETURN
*
END
