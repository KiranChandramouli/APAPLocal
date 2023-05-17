*-----------------------------------------------------------------------------------------------------------------
* <Rating>-97</Rating>
*-------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.NOF.INV.REINV.94(DATA.RETURN)
*-----------------------------------------------------------------------------
*   R o u t i n e   D e s c r i p t i o n :
*   ---------------------------------------
*
*   Below are the selection criteria for the enquiry
*   (1) Date (Range)
*   (2) Agency (Entity)
*   (3) Account Type (Category)
*
*-----------------------------------------------------------------------------
*   M o d i f i c a t i o n  H i s t o r y :
*   ----------------------------------------
*
*   Done By        : Egambaram A
*   Date of Coding : 8 Oct 2014
*
*-----------------------------------------------------------------------------
*   Insert files that are used within the routine

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.STANDARD.SELECTION
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.STMT.ENTRY
$INSERT I_F.REDO.CHEQUE.PROCESS
$INSERT I_F.EB.CONTRACT.BALANCES


  GOSUB INITIALIZE
  GOSUB SELECT.PROCESS
  GOSUB SORT.PROCESS
***
  RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
* File Variable Initialization <STARTS>
* File Names: ACCOUNT/ACCOUNT$HIS,ACCOUNT,CUSTOMER,CATEGORY,LATAM.CARD.CUSTOMER

  FN.ACCOUNT                = 'F.ACCOUNT'
  F.ACCOUNT                 = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT =''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
  F.FUNDS.TRANSFER = ""
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.REDO.CHEQUE.PROCESS = "F.REDO.CHEQUE.PROCESS"
  F.REDO.CHEQUE.PROCESS = ""
  CALL OPF(FN.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS)

  FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
  F.FT.TXN.TYPE.CONDITION = ""
  CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

  FN.FUNDS.TRANSFER.HIS = "F.FUNDS.TRANSFER$HIS"
  F.FUNDS.TRANSFER.HIS = ""
  CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

  FN.STMT.ENTRY = "F.STMT.ENTRY"
  F.STMT.ENTRY = ""
  CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

  DATA.RETURN = '' ; Y.READ.ERR = '' ; Y.SEL.VALUE = '' ; Y.DATE.RG = '' ; Y.AGENCY = '' ; Y.CATEGORY = '' ; Y.CARD.NO   = '' ; FLAG.VAR = ''
  Y.INPUTTER = ""
  Y.AUTHORISER = ""
***
  RETURN
*-----------------------------------------------------------------------------
SELECT.PROCESS:
*-----------------------------------------------------------------------------

* Fetching the selection criteria values here

  LOCATE "VALUE.DATE" IN D.FIELDS<1> SETTING FIELD1.POS THEN
    Y.DATE.RG = D.RANGE.AND.VALUE<FIELD1.POS>
  END

  LOCATE "CATEG.APP" IN D.FIELDS<1> SETTING FIELD2.POS THEN
    Y.CATEG = D.RANGE.AND.VALUE<FIELD2.POS>
  END

  LOCATE "CO.CODE.DDOWN" IN D.FIELDS<1> SETTING FIELD3.POS THEN
    Y.CO.CODE = D.RANGE.AND.VALUE<FIELD3.POS>
  END

  Y.FROM.DATE = '' ; Y.FROM.DATE = FIELD(Y.DATE.RG,SM,1,1)
  Y.TO.DATE   = '' ; Y.TO.DATE   = FIELD(Y.DATE.RG,SM,2,1)

  IF Y.DATE.RG THEN
    IF NOT(NUM(Y.FROM.DATE)) OR LEN(Y.FROM.DATE) NE '8' OR NOT(NUM(Y.TO.DATE)) OR LEN(Y.TO.DATE) NE '8' THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'
    END ELSE
      IF Y.FROM.DATE[5,2] GT '12' OR Y.TO.DATE[5,2] GT '12' OR Y.FROM.DATE[7,2] GT '31' OR Y.TO.DATE[7,2] GT '31' OR Y.TO.DATE GT TODAY OR Y.FROM.DATE GT TODAY OR Y.FROM.DATE GT Y.TO.DATE THEN
        ENQ.ERROR = 'EB-REDO.DATE.RANGE'
      END
    END
  END
*

  SEL.CMD = " SELECT ": FN.AZ.ACCOUNT : " WITH L.TYPE.INT.PAY EQ Reinvested"
  CALL EB.READLIST(SEL.CMD,SEL.AZ.LIST,"",NO.OF.RECS,ERR)
  Y.AZ.ID.POS = ''
  LOOP
    REMOVE Y.AZ.ID FROM SEL.AZ.LIST SETTING Y.AZ.ID.POS
  WHILE Y.AZ.ID:Y.AZ.ID.POS
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    IF R.AZ.ACCOUNT THEN
      Y.INTEREST.LIQU.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
      Y.DATE.TIME = R.AZ.ACCOUNT<AZ.DATE.TIME>
    END
    CALL F.READ(FN.ACCOUNT,Y.INTEREST.LIQU.ACCT,R.ACCOUNT,F.ACCOUNT,AC.ERR)
*TUS START
CALL EB.READ.HVT ("EB.CONTRACT.BALANCES", Y.INTEREST.LIQU.ACCT, R.ECB, ECB.ERR) 
*    Y.CHK.VAL = R.ACCOUNT<AC.AMNT.LAST.DR.CUST>
     LOCATE 'CUST-DR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.DR.POS THEN 
      Y.CHK.VAL = R.ECB<ECB.AMNT.LAST,CUST.DR.POS> 
END 
*TUS END
    IF Y.CHK.VAL NE '' THEN
      GOSUB CHECK.PROCESS
    END
  REPEAT
***
  RETURN
*-----------------------------------------------------------------------------
CHECK.PROCESS:
*-----------------------------------------------------------------------------
  Y.SEL.FROM = Y.FROM.DATE[3,6]:"0000"
  Y.SEL.TO   = Y.TO.DATE[3,6]:"2359"

  IF Y.CATEG THEN
    Y.REC.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
    IF Y.REC.CATEG NE Y.CATEG THEN
      RETURN
    END
  END

  IF Y.CO.CODE THEN
    Y.REC.CO.CODE = R.AZ.ACCOUNT<AZ.CO.CODE>
    IF Y.REC.CO.CODE NE Y.CO.CODE THEN
      RETURN
    END
  END
*
  IF Y.DATE.RG THEN
    SEL.CMD1 = "SELECT " : FN.REDO.CHEQUE.PROCESS : " WITH AZ.ACCOUNT EQ " : Y.AZ.ID : " AND DATE.TIME GE " : Y.SEL.FROM : " AND DATE.TIME LE " : Y.SEL.TO : " BY DATE.TIME "
  END ELSE
    SEL.CMD1 = "SELECT " : FN.REDO.CHEQUE.PROCESS : " WITH AZ.ACCOUNT EQ " : Y.AZ.ID : " BY DATE.TIME "
  END
  CALL EB.READLIST(SEL.CMD1,SEL.LIST1,"",NO.OF.REC1,ERR1)
  IF SEL.LIST1 NE '' THEN
    GOSUB CHEQUE.PROCESS
  END
***
  RETURN
*--------------------------------------------------------------------------------------------------------
CHEQUE.PROCESS:
*==============
  Y.ID.POS = ""
  LOOP
    REMOVE Y.ID FROM SEL.LIST1 SETTING Y.ID.POS
  WHILE Y.ID:Y.ID.POS
    CALL F.READ(FN.REDO.CHEQUE.PROCESS,Y.ID,R.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS,CHQ.ERR)
    Y.DEB.AMT = R.REDO.CHEQUE.PROCESS<CHQ.PRO.DEBIT.AMOUNT>
    Y.TRANS.TYPE = R.REDO.CHEQUE.PROCESS<CHQ.PRO.PAYMENT.TYPE>
    Y.TIME.OUT = R.REDO.CHEQUE.PROCESS<CHQ.PRO.DATE.TIME>
    Y.DATE.DISP = "20":Y.TIME.OUT[1,6]
    GOSUB CHECK.TRANS.DISP
    IF Y.DEB.AMT AND Y.TRANS.TYPE THEN
      Y.DEB.AMT = ABS(Y.DEB.AMT)
      GOSUB INP.AUTH.PROCESS
      GOSUB ARRAY.PROCESS
    END
  REPEAT
***
  RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------
INP.AUTH.PROCESS:
*****************
  YID.LIST = '' ; FROM.DATE = R.ACCOUNT<AC.OPENING.DATE> ; END.DATE = TODAY

  ER = ""
  CALL EB.ACCT.ENTRY.LIST(Y.INTEREST.LIQU.ACCT,FROM.DATE,END.DATE,YID.LIST,OPENING.BAL,ER)
  LOOP
    REMOVE Y.STMT.ID FROM YID.LIST SETTING STMT.POS
  WHILE Y.STMT.ID : STMT.POS
    R.STMT.ENTRY = '' ; ERR.STMT.ENTRY = ''
*Tus Start 
*    READ R.STMT.ENTRY FROM F.STMT.ENTRY,Y.STMT.ID THEN ;
     CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,R.STMT.ENTRY.ERR)
     IF R.STMT.ENTRY THEN  
* Tus End
    END ELSE
      R.STMT.ENTRY = ''
    END
    Y.CHECK.AMOUNT = ABS(R.STMT.ENTRY<AC.STE.AMOUNT.LCY>)
    IF Y.CHECK.AMOUNT EQ Y.DEB.AMT THEN
      Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
      IF Y.TRANS.REF[1,2] EQ 'FT' THEN
        GOSUB FT.PROCESS
      END
    END
  REPEAT
***
  RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------
ARRAY.PROCESS:
**************
  DATA.RETURN<-1> = Y.AZ.ID:"*":Y.DEB.AMT:"*":Y.TRANS.DISP:"*":Y.DATE.DISP:"*":Y.INPUTTER:"*":Y.AUTHORISER
***
  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------
CHECK.TRANS.DISP:
*****************
  BEGIN CASE
  CASE Y.TRANS.TYPE EQ "CASH"
    Y.TRANS.DISP = "EFFECTIVO"
  CASE Y.TRANS.TYPE EQ "TRANSFER"
    Y.TRANS.DISP = "TRANSFERENCIA"
  CASE Y.TRANS.TYPE EQ "GOVT.CHEQUE"
    Y.TRANS.DISP = "CHEQUE ADM.GOBIERNO"
  CASE Y.TRANS.TYPE EQ "GOVT.WITH.TAX"
    Y.TRANS.DISP = "CHEQUE ADM.GOBIERNO CON IMPUESTO"
  CASE 1
    Y.TRANS.DISP = "CHEQUE ADM.OTROS"
  END CASE
***
  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------
FT.PROCESS:
***********
  Y.CHK.AGENCY = FIELD(Y.TRANS.REF,'\',2)
  IF Y.CHK.AGENCY NE '' THEN
    Y.TRANS.REF = FIELD(Y.TRANS.REF,'\',1)
  END ELSE
    Y.TRANS.REF = Y.TRANS.REF
  END

  CALL F.READ(FN.FUNDS.TRANSFER,Y.TRANS.REF,R.FT,F.FUNDS.TRANSFER,R.FT.ERR)
  IF R.FT NE '' THEN
    Y.INPUTTER   = R.FT<FT.INPUTTER>
    Y.INPUTTER   = FIELD(Y.INPUTTER,'_',2)
    Y.AUTHORISER = R.FT<FT.AUTHORISER>
    Y.AUTHORISER = FIELD(Y.AUTHORISER,'_',2)
  END ELSE
    Y.TRANS.REF = Y.TRANS.REF:';1'
    CALL F.READ(FN.FUNDS.TRANSFER.HIS,Y.TRANS.REF,R.FT.HIS,F.FUNDS.TRANSFER.HIS,R.FT.ERR.HIS)
    Y.INPUTTER   = R.FT.HIS<FT.INPUTTER>
    Y.INPUTTER   = FIELD(Y.INPUTTER,'_',2)
    Y.AUTHORISER = R.FT.HIS<FT.AUTHORISER>
    Y.AUTHORISER = FIELD(Y.AUTHORISER,'_',2)
  END
***
  RETURN
*-----------------------------------------------------------------------------------------------------------------
SORT.PROCESS:
*============
  Y.REC.COUNT = DCOUNT(DATA.RETURN,FM)
  Y.REC.START = 1
  LOOP
  WHILE Y.REC.START LE Y.REC.COUNT
    Y.REC = DATA.RETURN<Y.REC.START>
    Y.COMP = FIELD(Y.REC,'*',4)
    Y.SORT.VAL = Y.COMP
    Y.AZ.SORT.VAL<-1> = Y.REC:FM:Y.SORT.VAL
    Y.SORT.ARR<-1>= Y.SORT.VAL
    Y.REC.START += 1
  REPEAT

  Y.SORT.ARR = SORT(Y.SORT.ARR)

  LOOP
    REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
  WHILE Y.ARR.ID : Y.ARR.POS
    LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
      Y.OUT.ARRAY<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
      DEL Y.AZ.SORT.VAL<Y.FM.POS>
      DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
    END
  REPEAT

  DATA.RETURN = Y.OUT.ARRAY
*-----------------------------------------------------------------------------------------------------------------
END
