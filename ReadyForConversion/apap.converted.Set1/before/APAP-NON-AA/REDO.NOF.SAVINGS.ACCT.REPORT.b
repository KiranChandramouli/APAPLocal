*-----------------------------------------------------------------------------
* <Rating>-26</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.SAVINGS.ACCT.REPORT(Y.FINAL.ARRAY)
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Sakthi Sellappillai
*Program Name      : REDO.NOF.SAVINGS.ACCT.REPORT
*Developed for     : ODR-2010-08-0173
*Date              : 13.12.2010
*------------------------------------------------------------------------------------------------------------------
*Description:This is No File Enquiry routine.This will select the live file ACCOUNT records,
* and fetch the values from the selected CATEGORY records for ENQUIRY-REDO.APAP.ENQ.S.ACCT.LIST.DYN.RPT
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
*-------------
* Linked with : NOFILE.REDO.SAVINGS.ACCT.REPORT - Standard Selection of REDO.APAP.ENQ.S.ACCT.LIST.DYN.RPT(ENQUIRY)
* Calls       : --N/A--
* Called By   : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name                         Reference                    Version
* -------           ----                         ----------                   --------
* 13.12.2010       Sakthi Sellappillai           ODR-2010-08-0173             Initial Version
* 31.03.2015       Ashokkumar                    PACS00313073                 Fix for PACS00313073
*------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.LATAM.CARD.CUSTOMER
$INSERT I_F.ACCOUNT.CLASS
*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

  GOSUB MAIN.PARA
  GOSUB GOEND
  RETURN
*------------------------------------------------------------------------------------------------------------------
MAIN.PARA:
*------------------------------------------------------------------------------------------------------------------

  GOSUB INITIALISE.PARA
  GOSUB LOCATE.PARA
  GOSUB PROCESS.LIVE.PARA
  GOSUB PROCESS.HIS.PARA
  GOSUB FORM.CATEG.FINAL.ARRAY
  GOSUB GOEND
  RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE.PARA:
*------------------------------------------------------------------------------------------------------------------
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  R.ACCOUNT.REC = ''
  Y.ACCOUNT.LIVE.ERR = ''
  FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
  F.ACCOUNT$HIS = ''
  CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
  R.ACCOUNT.HIS.REC = ''
  Y.ACCOUNT.HIS.ERR = ''
  FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
  F.ACCOUNT.CLOSED = ''
  CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)
  FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
  F.ACCOUNT.CLASS = ''
  CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

  R.ACCOUNT.CLOSED.REC = ''
  Y.ACCOUNT.CLOSED.ERR = ''
  FN.CATEGORY = 'F.CATEGORY'
  F.CATEGORY = ''
  CALL OPF(FN.CATEGORY,F.CATEGORY)
  R.CATEGORY.REC = ''
  Y.CATEG.ERR = ''
  FN.CARD.ISSUE.ACCOUNT = 'F.CARD.ISSUE.ACCOUNT'
  F.CARD.ISSUE.ACCOUNT = ''
  CALL OPF(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)
  FN.LATAM.CARD.CUSTOMER = 'F.LATAM.CARD.CUSTOMER'
  F.LATAM.CARD.CUSTOMER = ''
  CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)
  R.CARD.ISSUE.ACCOUNT.REC = ''
  Y.CARE.ISS.AC.ERR = ''
  Y.TOT.LIVE.SAV.AC.SEL.ERR = ''
  Y.TOT.HIS.SAV.AC.SEL.ERR = ''
  Y.TOT.LIVE.SAV.AC.SEL.ERR = ''
  Y.TOT.LIVE.SAV.ACCTS = ''
  Y.DATA = ''
  Y.CUSTOMER.VAL = ''
  Y.CURRENCY.VAL = ''
  Y.ACCOUNT.OFFICER.VAL = ''
  Y.TOTAL.BALANCE.VAL = ''
  Y.ONLINE.ACT.BAL = ''
  Y.ONLINE.CLEAR.BAL = ''
  Y.BALANCE.IN.TRANSIT.VAL = ''
  Y.ACCRED.INT.DATE.VAL = ''
  Y.NOTICE.VAL = ''
  Y.AGENCY.VAL = ''
  Y.OPENING.DATE.VAL = ''
  Y.AVAIL.BAL.VAL = ''
  Y.CLOSING.DATE.VAL = ''
  Y.DEBIT.CARD.NUM.VAL = ''
  Y.TYPE.ACCOUNT.VAL =''
  Y.AC.SORT.VAL = ''
  Y.SORT.ARR =''
  RETURN
*------------------------------------------------------------------------------------------------------------------
LOCATE.PARA:
*------------------------------------------------------------------------------------------------------------------
  Y.ACC.CLASS.ID = 'SAVINGS'
  CALL F.READ(FN.ACCOUNT.CLASS,Y.ACC.CLASS.ID,R.ACCT.CLASS,F.ACCOUNT.CLASS,ACCT.CLASS.ERR)
  Y.SAVINGS.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
  Y.SAVINGS.CATEG = SORT(Y.SAVINGS.CATEG)
  LOCATE 'CATEGORY' IN D.FIELDS SETTING Y.SEL.SAV.ACCT.POS THEN
    Y.SEL.SAV.ACCT.VALUE = D.RANGE.AND.VALUE<Y.SEL.SAV.ACCT.POS>
  END ELSE
    Y.SEL.SAV.ACCT.VALUE = ''
  END
  IF Y.SEL.SAV.ACCT.VALUE THEN
    Y.ACCT.LIVE.SEL.CMD ="SELECT ": FN.ACCOUNT:" WITH CATEGORY EQ ": Y.SEL.SAV.ACCT.VALUE
    Y.ACCT.LIVE.SEL.CMD := " BY CATEGORY BY CURRENCY"
    CALL EB.READLIST(Y.ACCT.LIVE.SEL.CMD,Y.TOT.LIVE.SAV.ACCT.SEL.LIST,'',Y.NO.OF.LIVE.SAV.AC,Y.TOT.LIVE.SAV.AC.SEL.ERR)
    IF Y.TOT.LIVE.SAV.ACCT.SEL.LIST THEN
      Y.TOT.LIVE.SAV.ACCTS = Y.TOT.LIVE.SAV.ACCT.SEL.LIST
    END
  END ELSE
    GOSUB FETCH.CATEG.RANGE

    Y.ACCT.LIVE.SEL.CMD ="SELECT ": FN.ACCOUNT:" WITH CATEGORY GE ":FROM.CATEG:" AND CATEGORY LE ":TO.CATEG:
    Y.ACCT.LIVE.SEL.CMD := " BY CATEGORY BY CURRENCY"
    CALL EB.READLIST(Y.ACCT.LIVE.SEL.CMD,Y.TOT.LIVE.SAV.ACCT.SEL.LIST,'',Y.NO.OF.LIVE.SAV.AC,Y.TOT.LIVE.SAV.AC.SEL.ERR)
    IF Y.TOT.LIVE.SAV.ACCT.SEL.LIST THEN
      Y.TOT.LIVE.SAV.ACCTS = Y.TOT.LIVE.SAV.ACCT.SEL.LIST
    END
  END
  Y.ACCT.HIS.SEL.CMD ="SELECT ": FN.ACCOUNT.CLOSED:" WITH @ID UNLIKE DOP... AND WITH @ID UNLIKE USD..."
  CALL EB.READLIST(Y.ACCT.HIS.SEL.CMD,Y.TOT.HIS.SAV.ACCT.SEL.LIST,'',Y.NO.OF.HIS.SAV.AC,Y.TOT.HIS.SAV.AC.SEL.ERR)
  IF Y.TOT.HIS.SAV.ACCT.SEL.LIST THEN
    Y.TOT.HIS.ACCTS = Y.TOT.HIS.SAV.ACCT.SEL.LIST
  END

  APPL.ARRAY = "ACCOUNT"
  FIELD.ARRAY = "L.AC.NOTIFY.1":VM:"L.AC.AV.BAL":VM:"L.AC.TRAN.AVAIL"
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
  Y.LOC.AC.NOTIFY.POS = FIELD.POS<1,1>
  Y.LOC.AC.AVAIL.BAL.POS = FIELD.POS<1,2>
  Y.LOC.AC.TRAN.AVAIL = FIELD.POS<1,3>
*------------------------------------------------------------------------------------------------------------------
PROCESS.LIVE.PARA:
*------------------------------------------------------------------------------------------------------------------
  Y.TOT.LIVE.SAV.ACCT.CNT = DCOUNT(Y.TOT.LIVE.SAV.ACCTS,FM)
  Y.SAV.ACCT.INIT = 1
  IF NOT(Y.TOT.LIVE.SAV.ACCT.CNT) THEN
    RETURN
  END
  LOOP
    REMOVE Y.LIVE.SAV.ACCT.ID FROM Y.TOT.LIVE.SAV.ACCTS SETTING Y.LIVE.SAV.ACCT.POS
  WHILE Y.SAV.ACCT.INIT LE Y.TOT.LIVE.SAV.ACCT.CNT
    INVAL.CATEG.FLAG = ''
    Y.TYPE.ACCOUNT.VAL = ''

    CALL F.READ(FN.ACCOUNT,Y.LIVE.SAV.ACCT.ID,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCOUNT.LIVE.ERR)
    IF NOT(Y.ACCOUNT.LIVE.ERR) THEN
      Y.ACCOUNT.CATEG.VAL = R.ACCOUNT.REC<AC.CATEGORY>
    END

    LOCATE Y.ACCOUNT.CATEG.VAL IN Y.SAVINGS.CATEG SETTING CATEG.POS ELSE
      INVAL.CATEG.FLAG =  1
    END
    IF INVAL.CATEG.FLAG NE '1' THEN
      GOSUB LIVE.ACCT.SUB.PROCESS
      IF Y.TYPE.ACCOUNT.VAL THEN
        GOSUB FORM.FINAL.ARRAY
      END
    END
    Y.SAV.ACCT.INIT++
  REPEAT
  RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.HIS.PARA:
*------------------------------------------------------------------------------------------------------------------
  Y.TOT.HIS.ACCT.CNT = DCOUNT(Y.TOT.HIS.ACCTS,FM)
  Y.HIS.ACCT.INIT = 1
  LOOP
    REMOVE Y.HIS.ACCT.ID FROM Y.TOT.HIS.ACCTS SETTING Y.HIS.ACCT.POS
  WHILE Y.HIS.ACCT.INIT LE Y.TOT.HIS.ACCT.CNT
*Y.HIS.SAV.ACCT.ID = ''
    Y.HIS.SAV.ACCT.ID = Y.HIS.ACCT.ID
*IF Y.HIS.ACCT.ID EQ '1010021877' THEN DEBUG

    INVAL.CATEG.FLAG = ''
    CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.SAV.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
    IF NOT(Y.ACCOUNT.HIS.ERR) THEN
      Y.ACCOUNT.CATEG.VAL = R.ACCOUNT.HIS.REC<AC.CATEGORY>
    END

    LOCATE Y.ACCOUNT.CATEG.VAL IN Y.SAVINGS.CATEG SETTING CATEG.POS ELSE
      INVAL.CATEG.FLAG =  1
    END
    IF INVAL.CATEG.FLAG NE '1' THEN

      IF NUM(Y.HIS.ACCT.ID) THEN
        Y.HIS.SAV.ACCT.ID = Y.HIS.ACCT.ID
        Y.TYPE.ACCOUNT.VAL = ''
        GOSUB HIS.ACCT.SUB.PROCESS
        IF Y.TYPE.ACCOUNT.VAL THEN
          GOSUB FORM.FINAL.ARRAY
        END
*Y.HIS.ACCT.INIT++
      END ELSE
        Y.HIS.SAV.ACCT.ID = ''
*Y.HIS.ACCT.INIT++
        CONTINUE
      END
    END
    Y.HIS.ACCT.INIT++
  REPEAT
  RETURN
*------------------------------------------------------------------------------------------------------------------
LIVE.ACCT.SUB.PROCESS:
*------------------------------------------------------------------------------------------------------------------
  CALL F.READ(FN.ACCOUNT,Y.LIVE.SAV.ACCT.ID,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCOUNT.LIVE.ERR)
  R.ECB='' ; ECB.ERR='' ;*Tus Start
  CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.LIVE.SAV.ACCT.ID,R.ECB,ECB.ERR);*Tus End
  IF NOT(Y.ACCOUNT.LIVE.ERR) THEN
    Y.ACCOUNT.CATEG.VAL = R.ACCOUNT.REC<AC.CATEGORY>

    CALL F.READ(FN.CATEGORY,Y.ACCOUNT.CATEG.VAL,R.CATEGORY.REC,F.CATEGORY,Y.CATEG.ERR)
    IF NOT(Y.CATEG.ERR) THEN
      Y.CATEGORY = Y.ACCOUNT.CATEG.VAL
      Y.TYPE.ACCOUNT.VAL = R.CATEGORY.REC<EB.CAT.DESCRIPTION>
      CHANGE '*' TO '' IN Y.TYPE.ACCOUNT.VAL
    END
    ALT.ID.POS = ''
    Y.ACCOUNT.ALT.TYPE = R.ACCOUNT.REC<AC.ALT.ACCT.TYPE>
    Y.ACCOUNT.ALT.IDS = R.ACCOUNT.REC<AC.ALT.ACCT.ID>
    CHANGE VM TO FM IN Y.ACCOUNT.ALT.TYPE

    LOCATE 'ALTERNO1' IN Y.ACCOUNT.ALT.TYPE SETTING ALT.ID.POS THEN
      Y.ACCOUNT.ALT.ID = Y.ACCOUNT.ALT.IDS<1,ALT.ID.POS>
    END

    Y.ACCOUNT.NUM.VAL = Y.LIVE.SAV.ACCT.ID
    LATAM.CARD.CUSTOMER.ID = R.ACCOUNT.REC<AC.CUSTOMER>
    GOSUB GET.DEBIT.CARD.NUMBER

*CALL F.READ(FN.CARD.ISSUE.ACCOUNT,Y.LIVE.SAV.ACCT.ID,R.CARD.ISSUE.ACCOUNT.REC,F.CARD.ISSUE.ACCOUNT,Y.CARE.ISS.AC.ERR)
*IF NOT(Y.CARE.ISS.AC.ERR) THEN
*Y.CARD.ISSUE.VAL = R.CARD.ISSUE.ACCOUNT.REC<1>
*Y.DEBIT.CARD.NUM.VAL = Y.CARD.ISSUE.VAL
*END ELSE
*Y.DEBIT.CARD.NUM.VAL = ''
*END

    Y.CUSTOMER.VAL = R.ACCOUNT.REC<AC.CUSTOMER>
    Y.CURRENCY.VAL = R.ACCOUNT.REC<AC.CURRENCY>
    Y.ACCOUNT.OFFICER.VAL = R.ACCOUNT.REC<AC.ACCOUNT.OFFICER>
 *  Y.TOTAL.BALANCE.VAL = R.ACCOUNT.REC<AC.ONLINE.ACTUAL.BAL> ;*Tus Start
    Y.TOTAL.BALANCE.VAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>
 *  Y.ONLINE.ACT.BAL = R.ACCOUNT.REC<AC.ONLINE.ACTUAL.BAL>
    Y.ONLINE.ACT.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>
 *  Y.ONLINE.CLEAR.BAL = R.ACCOUNT.REC<AC.ONLINE.CLEARED.BAL>
    Y.ONLINE.CLEAR.BAL = R.ECB<ECB.ONLINE.CLEARED.BAL> ;*Tus End
     
     
      Y.BALANCE.IN.TRANSIT.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.TRAN.AVAIL>
*IF Y.ONLINE.CLEAR.BAL AND Y.ONLINE.ACT.BAL THEN
*Y.BALANCE.IN.TRANSIT.VAL = Y.ONLINE.ACT.BAL - Y.ONLINE.CLEAR.BAL
*END
*IF Y.ONLINE.ACT.BAL EQ '' THEN
*Y.BALANCE.IN.TRANSIT.VAL = Y.ONLINE.CLEAR.BAL
*END
*IF Y.ONLINE.CLEAR.BAL EQ '' THEN
*Y.BALANCE.IN.TRANSIT.VAL = Y.ONLINE.ACT.BAL
*END
    Y.ACCRED.INT.DATE.VAL = R.ACCOUNT.REC<AC.ACCR.CR.AMOUNT>
    Y.NOTICE.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.NOTIFY.POS>
    Y.VALUE = ''
    LOOKUP.ID = 'L.AC.NOTIFY.1'
    Y.VALUE = Y.NOTICE.VAL
    GOSUB RETRIEVE.SPANISH.DESC
    Y.NOTICE.VAL = Y.VALUE

    Y.AGENCY.VAL = R.ACCOUNT.REC<AC.CO.CODE>
    Y.OPENING.DATE.VAL = R.ACCOUNT.REC<AC.OPENING.DATE>
    Y.AVAIL.BAL.VAL =R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.AVAIL.BAL.POS>
    Y.CLOSING.DATE.VAL = ''
  END
  RETURN
*------------------------------------------------------------------------------------------------------------------
HIS.ACCT.SUB.PROCESS:
*------------------------------------------------------------------------------------------------------------------
  IF Y.HIS.SAV.ACCT.ID THEN
    CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.SAV.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
    IF NOT(Y.ACCOUNT.HIS.ERR) THEN
      Y.ACCOUNT.CATEG.VAL = R.ACCOUNT.HIS.REC<AC.CATEGORY>
      IF Y.SEL.SAV.ACCT.VALUE THEN
        IF Y.SEL.SAV.ACCT.VALUE EQ Y.ACCOUNT.CATEG.VAL THEN
          GOSUB FETCH.SAV.HIS.REC.PROCESS
        END ELSE
          RETURN
        END
      END  ELSE
        GOSUB FETCH.SAV.HIS.REC.PROCESS
      END
    END
  END
  RETURN
*------------------------------------------------------------------------------------------------------------------
FETCH.SAV.HIS.REC.PROCESS:
*------------------------------------------------------------------------------------------------------------------
  Y.ACCOUNT.CATEG.VAL = R.ACCOUNT.HIS.REC<AC.CATEGORY>
  CALL F.READ(FN.CATEGORY,Y.ACCOUNT.CATEG.VAL,R.CATEGORY.REC,F.CATEGORY,Y.CATEG.ERR)
  IF NOT(Y.CATEG.ERR) THEN
    Y.CATEGORY = Y.ACCOUNT.CATEG.VAL
    Y.TYPE.ACCOUNT.VAL = R.CATEGORY.REC<EB.CAT.DESCRIPTION>
    CHANGE '*' TO '' IN Y.TYPE.ACCOUNT.VAL
  END
  Y.ACCOUNT.NUM.VAL = ''
  Y.ACCOUNT.NUM.VAL = Y.HIS.SAV.ACCT.ID

  CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.SAV.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)

  Y.ACCOUNT.HIS.ALT.TYPE = R.ACCOUNT.HIS.REC<AC.ALT.ACCT.TYPE>
  Y.ACCOUNT.HIS.ALT.IDS = R.ACCOUNT.HIS.REC<AC.ALT.ACCT.ID>

  CHANGE VM TO FM IN Y.ACCOUNT.HIS.ALT.TYPE
  LOCATE 'ALTERNO1' IN Y.ACCOUNT.HIS.ALT.TYPE SETTING ALT.ID.HIS.POS THEN
    Y.ACCOUNT.ALT.ID = Y.ACCOUNT.HIS.ALT.IDS<1,ALT.ID.HIS.POS>
  END

  Y.ACCOUNT.NUM.VAL = Y.HIS.SAV.ACCT.ID
  LATAM.CARD.CUSTOMER.ID = R.ACCOUNT.HIS.REC<AC.CUSTOMER>
  GOSUB GET.DEBIT.CARD.NUMBER

  Y.CUSTOMER.VAL = R.ACCOUNT.HIS.REC<AC.CUSTOMER>
  Y.CURRENCY.VAL = R.ACCOUNT.HIS.REC<AC.CURRENCY>
  Y.ACCOUNT.OFFICER.VAL = R.ACCOUNT.HIS.REC<AC.ACCOUNT.OFFICER>
  Y.TOTAL.BALANCE.VAL = R.ACCOUNT.HIS.REC<AC.ONLINE.ACTUAL.BAL>
  Y.ONLINE.ACT.BAL = R.ACCOUNT.HIS.REC<AC.ONLINE.ACTUAL.BAL>
  Y.ONLINE.CLEAR.BAL = R.ACCOUNT.HIS.REC<AC.ONLINE.CLEARED.BAL>

  Y.BALANCE.IN.TRANSIT.VAL = R.ACCOUNT.HIS.REC<AC.LOCAL.REF,Y.LOC.AC.TRAN.AVAIL>

  Y.ACCRED.INT.DATE.VAL = R.ACCOUNT.HIS.REC<AC.ACCR.CR.AMOUNT>
  Y.NOTICE.VAL = R.ACCOUNT.HIS.REC<AC.LOCAL.REF,Y.LOC.AC.NOTIFY.POS>
  Y.AGENCY.VAL = R.ACCOUNT.HIS.REC<AC.CO.CODE>
  Y.OPENING.DATE.VAL = R.ACCOUNT.HIS.REC<AC.OPENING.DATE>
  Y.CLOSING.DATE.VAL = R.ACCOUNT.HIS.REC<AC.CLOSURE.DATE>
  Y.AVAIL.BAL.VAL =R.ACCOUNT.HIS.REC<AC.LOCAL.REF,Y.LOC.AC.AVAIL.BAL.POS>
  RETURN
*------------------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*------------------------------------------------------------------------------------------------------------------
  IF Y.TYPE.ACCOUNT.VAL THEN
    Y.FINAL.ARRAY =Y.TYPE.ACCOUNT.VAL:'*':Y.AVAIL.BAL.VAL:'*':Y.ACCOUNT.NUM.VAL:'*':Y.DEBIT.CARD.NUM.VAL:'*':Y.CUSTOMER.VAL:'*'
    Y.FINAL.ARRAY:=Y.CURRENCY.VAL:'*':Y.ACCOUNT.OFFICER.VAL:'*':Y.TOTAL.BALANCE.VAL:'*':Y.BALANCE.IN.TRANSIT.VAL:'*'
    Y.FINAL.ARRAY:=Y.ACCRED.INT.DATE.VAL:'*':Y.NOTICE.VAL:'*':Y.AGENCY.VAL:'*':Y.OPENING.DATE.VAL:'*':Y.CLOSING.DATE.VAL:'*':Y.CATEGORY:'*':Y.ACCOUNT.ALT.ID
    Y.SORT.VAL = Y.CATEGORY
    Y.AC.SORT.VAL<-1> = Y.FINAL.ARRAY:FM:Y.SORT.VAL
    Y.SORT.ARR<-1> = Y.SORT.VAL
  END
  Y.CATEGORY = ''
  RETURN
*------------------------------------------------------------------------------------------------------------------
FORM.CATEG.FINAL.ARRAY:
*------------------------------------------------------------------------------------------------------------------

  Y.SORT.ARR = SORT(Y.SORT.ARR)

  LOOP
    REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
  WHILE Y.ARR.ID : Y.ARR.POS
    LOCATE Y.ARR.ID IN Y.AC.SORT.VAL SETTING Y.FM.POS THEN
      Y.DATA<-1> = Y.AC.SORT.VAL<Y.FM.POS-1>
      DEL Y.AC.SORT.VAL<Y.FM.POS>
      DEL Y.AC.SORT.VAL<Y.FM.POS-1>
    END
  REPEAT

  Y.FINAL.ARRAY = Y.DATA

  RETURN
*------------------------------------------------------------------------------------------------------------------
RETRIEVE.SPANISH.DESC:
*------------------------------------------------------------------------------------------------------------------
  VIRTUAL.TAB.ID=LOOKUP.ID
  CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
  Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
  Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
  CHANGE '_' TO FM IN Y.LOOKUP.LIST
  CHANGE '_' TO FM IN Y.LOOKUP.DESC
  Y.VAL.SEQ = 1
  Y.VAL.CNT = DCOUNT(Y.VALUE,SM)
  LOOP
  WHILE Y.VAL.SEQ LE Y.VAL.CNT
    LOCATE Y.VALUE<1,1,Y.VAL.SEQ> IN Y.LOOKUP.LIST SETTING POS1 THEN
      IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
        Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
      END
      IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
        Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,2>        ;* This is for spanish user
      END ELSE
        Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
      END
    END
    Y.VAL.SEQ += 1

  REPEAT
  CHANGE SM TO ';' IN Y.VALUE
  RETURN
*--------------------------------------------------------------------------------------------------------------------
GET.DEBIT.CARD.NUMBER:
**********************
  GOSUB READ.LATAM.CARD.CUSTOMER

  Y.ACCT.DETS = R.LATAM.CARD.CUSTOMER<APAP.DC.ACCOUNT.NO>
  Y.CARD.NOS  = R.LATAM.CARD.CUSTOMER<APAP.DC.CARD.NO>

  Y.CUR.ID = Y.LIVE.SAV.ACCT.ID
  Y.ACC.COUNT = DCOUNT(Y.ACCT.DETS,VM)
  Y.ACC.START = 1
  Y.CARD.IDS  = ''
  LOOP
  WHILE Y.ACC.START LE Y.ACC.COUNT
    Y.CHK.ACCT = Y.ACCT.DETS<1,Y.ACC.START>
    IF Y.CHK.ACCT NE Y.CUR.ID THEN
      Y.ACC.START += 1
      CONTINUE
    END
    Y.CARD.IDS<-1> = Y.CARD.NOS<1,Y.ACC.START>[6,99]
    Y.ACC.START += 1
  REPEAT

  CHANGE FM TO ';' IN Y.CARD.IDS
  Y.DEBIT.CARD.NUM.VAL = Y.CARD.IDS
  RETURN
*------------------------------------------------------------------------------------------------------------------

READ.LATAM.CARD.CUSTOMER:
*************************
  R.LATAM.CARD.CUSTOMER  = ''
  LATAM.CARD.CUSTOMER.ER = ''
  CALL F.READ(FN.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ID,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ER)

  RETURN
*------------------------------------------------------------------------------------------------------------------

FETCH.CATEG.RANGE:

  Y.ACC.CLASS.ID = 'SAVINGS'
  CALL F.READ(FN.ACCOUNT.CLASS,Y.ACC.CLASS.ID,R.ACCT.CLASS,F.ACCOUNT.CLASS,ACCT.CLASS.ERR)
  Y.SAVINGS.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>

  Y.SAVINGS.CATEG = SORT(Y.SAVINGS.CATEG)
  Y.SAVINGS.CATEG.CNT = DCOUNT(Y.SAVINGS.CATEG,FM)
  FROM.CATEG = Y.SAVINGS.CATEG<1>
  TO.CATEG = Y.SAVINGS.CATEG<Y.SAVINGS.CATEG.CNT>

  RETURN

*-------------------------------------------------------------------------------------------------------------------

GOEND:
*------------------------------------------------------------------------------------------------------------------
END
*--------------------------*END OF SUBROUTINE*---------------------------------------------------------------------
