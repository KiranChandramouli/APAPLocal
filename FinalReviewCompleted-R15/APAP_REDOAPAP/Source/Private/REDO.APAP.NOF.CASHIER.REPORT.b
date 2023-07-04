* @ValidationCode : MjotMjQ2NTczMTMzOkNwMTI1MjoxNjg0ODM2MDQ3NTU3OklUU1M6LTE6LTE6NDU2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 456
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASHIER.REPORT(STORE.FINAL.ARRAY)
*    PROGRAM REDO.APAP.NOF.CASHIER.REPORT
*----------------------------------------------------------------------------------------------------------------------
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DENOM
*----------------------------------------------------------------------------------------------------------------------
* Description       : REDO.APAP.NOF.CASHIER.REPORT is an No-file enquiry routine, this routine is used to
*                     extract data from relevant files so as to display in the CASH DENOM TRANSACTION report.
* Linked With       : Enquiry - REDO.APAP.ENQ.CASHIER.DENOM
*
* In  Parameter     : NA
* Out Parameter     : Y.OUT.ARRAY - Output array for display
* Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*----------------------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date          Who                Reference              Description
* ------        -----              -------------          -------------
* 10 Jun 2011   Ganesh R           ODR-2011-04-0007 35    Initial Creation
* 05 JUL 2013   Vignesh Kumaar R   PACS00296978           REVAMP
* 04 Apr 2015   Ashokkumar.V.P     PACS00311265           fixing the report
* 01 Jan 2018   Gopala Krishnan R  PACS00641500           Fixing the Issue
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  ++ to +=, VM to @VM , F.READ to CACHE.READ
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.TELLER.ID
    $INSERT I_F.TT.STOCK.CONTROL
    $INSERT I_F.TELLER.DENOMINATION
	$USING APAP.TAM

    COM/CASHIER.DENOM.ENQ.COMMON/Y.TEMP.DATA

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------------------------------------

    GET.TOTAL = ''; STORE.BILL.INFO = ''
    GET.BILL.TOTAL = ''; STORE.COIN.INFO = ''
    GET.COIN.TOTAL = ''

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.TELLER.DENOMINATION = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOMINATION = ''
    CALL OPF(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

    FN.TT.STOCK.CONTROL = 'F.TT.STOCK.CONTROL'
    F.TT.STOCK.CONTROL = ''
    CALL OPF(FN.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)

    LOC.APPLICATION = 'TELLER.ID'
    LOC.FIELDS = 'L.TT.TILL.LIM':@VM:'L.TT.CURRENCY'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    Y.TT.TID.BR.LIM = LOC.POS<1,1>
    Y.TT.TID.CCY    = LOC.POS<1,2>

    Y.TEMP.DATA = ''

RETURN
*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    LOCATE 'TELLER.ID' IN D.FIELDS<1> SETTING Y.TEL.POS  THEN
        Y.TELLER.ID = D.RANGE.AND.VALUE<Y.TEL.POS>
    END
    LOCATE 'CURRENCY' IN D.FIELDS<1> SETTING Y.CCY.POS  THEN
        Y.CURRENCY.ID = D.RANGE.AND.VALUE<Y.CCY.POS>
    END

    IF NOT(Y.CURRENCY.ID) THEN
*SEL.STOCK = 'SELECT ':FN.TT.STOCK.CONTROL:' WITH @ID LIKE ...':Y.TELLER.ID:'...'
        SEL.STOCK = 'SELECT ':FN.TT.STOCK.CONTROL:' WITH @ID LIKE ...':Y.TELLER.ID:'...':' BY EVAL"@ID[4,5]"'
    END ELSE
        SEL.STOCK = 'SELECT ':FN.TT.STOCK.CONTROL:' WITH @ID LIKE ':Y.CURRENCY.ID:'...':Y.TELLER.ID:'...'
    END

    STOCK.LIST = ''; NO.OF.STOCK = ''; STOCK.ERR = ''
    CALL EB.READLIST(SEL.STOCK,STOCK.LIST,'',NO.OF.STOCK,STOCK.ERR)

*    STOCK.LIST = 'DOP1000117010017':FM:'USD1000117010017'
*    Y.TELLER.ID = 1701
    R.TELLER.ID = ''; TID.ERR = ''
    CALL F.READ(FN.TELLER.ID,Y.TELLER.ID,R.TELLER.ID,F.TELLER.ID,TID.ERR)
    TID.CUR.LIST = R.TELLER.ID<TT.TID.LOCAL.REF><1,Y.TT.TID.CCY>
    TID.CCY.LIST = R.TELLER.ID<TT.TID.CURRENCY>
    TID.CAT.LIST = R.TELLER.ID<TT.TID.CATEGORY>
    YCURR.LT = 1
    LOOP
        REMOVE GET.STOCK.ID FROM STOCK.LIST SETTING STOCK.POS
    WHILE GET.STOCK.ID:STOCK.POS
        CURR.ID = ''; TT.TID.CATEG = ''
        GET.STOCK.LEN = LEN(GET.STOCK.ID)
        GET.TILL.ID = GET.STOCK.ID[(GET.STOCK.LEN-7),4]
        TT.TID.CATEG = TID.CAT.LIST<1,YCURR.LT>
        CURR.ID = TID.CCY.LIST<1,YCURR.LT>
        IF GET.TILL.ID EQ Y.TELLER.ID THEN
            GOSUB MAIN.PROCESS
            GOSUB EXCESS.LIMIT.DETAILS
            GOSUB ALIGN.FORMAT

            YCURR.LT += 1
        END
*YCURR.LT++
    REPEAT
RETURN
*----------------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    R.TT.STOCK.CONTROL = ''; STOCK.ERR = ''
    CALL F.READ(FN.TT.STOCK.CONTROL,GET.STOCK.ID,R.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL,STOCK.ERR)
    STOCK.DENOM.LIST = R.TT.STOCK.CONTROL<TT.SC.DENOMINATION>
    STOCK.QUANTITY.LIST = R.TT.STOCK.CONTROL<TT.SC.QUANTITY>
    Y.CURRENCY = GET.STOCK.ID[1,3]
    STOCK.CNT = 1

    LOOP
        REMOVE GET.DENOM FROM STOCK.DENOM.LIST SETTING DENOM.POS
    WHILE GET.DENOM:DENOM.POS
        CALL CACHE.READ(FN.TELLER.DENOMINATION, GET.DENOM, R.TELLER.DENOMINATION, DENOM.ERR) ;*R22 AUTO CODECONVERSION
        GET.VALUE = R.TELLER.DENOMINATION<TT.DEN.VALUE>
        GET.DENOM.LEN = LEN(GET.DENOM)

        IF GET.DENOM[(GET.DENOM.LEN-3),4] EQ 'BILL' THEN
            Y.BILL.AMOUNT = GET.VALUE * STOCK.QUANTITY.LIST<1,STOCK.CNT>
            STORE.BILL.INFO<-1> = Y.CURRENCY:'*':GET.DENOM:'*':STOCK.QUANTITY.LIST<1,STOCK.CNT>:'*':FMT(Y.BILL.AMOUNT,'15R,2')
            GET.BILL.TOTAL += Y.BILL.AMOUNT
        END ELSE
            Y.COIN.AMOUNT = GET.VALUE * STOCK.QUANTITY.LIST<1,STOCK.CNT>
            STORE.COIN.INFO<-1> = Y.CURRENCY:'*':GET.DENOM:'*':STOCK.QUANTITY.LIST<1,STOCK.CNT>:'*':FMT(Y.COIN.AMOUNT,'15R,2')
            GET.COIN.TOTAL += Y.COIN.AMOUNT
        END

        GET.TOTAL += GET.VALUE * STOCK.QUANTITY.LIST<1,STOCK.CNT>
        STOCK.CNT += 1 ;*R22 AUTO CODECONVERSION
    REPEAT
RETURN
*----------------------------------------------------------------------------------------------------------------------
EXCESS.LIMIT.DETAILS:
*----------------------------------------------------------------------------------------------------------------------
    Y.CATEG.CNT = 1
    Y.TT.TID.CATEG = TT.TID.CATEG
    Y.CATEGORY = GET.STOCK.ID[4,5]
    Y.CASH.HELD = 0; Y.CASH.LIMIT = 0
    LOOP
        REMOVE CATEG.ID FROM TT.TID.CATEG SETTING TT.CATEG.POS
    WHILE CATEG.ID:TT.CATEG.POS
        IF CATEG.ID EQ Y.CATEGORY AND CURR.ID EQ Y.CURRENCY THEN
            Y.CASH.HELD+= R.TELLER.ID<TT.TID.TILL.CLOS.BAL,YCURR.LT>
        END
        Y.CATEG.CNT += 1 ;*R22 AUTO CODECONVERSION
    REPEAT

    IF NOT(Y.TT.TID.CATEG) THEN
        Y.CASH.HELD = R.TELLER.ID<TT.TID.TILL.CLOS.BAL,YCURR.LT>
    END

    Y.CASH.HELD=ABS(Y.CASH.HELD)
    Y.CASH.EXCESS = Y.CASH.HELD
    LOCATE Y.CURRENCY IN TID.CUR.LIST<1,1,1> SETTING TT.TID.POS THEN
        Y.CASH.LIMIT = R.TELLER.ID<TT.TID.LOCAL.REF><1,Y.TT.TID.BR.LIM,TT.TID.POS>
*Y.CASH.EXCESS = Y.CASH.LIMIT - Y.CASH.HELD
        Y.CASH.EXCESS =  Y.CASH.HELD - Y.CASH.LIMIT

    END
    APAP.TAM.redoRteExcessTeller(Y.TELLER.ID,Y.CURRENCY.ID,Y.AMT.EXCEEDED,REC.CNT)

RETURN
*----------------------------------------------------------------------------------------------------------------------
ALIGN.FORMAT:
*----------------------------------------------------------------------------------------------------------------------

    IF STOCK.CNT GT 1 THEN

        IF STORE.BILL.INFO NE '' THEN
            STORE.FINAL.ARRAY<-1> = STORE.BILL.INFO
        END

        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*TOTAL BILLETES**':FMT(GET.BILL.TOTAL,'15R,2')
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*DENOMINAC.MONEDAS*CANT.MONEDAS*MONTO'

        IF STORE.COIN.INFO NE '' THEN
            STORE.FINAL.ARRAY<-1> = STORE.COIN.INFO
        END

        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*TOTAL MONEDAS**':FMT(GET.COIN.TOTAL,'15R,2')
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*TOTAL GENERAL**':FMT(GET.TOTAL,'15R,2')
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*LIMITE EFECT.CAJERO**':FMT(Y.CASH.LIMIT,'15R,2')
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*EXCESO/DEFECTO LIMIT**':FMT(Y.CASH.EXCESS,'15R,2')
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'*RTE:EFECT=>US15M*CANT. FORMULARIOS*MONTO TOTAL'
        STORE.FINAL.ARRAY<-1> = Y.CURRENCY:'**':REC.CNT:'*':FMT(Y.AMT.EXCEEDED,'15R,2')
    END

    STORE.BILL.INFO = ''; STORE.COIN.INFO = ''; GET.COIN.TOTAL = ''; GET.BILL.TOTAL = ''
    GET.COIN.TOTAL = ''; GET.TOTAL = ''; Y.CASH.LIMIT = ''; Y.CASH.EXCESS = ''; Y.AMT.EXCEEDED = ''
RETURN
*----------------------------------------------------------------------------------------------------------------------
END
