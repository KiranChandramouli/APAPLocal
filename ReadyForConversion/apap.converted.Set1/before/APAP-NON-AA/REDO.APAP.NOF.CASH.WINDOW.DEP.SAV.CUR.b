*-----------------------------------------------------------------------------
* <Rating>-115</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.COMPANY.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.R32, this routine is used to fetch the SAVINGS and CURRENT
*                    account DEPOSITS from the TELLER transactions
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : R.REDO.H.TELLER.TXN.CODES - The record of REDO.H.TELLER.TXN.CODES
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.COMPANY.LIST - The variblle holds the list of third party payment companies
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*Files  Used       : ACCOUNT.CLASS                    As              I               Mode
*                    TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*                    REDO.ADMIN.CHQ.PARAM             As              I               Mode
*                    REDO.MANAGER.CHQ.PARAM           As              I               Mode
*                    CERTIFIED.CHEQUE.PARAMETER       As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 jun 2011       Marimuthu S                 ODR-2011-04-0007 32         Modification made in REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.H.TELLER.TXN.CODES
$INSERT I_F.ACCOUNT.CLASS
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.ADMIN.CHQ.PARAM
$INSERT I_F.REDO.MANAGER.CHQ.PARAM
$INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
$INSERT I_F.TELLER.PARAMETER
$INSERT I_F.TELLER.ID
$INSERT I_F.FUNDS.TRANSFER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
  F.ACCOUNT.CLASS  = ''
  CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
  F.ACCOUNT.HST  = ''
  CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

  FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
  F.REDO.ADMIN.CHQ.PARAM  = ''
  CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

  FN.REDO.MANAGER.CHQ.PARAM = 'F.REDO.MANAGER.CHQ.PARAM'
  F.REDO.MANAGER.CHQ.PARAM  = ''
  CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)

  FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
  F.CERTIFIED.CHEQUE.PARAMETER  = ''
  CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)

  FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
  F.TELLER.PARAMETER = ''
  CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  SEL.LIST.MAIN = ''
  GOSUB FORM.SEL.CMD.R35
  IF NOT(SEL.LIST.MAIN) THEN
    RETURN
  END
  GOSUB GET.TXN.CODE.DETAILS
  GOSUB GET.CATEGORY.DETAILS
  GOSUB FIND.MULTI.LOCAL.REF
  GOSUB GET.SAV.CURR.DETAILS
  RETURN

****************
FORM.SEL.CMD.R35:
****************
* In this para of the code, the SELECT command is formed to get the TELLER transactions IDs for processing

  Y.T24.REF = ''; Y.T24.ALL.REFERENCE = ''; SET.CUR = ''; Y.CURRENCY = ''
  LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGY.POS  THEN
    Y.AGENCY = D.RANGE.AND.VALUE<Y.AGY.POS>
  END

  SEL.FT.CMD = ''; SEL.LIST.FT = ''; NO.OF.REC.FT = ''; SEL.ERR.FT = ''; SEL.LIST.MAIN = ''
  SEL.CMD.MAIN = ''; SEL.LIST.TT = ''; NO.OF.REC.MAIN = ''; SEL.ERR.MAIN = ''
  IF Y.AGENCY THEN
    SEL.CMD.MAIN = 'SELECT ':FN.TELLER:' WITH CO.CODE EQ ':Y.AGENCY
    SEL.FT.CMD = 'SELECT ':FN.FUNDS.TRANSFER:' WITH CO.CODE EQ ':Y.AGENCY
  END ELSE
    SEL.CMD.MAIN = 'SELECT ':FN.TELLER
    SEL.FT.CMD = 'SELECT ':FN.FUNDS.TRANSFER
  END
  CALL EB.READLIST(SEL.FT.CMD,SEL.LIST.FT,'',NO.OF.REC.FT,SEL.ERR.FT)
  CALL EB.READLIST(SEL.CMD.MAIN,SEL.LIST.TT,'',NO.OF.REC.MAIN,SEL.ERR.MAIN)
  SEL.LIST.MAIN = SEL.LIST.TT:FM:SEL.LIST.FT
  IF SEL.LIST.FT THEN
    SEL.LIST.MAIN = SEL.LIST.TT:FM:SEL.LIST.FT
  END ELSE
    SEL.LIST.MAIN = SEL.LIST.TT
  END
  RETURN

*********************
GET.TXN.CODE.DETAILS:
*********************
* In this para of the code, the TXN.CODES for the payment type and transaction type are segregated
  Y.TT.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.PAYMENT.MODE>
  LOCATE 'CASH' IN Y.TT.TXN.CODES<1,1> SETTING Y.CASH.POS THEN
    Y.CASH.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CASH.POS>
    Y.CASH.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CASH.POS>
    CHANGE SM TO FM IN Y.CASH.TXN.TYPE
    CHANGE SM TO FM IN Y.CASH.TXN.CODE
  END

  LOCATE 'CHEQUE' IN Y.TT.TXN.CODES<1,1> SETTING Y.CHQ.POS THEN
    Y.CHQ.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CHQ.POS>
    Y.CHQ.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CHQ.POS>
    CHANGE SM TO FM IN Y.CHQ.TXN.TYPE
    CHANGE SM TO FM IN Y.CHQ.TXN.CODE
  END

  LOCATE 'TRANSFER' IN Y.TT.TXN.CODES<1,1> SETTING Y.TFR.POS THEN
    Y.TFR.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.TFR.POS>
    Y.TFR.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.TFR.POS>
    CHANGE SM TO FM IN Y.TFR.TXN.TYPE
    CHANGE SM TO FM IN Y.TFR.TXN.CODE
  END
  YAC.SHORTAGE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.AC.SHORTAGE>
  CHANGE VM TO FM IN YAC.SHORTAGE
  RETURN

*********************
GET.CATEGORY.DETAILS:
*********************
* In this para of the code, the SAVINGS and CURRENT account categories are fetched
  ACCOUNT.CLASS.ID = 'SAVINGS'
  GOSUB READ.ACCOUNT.CLASS

  Y.SAVINGS.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>
  CHANGE VM TO FM IN Y.SAVINGS.CATEG

  ACCOUNT.CLASS.ID = 'CURRENT'
  GOSUB READ.ACCOUNT.CLASS

  Y.CURRENT.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>
  CHANGE VM TO FM IN Y.CURRENT.CATEG

  Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
  CHANGE VM TO FM IN Y.CASH.CATEG

  R.TELLER.PARAMETER = ''; TELL.PARAM.ERR = ''
  CALL CACHE.READ(FN.TELLER.PARAMETER,ID.COMPANY,R.TELLER.PARAMETER,TELL.PARAM.ERR)
  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.SAV.CURR.DETAILS:
*********************
* In this para of the code, the TELLER TRANSACTION details are read and checked if the transaction can be
** consdiered or not for calculations and display
  GOSUB GET.CHEQUE.DETAILS
  LOOP
    REMOVE TELLER.ID FROM SEL.LIST.MAIN SETTING Y.TELLER.POS
  WHILE TELLER.ID:Y.TELLER.POS
    R.TELLER  = ''; TELLER.ER = ''; R.FUNDS.TRANSFER = ''; ERR.FUNDS.TRANS = ''; Y.TT.TXN.CODE = ''
    Y.TT.ADJ.CUR = ''; Y.AMT.LOC.VAL = ''; Y.AMT.FCY = ''; Y.TT.ADJ.CUR.1 = ''; YSAV.ACCT = ''; YSAV.ACCT1 = ''
    IF TELLER.ID[1,2] EQ 'TT' THEN
      GOSUB READ.TELLER
      GOSUB GET.TT.DETAILS
    END
    IF TELLER.ID[1,2] EQ 'FT' THEN
      GOSUB READ.FUNDS.TRANS
      GOSUB GET.FT.DETAILS
      R.TELLER = R.FUNDS.TRANSFER
    END

    Y.TT.PARAM.REC = R.TELLER:'##':R.REDO.ADMIN.CHQ.PARAM:'##':R.REDO.MANAGER.CHQ.PARAM:'##':R.CERTIFIED.CHEQUE.PARAMETER:'##':R.REDO.H.TELLER.TXN.CODES
    GOSUB CHECK.TT.CUS.ACCOUNT
    IF Y.CASH.DEP.FLAG OR Y.CHQ.DEP.FLAG OR Y.TFR.DEP.FLAG ELSE
      CONTINUE
    END

    IF Y.CASH.CODE.FLAG OR Y.CHQ.CODE.FLAG OR Y.TFR.CODE.FLAG ELSE
      CONTINUE
    END

    YTT.COMP.NME = ''; YTT.MET.PAY = ''
    YTT.COMP.NME = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>
    YTT.MET.PAY = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.MET.OF.PAY.POS>
    IF YTT.COMP.NME AND YTT.MET.PAY THEN
      GOSUB GET.THIRD.PARTY.PAYMENTS
    END
    GOSUB CHECK.SAVING.DEPOSITS
    IF Y.SAVINGS.AC EQ 1 OR Y.CURRENT.AC EQ 1 THEN
      CONTINUE
    END

    GOSUB CHEK.TERM.INST
*        GOSUB GET.CASH.FROM.TELLER
    GOSUB GET.LOAN.PAYMNTS.DETAILS
    GOSUB GET.CCARD.PAYMENT.DETAILS
    GOSUB CREDIT.ADJUSTMENT
    GOSUB GET.CASH.FROM.TELLER
    IF R.TELLER<TT.TE.CURRENCY.1> NE R.TELLER<TT.TE.CURRENCY.2> THEN
      GOSUB GET.BUY.CURRENCY
    END
    GOSUB GET.OTHER.INCOMES
  REPEAT
  RETURN

*******************
CREDIT.ADJUSTMENT:
*******************
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END

  Y.AMT.REQ = Y.AMT.LOC.VAL
  LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN YAC.SHORTAGE<1> SETTING OV.POSN1 ELSE
    LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN YAC.SHORTAGE<1> SETTING OV.POSN2 ELSE
      RETURN
    END
  END
  GOSUB AMEND.ARRAY.CRD.ADJ
  RETURN

*******************
AMEND.ARRAY.CRD.ADJ:
*******************
  LOCATE Y.TT.ADJ.CUR IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
    Y.CCY.LIST<-1> = Y.TT.ADJ.CUR
    Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
  END
  IF Y.TT.ADJ.CUR EQ LCCY THEN
    Y.COMP.CNT = DCOUNT(Y.COMPANY.LIST,FM)
  END ELSE
    Y.COMP.CNT = 0
  END
  Y.VM.POS  = 20 + Y.COMP.CNT + 9
  Y.ADD.AMT = Y.AMT.REQ
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> = ''
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7> += Y.ADD.AMT

  Y.TT.LIST<-1> = TELLER.ID
  RETURN

*******************
GET.CHEQUE.DETAILS:
*******************
* In this para of the code, the ADMIN, MANAGER and CERTIFIED cheque records are being read in here
  REDO.ADMIN.CHQ.PARAM.ID = 'SYSTEM'
  GOSUB READ.REDO.ADMIN.CHQ.PARAM

  REDO.MANAGER.CHQ.PARAM.ID = 'SYSTEM'
  GOSUB READ.REDO.MANAGER.CHQ.PARAM

  CERTIFIED.CHEQUE.PARAMETER.ID = ID.COMPANY
  GOSUB READ.CERTIFIED.CHEQUE.PARAMETER
  RETURN

*********************
CHEK.TERM.INST:
*********************
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  Y.T24.REF = R.TELLER<TT.TE.LOCAL.REF,LOC.T24.FS.REF>
*-------- START ------------
  GOSUB CHECK.TFS.AZ
*-------- END ------------
  IF Y.CUS.ACC.FLAG EQ 'YES' THEN
*        LOCATE Y.T24.REF IN Y.T24.ALL.REFERENCE SETTING TFS.POS ELSE
    YTELLER.ID = TELLER.ID
    TELLER.ID = TELLER.ID:"_":YFST.FLG
    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN.R32(Y.CCY.LIST,TELLER.ID,R.TELLER,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
    Y.T24.ALL.REFERENCE<-1> = Y.T24.REF
    TELLER.ID = YTELLER.ID
*        END
  END
  RETURN
***************
CHECK.TFS.AZ:
***************
  Y.CUS.ACC.FLAG = ''; YFST.FLG = 0
  ACCOUNT.ID = YSAV.ACCT
  GOSUB READ.ACCOUNT
  Y.APP = ''; ACCOUNT.ID = ''
  Y.APP =  R.ACC1<AC.ALL.IN.ONE.PRODUCT>
  IF Y.APP THEN
    Y.CUS.ACC.FLAG = 'YES'
    YFST.FLG = 1
    RETURN
  END
  ACCOUNT.ID = YSAV.ACCT1
  GOSUB READ.ACCOUNT
  Y.APP =  R.ACC1<AC.ALL.IN.ONE.PRODUCT>
  IF Y.APP THEN
    YFST.FLG = 2
    Y.CUS.ACC.FLAG = 'YES'
    RETURN
  END
  LOCATE YSAV.ACCT IN YAZ.DP.NREINV<1> SETTING Y.CACC.POS THEN
    YFST.FLG = 1
    Y.CUS.ACC.FLAG = 'YES'
  END ELSE
    LOCATE YSAV.ACCT1 IN YAZ.DP.NREINV<1> SETTING Y.CAACC.POS THEN
      YFST.FLG = 2
      Y.CUS.ACC.FLAG = 'YES'
    END
  END
  RETURN

*********************
CHECK.TT.CUS.ACCOUNT:
*********************
* In this para of the code, the accounts used in the teller transaction are being checked if any one among
** them is customer account else we will not consider this transaction
  Y.CASH.DEP.FLAG = ''; Y.CHQ.DEP.FLAG  = '';  Y.TFR.DEP.FLAG = ''
  Y.TFR.CODE.FLAG = ''; Y.CHQ.CODE.FLAG = ''; Y.CASH.CODE.FLAG = ''
  Y.SAVINGS.AC   = ''; Y.CURRENT.AC   = ''
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
* In this para of the code, the TXN.CODE is checked with transaction type and payment mode
  LOCATE Y.TT.TXN.CODE IN Y.CASH.TXN.CODE<1> SETTING Y.TXN.POS THEN
    Y.CASH.CODE.FLAG = 1
    IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
      Y.CASH.DEP.FLAG = 1
    END
    IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
      Y.CASH.DEP.FLAG = 1
    END
  END

  LOCATE Y.TT.TXN.CODE IN Y.CHQ.TXN.CODE<1> SETTING Y.TXN.POS THEN
    Y.CHQ.CODE.FLAG = 1
    IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
      Y.CHQ.DEP.FLAG = 1
    END
    IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
      Y.CHQ.DEP.FLAG = 1
    END
  END

  LOCATE Y.TT.TXN.CODE IN Y.TFR.TXN.CODE<1> SETTING Y.TXN.POS THEN
    Y.TFR.CODE.FLAG = 1
    IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
      Y.TFR.DEP.FLAG = 1
    END
    IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
      Y.TFR.DEP.FLAG = 1
    END
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
  YAZ.DP.NREINV = R.REDO.H.TELLER.TXN.CODES<TT.TXN.AZ.DP.NREINV>
  CHANGE VM TO FM IN YAZ.DP.NREINV
  RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CHECK.SAVING.DEPOSITS:
**********************
* In this para of the code, the DEPOSISTS-SAVINGS transactions are processed and considered
  YAZ.ACC.REF = ''
  YAZ.ACC.REF = R.TELLER<TT.TE.LOCAL.REF,LOC.TT.POS.ACC.REF>
*    IF YAZ.ACC.REF THEN
*        RETURN
*    END
  Y.TT.AMT = ''
  ACCOUNT.ID = YSAV.ACCT1
  GOSUB READ.ACCOUNT
  YCUST = R.ACC1<AC.CUSTOMER>
  IF NOT(YCUST) AND YAZ.ACC.REF THEN
    ACCOUNT.ID = YAZ.ACC.REF
    GOSUB READ.ACCOUNT
  END
  GOSUB CHECK.SAVE.CURR.CATEG
  Y.TT.CCY = Y.TT.ADJ.CUR
  Y.TT.AMT = Y.AMT.LOC.VAL
  GOSUB UPDATE.SAV.CUR.DETAILS
  RETURN

GET.TT.DETAILS:
***************
  Y.TT.TXN.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>
  Y.TT.ADJ.CUR = R.TELLER<TT.TE.CURRENCY.2>
  YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>

  Y.AMT.LOC.VAL = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
  IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
    Y.AMT.LOC.VAL = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
  END

  IF NOT(Y.AMT.LOC.VAL) THEN
    Y.AMT.LOC.VAL = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
  END
  IF Y.TT.ADJ.CUR NE LCCY THEN
    Y.AMT.LOC.VAL = R.TELLER<TT.TE.AMOUNT.FCY.2>
  END

  YSAV.ACCT = R.TELLER<TT.TE.ACCOUNT.1>
  YSAV.ACCT1 = R.TELLER<TT.TE.ACCOUNT.2>
  RETURN

GET.FT.DETAILS:
***************
  Y.TT.TXN.CODE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
  Y.TT.ADJ.CUR = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
  IF NOT(Y.TT.ADJ.CUR) THEN
    Y.TT.ADJ.CUR = LCCY
  END
  Y.AMT.LOC.VAL = R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.L.TT.TRANS.AMT>
  IF NOT(Y.AMT.LOC.VAL) THEN
    Y.AMT.LOC.VAL = R.FUNDS.TRANSFER<FT.AMOUNT.CREDITED>[4,99]
  END
  Y.AMT.FCY = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
  Y.TT.ADJ.CUR.1= R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
  IF NOT(Y.TT.ADJ.CUR.1) THEN
    Y.TT.ADJ.CUR.1 = LCCY
  END
  YSAV.ACCT = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
  YSAV.ACCT1 = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
  RETURN

**********************
CHECK.SAVE.CURR.CATEG:
**********************
* In this para of the code, the ACCOUNT category is checked if it is SAVINGS account category or CURRENT
** account category and a falg is set respectively
  Y.SAVE.POS = ''
  LOCATE R.ACC1<AC.CATEGORY> IN Y.SAVINGS.CATEG<1> SETTING Y.SAVE.POS THEN
    Y.SAVINGS.AC = 1
  END
  IF Y.CURRENT.CATEG THEN
    LOCATE R.ACC1<AC.CATEGORY> IN Y.CURRENT.CATEG<1> SETTING Y.CURR.POS THEN
      Y.CURRENT.AC = 1
    END
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
***********************
UPDATE.SAV.CUR.DETAILS:
***********************
* In this para of the code, the transaction amount is updated to the final array based on the CURRENCY
  IF Y.SAVINGS.AC THEN
    Y.VM.POS  = 2
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END
  IF Y.CURRENT.AC THEN
    Y.VM.POS  = 3
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up
  LOCATE Y.TT.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
    Y.CCY.LIST<-1> = Y.TT.CCY
    Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
  END

  BEGIN CASE
  CASE Y.CASH.DEP.FLAG
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT

  CASE Y.CHQ.DEP.FLAG
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT

  CASE Y.TFR.DEP.FLAG
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
  END CASE

  Y.TT.LIST<-1> = TELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
GET.LOAN.PAYMNTS.DETAILS:
*--------------------------------------------------------------------------------------------------------
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  YTELLER.ID = ''
  YTELLER.ID = TELLER.ID
  TELLER.ID = TELLER.ID:"_":Y.CASH.TXN.TYPE:"_":Y.CASH.TXN.CODE:"_":Y.CHQ.TXN.TYPE:"_":Y.CHQ.TXN.CODE:"_":Y.TFR.TXN.TYPE:"_":Y.TFR.TXN.CODE
  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
  TELLER.ID = YTELLER.ID
  RETURN

**************************
GET.CCARD.PAYMENT.DETAILS:
**************************
* In this para of the code, a CALL to a seperate routine is made to fetch the CREDIT CARD PAYMENT details
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  YTELLER.ID = ''
  YTELLER.ID = TELLER.ID
  TELLER.ID = TELLER.ID:"_":Y.CASH.TXN.TYPE:"_":Y.CASH.TXN.CODE:"_":Y.CHQ.TXN.TYPE:"_":Y.CHQ.TXN.CODE:"_":Y.TFR.TXN.TYPE:"_":Y.TFR.TXN.CODE
  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
  TELLER.ID = YTELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
*************************
GET.THIRD.PARTY.PAYMENTS:
*************************
* In this para of the code, a CALL to a seperate routine is made to fetch the THIRD PARTY SERVICE PAYMENT details

  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
  RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.OTHER.INCOMES:
******************
* In this para of the code, a CALL to a seperate routine is made to fetch the OTHER INCOMES details
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  YTELLER.ID = ''
  YTELLER.ID = TELLER.ID
  TELLER.ID = TELLER.ID:"_":Y.CASH.DEP.FLAG:"_":Y.CHQ.DEP.FLAG:"_":Y.TFR.DEP.FLAG
  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
  TELLER.ID = YTELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.CASH.FROM.TELLER:
*********************
* In this para of the code, a CALL to a seperate routine is made to fetch the CASH TRANSFERS FROM TELLER details

  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  YTELLER.ID = ''; Y.TELLER.ID = ''
  YTELLER.ID = TELLER.ID
  TELLER.ID = TELLER.ID:"_":Y.TELLER.ID:"_":Y.CASH.TXN.TYPE:"_":Y.CASH.TXN.CODE:"_":Y.CHQ.TXN.TYPE:"_":Y.CHQ.TXN.CODE:"_":Y.TFR.TXN.TYPE:"_":Y.TFR.TXN.CODE
  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR,R.REDO.H.TELLER.TXN.CODES)
  TELLER.ID = YTELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.BUY.CURRENCY:
*****************
* In this para of the code, a CALL to a seperate routine is made to fetch the BUY CURRENCY
  LOCATE TELLER.ID IN Y.TT.LIST<1> SETTING Y.TT.POS THEN
    RETURN
  END
  CALL REDO.APAP.NOF.CASH.WINDOW.DEP.BUY.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.TT.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
  RETURN

*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
  R.ACC1  = '';    ACCOUNT.ER = ''
  CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACC1,F.ACCOUNT,ACCOUNT.ER)
  IF NOT(R.ACC1) THEN
    ACCOUNT.IDH = ACCOUNT.ID; ERR.AC = ''
    CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,ACCOUNT.IDH,R.ACC1,ERR.AC)
  END
  RETURN

*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
  R.ACCOUNT.CLASS  = ''
  ACCOUNT.CLASS.ER = ''
  CALL F.READ(FN.ACCOUNT.CLASS,ACCOUNT.CLASS.ID,R.ACCOUNT.CLASS,F.ACCOUNT.CLASS,ACCOUNT.CLASS.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.TELLER:
************
* In this para of the code, file TELLER is read
  R.TELLER = ''; TELLER.ER = ''
  CALL F.READ(FN.TELLER,TELLER.ID,R.TELLER,F.TELLER,TELLER.ER)
  RETURN

READ.FUNDS.TRANS:
*****************
  R.FUNDS.TRANSFER = ''; ERR.FUNDS.TRANS = ''
  CALL F.READ(FN.FUNDS.TRANSFER,TELLER.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR.FUNDS.TRANS)
  RETURN

**************************
READ.REDO.ADMIN.CHQ.PARAM:
**************************
* In this para of the code, file REDO.ADMIN.CHQ.PARAM is read
  R.REDO.ADMIN.CHQ.PARAM  = ''
  REDO.ADMIN.CHQ.PARAM.ER = ''
  CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ER)
  RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.REDO.MANAGER.CHQ.PARAM:
****************************
* In this para of the code, file REDO.MANAGER.CHQ.PARAM is read
  R.REDO.MANAGER.CHQ.PARAM  = ''
  REDO.MANAGER.CHQ.PARAM.ER = ''
  CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,REDO.MANAGER.CHQ.PARAM.ID,R.REDO.MANAGER.CHQ.PARAM,REDO.MANAGER.CHQ.PARAM.ER)
  RETURN
*--------------------------------------------------------------------------------------------------------
********************************
READ.CERTIFIED.CHEQUE.PARAMETER:
********************************
* In this para of the code, file CERTIFIED.CHEQUE.PARAMETER is read
  R.CERTIFIED.CHEQUE.PARAMETER  = ''
  CERTIFIED.CHEQUE.PARAMETER.ER = ''
  CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,CERTIFIED.CHEQUE.PARAMETER.ID,R.CERTIFIED.CHEQUE.PARAMETER,CERTIFIED.CHEQUE.PARAMETER.ER)
  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'TELLER':FM:'FUNDS.TRANSFER'
  FLD.ARRAY  = 'L.TT.POS.AUTHNM':VM:'L.TT.CR.CARD.NO':VM:'L.TT.CR.ACCT.NO':VM:'T24.FS.REF':VM:'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT':VM:'L.TT.CMPNY.NAME':VM:'L.TT.MET.OF.PAY':VM:'L.TT.AZ.ACC.REF':FM:'L.TT.TRANS.AMT'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.TT.POS.AUTHNM.POS  =  FLD.POS<1,1>
  LOC.TT.CCARD.NO.POS      =  FLD.POS<1,2>
  LOC.TT.CCARD.ACC.NO.POS  =  FLD.POS<1,3>
  LOC.T24.FS.REF = FLD.POS<1,4>
  LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,5>
  LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,6>
  LOC.L.TT.CMPNY.NAME.POS = FLD.POS<1,7>
  LOC.L.TT.MET.OF.PAY.POS = FLD.POS<1,8>
  LOC.TT.POS.ACC.REF = FLD.POS<1,9>
  LOC.L.TT.TRANS.AMT = FLD.POS<2,1>
  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
