*-----------------------------------------------------------------------------
* <Rating>-183</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.TRANS.DET.EACH.TYPE(Y.FINAL.ARR)
*******************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Temenos Application Management
* Program Name : REDO.NOF.TRANS.DET.EACH.TYPE
*--------------------------------------------------------------------------------
*--------------------------------------------------------------------------------
*Description :This subroutine is attached to the ENQUIRY REDO.EACH.TRANS.DETAILS.ENQ
*
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.EACH.TRANS.DETAILS.ENQ
* In Parameter : N/A
* Out Parameter : N/A
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   21-03-2011       DHAMU S          ODR-2011-03-0113 22&20       Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.STANDING.ORDER
$INSERT I_F.TELLER.ID
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.FT.HIS
$INSERT I_F.REDO.TT.HIS

  GOSUB OPEN
  GOSUB GET.LOCAL.REF
  GOSUB CHECK.LOCATE
  GOSUB BUILD.SEL.CMD
  GOSUB PROCESS
  GOSUB FORM.STRING
  GOSUB FINAL.STRING

  RETURN

******
OPEN:
*****

  Y.DATE = '' ; Y.INPUTTER = ''; Y.COMPANY.NAME = ''; Y.TRANSACTION.TYPE = ''; Y.FROM = ''; Y.TO = '';
  Y.AGENCY = '' ; Y.FROM.DATE = '' ;Y.TO.DATE = '' ; Y.FT.STMT.ENTRY.NOS = '' ;Y.STMT.ID.BASE = ''; Y.TILL = '';
  Y.CNTR = '' ; Y.TT.STMT.ENTRY.NOS = '' ;
  Y.TXN.TYPE = '' ; Y.COMPANY.CODE = '' ;

  FN.TELLER = 'F.TELLER'
  F.TELLER = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID  = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  FN.REDO.FT.HIS = 'F.REDO.FT.HIS'
  F.REDO.FT.HIS  = ''
  CALL OPF(FN.REDO.FT.HIS,F.REDO.FT.HIS)

  FN.REDO.TT.HIS = 'F.REDO.TT.HIS'
  F.REDO.TT.HIS  = ''
  CALL OPF(FN.REDO.TT.HIS,F.REDO.TT.HIS)

  FN.FUNDS.TRANSFER$HIS = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER$HIS = ''
  CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.TELLER$HIS  = 'F.TELLER$HIS'
  F.TELLER$HIS  = ''
  CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)

  FN.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
  F.TXN.TYPE.CONDITION = ''
  CALL OPF(FN.TXN.TYPE.CONDITION,F.TXN.TYPE.CONDITION)

  FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
  F.TELLER.TRANSACTION  = ''
  CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

  FN.STANDING.ORDER  = 'F.STANDING.ORDER'
  F.STANDING.ORDER  = ''
  CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.STANDING.ORDER$HIS = 'F.STANDING.ORDER'
  F.STANDING.ORDER$HIS  = ''
  CALL OPF(FN.STANDING.ORDER$HIS,F.STANDING.ORDER$HIS)

  RETURN

***************
GET.LOCAL.REF:
***************
  APL.ARRAY = 'FT.TXN.TYPE.CONDITION':FM:'TELLER.TRANSACTION':FM:'FUNDS.TRANSFER':FM:'TELLER'
  APL.FIELD = 'L.FTTC.CHANNELS':FM:'L.TT.PAY.TYPE':FM:'L.FT.CR.ACCT.NO':VM:'L.TP.BILL.NUM':VM:'L.FT.CMPNY.NAME':FM:'L.TT.BILL.NUM':VM:'L.TT.CMPNY.NAME'
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
  LOC.L.FTTC.CHANNELS.POS = FLD.POS<1,1>
  LOC.L.TT.PAY.TYPE.POS   = FLD.POS<2,1>
  LOC.L.FT.CR.ACCT.NO.POS = FLD.POS<3,1>
  LOC.L.FT.BILL.NUM.POS   = FLD.POS<3,2>
  LOC.L.FT.CMPNY.NAME.POS = FLD.POS<3,3>
  LOC.L.TT.BILL.NUM.POS   = FLD.POS<4,1>
  LOC.L.TT.CMPNY.NAME.POS = FLD.POS<4,2>

  RETURN

************
CHECK.LOCATE:
*************
  LOCATE "TXN.DATE" IN D.FIELDS<1> SETTING DATE.POS THEN
    Y.DATE = D.RANGE.AND.VALUE<DATE.POS>
    IF Y.DATE THEN
      GOSUB CHECK.DATE
    END
  END
  LOCATE "TXN.USER" IN D.FIELDS<1> SETTING INPUTTER.POS THEN
    Y.INPUTTER = D.RANGE.AND.VALUE<INPUTTER.POS>
  END
  LOCATE "COMPANY.NAME" IN D.FIELDS<1> SETTING COMPANY.POS THEN
    Y.COMPANY.NAME  = D.RANGE.AND.VALUE<COMPANY.POS>
  END
  LOCATE "TXN.TYPE" IN D.FIELDS<1> SETTING TRANSACTION.POS THEN
    Y.TRANSACTION.TYPE = D.RANGE.AND.VALUE<TRANSACTION.POS>
  END
  LOCATE "AGENCY" IN D.FIELDS<1> SETTING AGENCY.POS THEN
    Y.AGENCY = D.RANGE.AND.VALUE<AGENCY.POS>
  END

  RETURN

***********
CHECK.DATE:
***********
  Y.FROM.DATE = FIELD(Y.DATE,SM,1)
  Y.TO.DATE   = FIELD(Y.DATE,SM,2)
  IF NOT(NUM(Y.FROM.DATE)) OR LEN(Y.FROM.DATE) NE '8' OR NOT(NUM(Y.TO.DATE)) OR LEN(Y.TO.DATE) NE '8' THEN
    ENQ.ERROR = 'EB-REDO.DATE.RANGE'
  END ELSE
    IF Y.FROM.DATE[5,2] GT '12' OR Y.TO.DATE[5,2] GT '12' OR Y.FROM.DATE[7,2] GT '31' OR Y.TO.DATE[7,2] GT '31' OR Y.FROM.DATE GT Y.TO.DATE THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'
    END ELSE
      GOSUB DATE.CHECK
    END
  END
  RETURN

***********
DATE.CHECK:
***********

  Y.F.DATE = Y.FROM.DATE[3,6]:"0000"
  Y.T.DATE = Y.TO.DATE[3,6]:"2359"

  RETURN
**************
BUILD.SEL.CMD:
**************
  IF Y.F.DATE AND Y.T.DATE THEN
    SEL.CMD.FT =" SELECT ":FN.REDO.FT.HIS:" WITH DATE.TIME GE ":Y.F.DATE:" AND DATE.TIME LE ":Y.T.DATE
    SEL.CMD.TT =" SELECT ":FN.REDO.TT.HIS:" WITH DATE.TIME GE ":Y.F.DATE:" AND DATE.TIME LE ":Y.T.DATE
  END
  IF Y.INPUTTER THEN
    SEL.CMD.FT :=" AND INPUTTER LIKE ...":Y.INPUTTER:"..."
    SEL.CMD.TT :=" AND INPUTTER LIKE ...":Y.INPUTTER:"..."
  END
  IF Y.COMPANY.NAME THEN
    SEL.CMD.FT :=" AND L.FT.CMPNY.NAME EQ ":Y.COMPANY.NAME
    SEL.CMD.TT :=" AND L.TT.CMPNY.NAME EQ ":Y.COMPANY.NAME
  END
  IF Y.AGENCY THEN
    SEL.CMD.FT :=" AND CO.CODE EQ ":Y.AGENCY
    SEL.CMD.TT :=" AND CO.CODE EQ ":Y.AGENCY
  END
  IF Y.TRANSACTION.TYPE THEN
    SEL.CMD.FT :=" AND TRANSACTION.TYPE EQ ":Y.TRANSACTION.TYPE
    SEL.CMD.TT :=" AND TRANSACTION.CODE EQ ":Y.TRANSACTION.TYPE
  END
  SEL.CMD.FT :=" BY DATE.OF.TXN BY DEBIT.CURRENCY BY TRANSACTION.TYPE"
  SEL.CMD.TT :=" BY DATE.OF.TXN BY CURRENCY.1 BY TRANSACTION.CODE "

  RETURN


********
PROCESS:
********
  CALL EB.READLIST(SEL.CMD.FT,SEL.LIST1,'',NO.OF.REC1,REC1.ERR)
  CALL EB.READLIST(SEL.CMD.TT,SEL.LIST2,'',NO.OF.REC2,REC2.ERR)

  IF SEL.LIST1 THEN
    GOSUB CHECK.FUNDS.TRANSFER
  END
  IF SEL.LIST2 THEN
    GOSUB CHECK.TELLER
  END

  RETURN

*********************
CHECK.FUNDS.TRANSFER:
*********************
  LOOP
    REMOVE Y.SEL.ID FROM SEL.LIST1 SETTING FT.POS
  WHILE Y.SEL.ID:FT.POS
    CALL F.READ(FN.FUNDS.TRANSFER,Y.SEL.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    Y.ERR.FLAG = ''
    Y.FT.ERR.FLAG = ''
    IF R.FUNDS.TRANSFER EQ '' THEN
      Y.SEL.ID.HIS = Y.SEL.ID:";1"
      CALL F.READ(FN.FUNDS.TRANSFER$HIS,Y.SEL.ID.HIS,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER$HIS,FUND.ERR)
    END
    IF R.FUNDS.TRANSFER NE '' THEN
      Y.DATE = R.FUNDS.TRANSFER<FT.DATE.TIME>
      Y.DATE = Y.DATE[1,6]
      Y.DATE.TIME = TODAY[1,2]:Y.DATE
      Y.TRANS.TYPE  = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
      CALL F.READ(FN.TXN.TYPE.CONDITION,Y.TRANS.TYPE,R.TXN.TYPE.CONDITION,F.TXN.TYPE.CONDITION,CONDITION.ERR)
      Y.TXN.TYPE = R.TXN.TYPE.CONDITION<FT6.DESCRIPTION,1>
      Y.ID  = Y.SEL.ID
      Y.DEBIT.ACCOUNT  = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
      Y.DEBIT.CURRENCY = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
      CHK.CCY = Y.DEBIT.CURRENCY
      GOSUB CHECK.STO.AMOUNT
      IF Y.DEBIT.AMOUNT.STO EQ '' THEN
        GOSUB CHECK.PMT.AMOUNT
      END
      Y.TT.AMOUNT = ''
      GOSUB CHECK.BENEFICIARY.ACCT.NUM
      GOSUB CHECK.BENEFICIARY.NAME
      IF Y.DEBIT.AMOUNT.STO NE '' OR Y.DEBIT.AMOUNT.PMT NE '' THEN
        GOSUB GET.TOTAL.VALUES
      END
      Y.INPUTTER = FIELD(R.FUNDS.TRANSFER<FT.INPUTTER>,"_",2)
      Y.CO.CODE = R.FUNDS.TRANSFER<FT.CO.CODE>
      IF Y.DEBIT.AMOUNT.STO NE '' OR Y.DEBIT.AMOUNT.PMT NE '' THEN
        GOSUB FINAL.ARRAY
      END
      Y.DEBIT.AMOUNT.PMT = '' ; Y.DEBIT.AMOUNT.STO = ''
    END
  REPEAT
  RETURN

***********************
CHECK.BENEFICIARY.NAME:
***********************
  INWARD.PAY.TYPE = R.FUNDS.TRANSFER<FT.INWARD.PAY.TYPE>
  STO.ID          = FIELD(INWARD.PAY.TYPE,'-',3,2)
  CHANGE '-' TO '.' IN STO.ID
  CALL F.READ(FN.STANDING.ORDER,STO.ID,R.STANDING.ORDER,F.STANDING.ORDER,ORDER.ERR)
  IF R.STANDING.ORDER EQ '' THEN
    CALL F.READ(FN.STANDING.ORDER$HIS,STO.ID,R.STANDING.ORDER,F.STANDING.ORDER$HIS,ORDER.ERR1)
  END
  Y.CUSTOMER.ID     = R.STANDING.ORDER<STO.CREDIT.CUSTOMER>
  CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
  Y.DEBIT.CUSTOMER = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
  IF Y.DEBIT.CUSTOMER EQ '' THEN
    Y.DEBIT.CUSTOMER = R.STANDING.ORDER<STO.BENEFICIARY>
  END
  IF Y.DEBIT.CUSTOMER  EQ '' THEN
    Y.DEBIT.CUSTOMER = R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.L.FT.CMPNY.NAME.POS>
  END
  RETURN

***************************
CHECK.BENEFICIARY.ACCT.NUM:
***************************
  Y.BENEFICIARY.ACCT.NUM     = R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.L.FT.CR.ACCT.NO.POS>
  IF Y.BENEFICIARY.ACCT.NUM EQ '' THEN
    Y.BENEFICIARY.ACCT.NUM = R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.L.FT.BILL.NUM.POS>
  END
  IF Y.BENEFICIARY.ACCT.NUM EQ '' THEN
    Y.BENEFICIARY.ACCT.NUM = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
  END
  RETURN
******************
CHECK.PMT.AMOUNT:
******************
  Y.USER = FIELD(R.FUNDS.TRANSFER<FT.INPUTTER>,"_",2)
  SEL.TT.ID = "SELECT ":FN.TELLER.ID:" WITH USER EQ ":Y.USER
  CALL EB.READLIST(SEL.TT.ID,SEL.TT.ID.LIST,'',NO.TT.ID,TT.ID.ERR)
  IF SEL.TT.ID.LIST EQ '' THEN
    Y.FTTC.CHANNELS        = R.TXN.TYPE.CONDITION<FT6.LOCAL.REF,LOC.L.FTTC.CHANNELS.POS>
    IF Y.FTTC.CHANNELS EQ 'PMT' THEN
      Y.DEBIT.AMOUNT.PMT = R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>[4,LEN(R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>)]
      Y.DEBIT.AMOUNT.PMT.FMT  = FMT(Y.DEBIT.AMOUNT.PMT,"R2,#19")
      Y.DEBIT.COUNT.PMT = 0
      Y.DEBIT.COUNT.PMT  += 1
    END ELSE
      Y.DEBIT.AMOUNT.PMT = ''
    END
  END ELSE
    Y.DEBIT.AMOUNT.PMT = ''
  END

  RETURN

*****************
CHECK.STO.AMOUNT:
****************
  Y.INWARD.PAY.TYPE      = R.FUNDS.TRANSFER<FT.INWARD.PAY.TYPE>
  Y.PAY.TYPE             = FIELD(Y.INWARD.PAY.TYPE,"-",1)
  IF Y.PAY.TYPE EQ "STO" THEN
    Y.DEBIT.AMOUNT.STO = R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>[4,LEN(R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>)]
    Y.DEBIT.AMOUNT.STO.FMT  = FMT(Y.DEBIT.AMOUNT.STO,"R2,#19")
    Y.DEBIT.COUNT.STO = 0
    Y.DEBIT.COUNT.STO  += 1
  END ELSE
    Y.DEBIT.AMOUNT.STO = ''
  END
  RETURN

*************
CHECK.TELLER:
*************
  LOOP
    REMOVE Y.SEL.ID FROM SEL.LIST2 SETTING TT.POS
  WHILE Y.SEL.ID:TT.POS
    CALL F.READ(FN.TELLER,Y.SEL.ID,R.TELLER,F.TELLER,TELLER.ERR)
    IF R.TELLER EQ '' THEN
      Y.SEL.ID.HIS = Y.SEL.ID:";1"
      CALL F.READ(FN.TELLER$HIS,Y.SEL.ID.HIS,R.TELLER,F.TELLER$HIS,TELL.ERR)
    END
    IF R.TELLER NE '' THEN
      Y.DATE           = R.TELLER<TT.TE.DATE.TIME>
      Y.DATE           = Y.DATE[1,6]
      Y.DATE.TIME      = TODAY[1,2]:Y.DATE
      Y.CO.CODE        = R.TELLER<TT.TE.CO.CODE>
      Y.TRANS.CODE     = R.TELLER<TT.TE.TRANSACTION.CODE>
      CALL F.READ(FN.TELLER.TRANSACTION,Y.TRANS.CODE,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,TELL.TRANS.ERR)
      Y.TXN.TYPE         = R.TELLER.TRANSACTION<TT.TR.DESC,1,1>
      Y.ID = Y.SEL.ID
      Y.DEBIT.ACCOUNT    = R.TELLER<TT.TE.ACCOUNT.1>
      Y.DEBIT.CURRENCY   = R.TELLER<TT.TE.CURRENCY.1>
      Y.DEBIT.AMOUNT.PMT = ''
      Y.DEBIT.AMOUNT.STO = ''
      CHK.CCY = Y.DEBIT.CURRENCY
      Y.TT.PAY.TYPE = R.TELLER.TRANSACTION<TT.TR.LOCAL.REF,LOC.L.TT.PAY.TYPE.POS>
      GOSUB CHECK.TT.AMOUNT
      IF Y.TT.AMOUNT NE '' THEN
        GOSUB GET.TOTAL.VALUES
      END
      Y.BENEFICIARY.ACCT.NUM =  R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.BILL.NUM.POS>
      Y.DEBIT.CUSTOMER       =  R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>
      Y.INPUTTER             = FIELD(R.TELLER<TT.TE.INPUTTER>,"_",2)
      IF Y.TT.AMOUNT NE '' THEN
        GOSUB FINAL.ARRAY
      END
      Y.TT.AMOUNT = ''
    END
  REPEAT
  RETURN

****************
CHECK.TT.AMOUNT:
****************
  IF Y.TT.PAY.TYPE EQ '7' THEN
    Y.TT.AMOUNT = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    Y.TT.AMOUNT.FMT  = FMT(Y.TT.AMOUNT,"R2,#19")
    IF R.TELLER<TT.TE.AMOUNT.LOCAL.1> EQ '' THEN
      Y.TT.AMOUNT = R.TELLER<TT.TE.AMOUNT.FCY.1>
      Y.TT.AMOUNT.FMT  = FMT(Y.TT.AMOUNT,"R2,#19")
    END
    Y.TT.COUNT = 0
    Y.TT.COUNT += 1
  END ELSE
    Y.TT.AMOUNT = ''
  END

  RETURN

*****************
GET.TOTAL.VALUES:
*****************
  LOCATE CHK.CCY IN Y.CUR<1,1> SETTING CUR.POS THEN
    FIN.AMT.PMT<1,CUR.POS>   += Y.DEBIT.AMOUNT.PMT
    FIN.PMT.COUNT<1,CUR.POS> += Y.DEBIT.COUNT.PMT
    FIN.AMT.STO<1,CUR.POS>   += Y.DEBIT.AMOUNT.STO
    FIN.STO.COUNT<1,CUR.POS> += Y.DEBIT.COUNT.STO
    FIN.AMT.TT<1,CUR.POS>    += Y.TT.AMOUNT
    FIN.TT.COUNT<1,CUR.POS>  += Y.TT.COUNT
  END ELSE
    Y.CUR<1,-1>               = CHK.CCY
    FIN.AMT.PMT<1,-1>         = Y.DEBIT.AMOUNT.PMT
    IF Y.DEBIT.AMOUNT.PMT NE '' THEN
      Y.DEBIT.AMOUNT.STO = ' '
    END
    FIN.AMT.STO<1,-1>         = Y.DEBIT.AMOUNT.STO
    FIN.PMT.COUNT<1,-1>       = Y.DEBIT.COUNT.PMT
    IF Y.DEBIT.COUNT.PMT NE '' THEN
      Y.DEBIT.COUNT.STO = ' '
    END
    FIN.STO.COUNT<1,-1>       = Y.DEBIT.COUNT.STO
    IF Y.DEBIT.AMOUNT.PMT OR Y.DEBIT.AMOUNT.STO NE '' THEN
      Y.TT.AMOUNT = ' '
    END
    FIN.AMT.TT<1,-1>          = Y.TT.AMOUNT
    IF Y.DEBIT.COUNT.PMT OR Y.DEBIT.COUNT.STO NE '' THEN
      Y.TT.COUNT = ' '
    END
    FIN.TT.COUNT<1,-1>        = Y.TT.COUNT
  END
  Y.DEBIT.COUNT.PMT = '' ; Y.DEBIT.COUNT.STO = '' ; Y.TT.COUNT = '' ;

  RETURN

************
FORM.STRING:
************
  Y.COUNT = DCOUNT(Y.CUR,VM)
  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE Y.COUNT
    Y.DEBIT.CURRENCY = Y.CUR<1,Y.CNT>
    Y.DEBIT.AMOUNT.PMT      = FIN.AMT.PMT<1,Y.CNT>
    Y.DEBIT.AMOUNT.STO      = FIN.AMT.STO<1,Y.CNT>
    Y.TT.AMOUNT             = FIN.AMT.TT<1,Y.CNT>
    Y.DEBIT.AMOUNT.PMT.FMT  = FMT(Y.DEBIT.AMOUNT.PMT,"R2,#19")
    Y.DEBIT.AMOUNT.STO.FMT  = FMT(Y.DEBIT.AMOUNT.STO,"R2,#19")
    Y.TT.AMOUNT.FMT         = FMT(Y.TT.AMOUNT,"R2,#19")
    Y.FINAL.ARR<-1> = 'TOTAL':"*":'':"*":'':"*":'':"*":Y.DEBIT.CURRENCY:"*":Y.DEBIT.AMOUNT.PMT.FMT:"*":Y.DEBIT.AMOUNT.STO.FMT:"*":Y.TT.AMOUNT.FMT
    Y.DEBIT.CURRENCY = '' ; Y.DEBIT.AMOUNT.PMT = ''; Y.DEBIT.AMOUNT.STO = '' ; Y.TT.AMOUNT = ''
    Y.DEBIT.AMOUNT.PMT = FIN.PMT.COUNT<1,Y.CNT>
    Y.DEBIT.AMOUNT.STO = FIN.STO.COUNT<1,Y.CNT>
    Y.TT.AMOUNT        = FIN.TT.COUNT<1,Y.CNT>
    Y.FINAL.COUNT.PMT += FIN.PMT.COUNT<1,Y.CNT>
    Y.FINAL.COUNT.STO += FIN.STO.COUNT<1,Y.CNT>
    Y.FINAL.COUNT.TT  += FIN.TT.COUNT<1,Y.CNT>
    Y.FINAL.ARR<-1> = 'CANTIDAD':"*":'':"*":'':"*":'':"*":'':"*":Y.DEBIT.AMOUNT.PMT:"*":Y.DEBIT.AMOUNT.STO:"*":Y.TT.AMOUNT
    Y.CNT = Y.CNT + 1
  REPEAT

  RETURN
*************
FINAL.STRING:
**************
  Y.TOTAL.REC = Y.FINAL.COUNT.PMT + Y.FINAL.COUNT.STO + Y.FINAL.COUNT.TT
  IF Y.TOTAL.REC THEN
    Y.FINAL.ARR<-1> = 'CANTIDAD TOTAL':"*":'':"*":Y.TOTAL.REC:"*":'':"*":'':"*":Y.FINAL.COUNT.PMT:"*":Y.FINAL.COUNT.STO:"*":Y.FINAL.COUNT.TT
  END
  RETURN
************
FINAL.ARRAY:
************
  Y.FINAL.ARR<-1> = Y.DATE.TIME:"*":Y.TXN.TYPE:"*":Y.ID:"*":Y.DEBIT.ACCOUNT:"*":Y.DEBIT.CURRENCY:"*":Y.DEBIT.AMOUNT.PMT.FMT:"*":Y.DEBIT.AMOUNT.STO.FMT:"*":Y.TT.AMOUNT.FMT:"*":Y.BENEFICIARY.ACCT.NUM:"*":Y.DEBIT.CUSTOMER:"*":Y.INPUTTER:"*":Y.CO.CODE
*                         1               2            3            4                   5                      6                     7                     8                     9                    10                   11           12
  Y.DEBIT.AMOUNT.PMT.FMT = '' ; Y.DEBIT.AMOUNT.STO.FMT = '' ; Y.TT.AMOUNT.FMT = ''
  RETURN
END
