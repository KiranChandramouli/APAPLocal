*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOFILE.INVST.AMT(Y.OUT.ARRAY)
*---------------------------------------------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-03-0132
*  Program   Name    : Report on Dividend Totals by Office (AHP320)
*---------------------------------------------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*---------------------------------------------------------------------------------------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*---------------------------------------------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report that
*                     sumarizes the  dividend totals by agency, paid or reinvested
*---------------------------------------------------------------------------------------------------------------
* Modification History :
*---------------------------------------------------------------------------------------------------------------
*  DATE            WHO                     REFERENCE             DESCRIPTION
*-----              ----                   ----------            -----------
*  15-Nov-2010     G.Sabari                ODR-2010-03-0132      INITIAL CREATION
*  26-Nov-2010     Sakthi Sellappillai     ODR-2010-03-0132      Changes done in Mapping of STMT.ACCT.CR
*  10-JUL-2014     Egambaram A            PACS00313075           changes handled once enq.error occured
*---------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.STMT.ACCT.CR
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_F.ACCOUNT.CLASS

  GOSUB INITIALISE
  GOSUB OPENFILES
  GOSUB READ.PROCESS
  GOSUB LOCATE.PROCESS
  GOSUB MAIN.PROCESS
*    GOSUB SORT.OUT.ARRAY

  RETURN
*---------------------------------------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------------------------------------
  FN.ACCOUNT = 'F.ACCOUNT'          ;  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.ACCOUNT = ''                    ;  F.AZ.ACCOUNT = ''  ; Y.OUT.CLUB = '' ; Y.ACC.REC.ID = ''
  FN.CUSTOMER = 'F.CUSTOMER'        ;  F.CUSTOMER = ''    ;  FN.CATEGORY = 'F.CATEGORY'
  F.CATEGORY = ''
  FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
  F.STMT.ACCT.CR = ''
  Y.IN.ARRAY = ''
  VAR.PAID.INT = ''
  Y.M1 = ''
  Y.M2 = ''
  Y.MONTH = ''
  VAR.INT.CHQ = ''
  VAR.INT.ACC = ''
  VAR.REINV.INT = ''
  Y.PRE.MNTH = ''
  SEL.LIST.STMT = ''
  SEL.EQUAL.LIST1 = ''
  Y.ACCT.CREDIT.DATES.VAL = ''
  FN.ACCT.CLASS = 'F.ACCOUNT.CLASS'
  F.ACCT.CLASS = ''
  FN.AZ.PRD.PARM = 'F.AZ.PRODUCT.PARAMETER'
  F.AZ.PRD.PARM = ''
  Y.FLAG = ''

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
OPENFILES:
*---------------------------------------------------------------------------------------------------------------
*
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  CALL OPF(FN.CATEGORY,F.CATEGORY)
  CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)
  CALL OPF(FN.ACCT.CLASS,F.ACCT.CLASS)
  CALL OPF(FN.AZ.PRD.PARM,F.AZ.PRD.PARM)
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
READ.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  Y.ACCT.CLASS = 'SAVINGS'
  CALL F.READ(FN.ACCT.CLASS,Y.ACCT.CLASS,R.ACCT.CLASS,F.ACCT.CLASS,Y.AC.CL.ERR)
  Y.SAVINGS.CATEGORY = R.ACCT.CLASS<AC.CLS.CATEGORY>
  CHANGE VM TO FM IN Y.SAVINGS.CATEGORY
  Y.SAVINGS.CATEGORY = SORT(Y.SAVINGS.CATEGORY)


  SEL.CMD.APP = 'SELECT ':FN.AZ.PRD.PARM
  CALL EB.READLIST(SEL.CMD.APP,SEL.APP.LIST,'',NO.OF.APP.RECS,SEL.APP.ERR)

  LOOP
    REMOVE Y.APP.ID FROM SEL.APP.LIST SETTING Y.APP.POS
  WHILE Y.APP.ID:Y.APP.POS
    CALL F.READ(FN.AZ.PRD.PARM,Y.APP.ID,R.APP.REC,F.AZ.PRD.PARM,Y.APP.ERR)
    Y.APP.CATEGORY<-1> = R.APP.REC<AZ.APP.ALLOWED.CATEG>
  REPEAT
  Y.APP.CATEGORY = SORT(Y.APP.CATEGORY)
*
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
LOCATE.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  LOCATE "INVST.TYPE" IN D.FIELDS<1> SETTING Y.INVST.TYPE.POS THEN
    Y.INVST.TYPE = D.RANGE.AND.VALUE<Y.INVST.TYPE.POS>
    GOSUB GET.MOD.SEL.CMD
  END

  LOCATE "CLOSE.MONTH" IN D.FIELDS<1> SETTING Y.CLOSE.MNTH.POS THEN
    Y.CLOSE.OPER.VAL = D.LOGICAL.OPERANDS<Y.CLOSE.MNTH.POS>
    Y.CLOSE.MONTH    = D.RANGE.AND.VALUE<Y.CLOSE.MNTH.POS>
    GOSUB CLOSE.MONTH.RANGE.CHECK.PROCESS
    GOSUB CLOSE.MONTH.EQUAL.CHECK.PROCESS
  END
*
  IF ENQ.ERROR NE '' THEN
    RETURN
  END
*
  IF NOT(Y.FLAG) THEN
    IF Y.SAVINGS.CATEGORY THEN
      CHANGE FM TO ' ' IN Y.SAVINGS.CATEGORY
      SEL.ACC.CMD = 'SELECT ':FN.ACCOUNT:' WITH CATEGORY EQ ':Y.SAVINGS.CATEGORY
*            SEL.ACC.CMD = "SELECT ":FN.ACCOUNT
    END

    IF Y.APP.CATEGORY THEN
      CHANGE FM TO ' ' IN Y.APP.CATEGORY
      SEL.AZ.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH CATEGORY EQ ':Y.APP.CATEGORY
    END
  END
*
*LOCATE "CLOSE.MONTH" IN D.FIELDS<1> SETTING Y.CLOSE.MNTH.POS THEN
*Y.CLOSE.OPER.VAL = D.LOGICAL.OPERANDS<Y.CLOSE.MNTH.POS>
*Y.CLOSE.MONTH    = D.RANGE.AND.VALUE<Y.CLOSE.MNTH.POS>
*GOSUB CLOSE.MONTH.RANGE.CHECK.PROCESS
*GOSUB CLOSE.MONTH.EQUAL.CHECK.PROCESS
*END

  LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
    Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
    IF Y.SAVINGS.CATEGORY THEN
      SEL.ACC.CMD := " AND CO.CODE EQ ":Y.AGENCY
    END
    IF Y.APP.CATEGORY THEN
      SEL.AZ.CMD := " AND CO.CODE EQ ":Y.AGENCY
    END
  END

  LOCATE "REGION" IN D.FIELDS<1> SETTING Y.REGION.POS THEN
    Y.REGION = D.RANGE.AND.VALUE<Y.REGION.POS>
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
CLOSE.MONTH.RANGE.CHECK.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*

  IF Y.CLOSE.OPER.VAL EQ 2 THEN
    IF Y.CLOSE.MONTH THEN
      Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
      IF Y.CLOSE.LEN EQ 17 THEN
        Y.M1 = FIELD(Y.CLOSE.MONTH,SM,1)
        Y.M2 = FIELD(Y.CLOSE.MONTH,SM,2)
      END ELSE
        ENQ.ERROR = 'Enter two valid T24 format dates in Selection'
        RETURN
      END
    END
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
CLOSE.MONTH.EQUAL.CHECK.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  IF Y.CLOSE.OPER.VAL EQ 1 THEN
    IF Y.CLOSE.MONTH THEN
      Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
      IF Y.CLOSE.LEN EQ 8 THEN
        Y.M1 = Y.CLOSE.MONTH
        Y.M2 = ''
      END ELSE
        ENQ.ERROR = 'Enter one valid T24 format date in Selection'
        RETURN
      END
    END
  END
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  IF ENQ.ERROR EQ '' THEN
    GOSUB MULTI.LOCAL.REF
    GOSUB FETCH.DETAILS
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
FETCH.DETAILS:
*---------------------------------------------------------------------------------------------------------------
*


*    SEL.ACC.CMD := ' BY CATEGORY BY CURRENCY BY CO.CODE BY ACCOUNT.OFFICER'
*    SEL.AZ.CMD := ' BY CATEGORY BY CURRENCY BY CO.CODE'

  SEL.ACC.LIST = ''
  SEL.AZ.LIST = ''
  CALL EB.READLIST(SEL.ACC.CMD,SEL.ACC.LIST,'',NO.OF.ACC.RECS,SEL.ACC.ERR)
  CALL EB.READLIST(SEL.AZ.CMD,SEL.AZ.LIST,'',NO.OF.ACC.RECS,SEL.AZ.ERR)

  SEL.LIST.AZ.ACC = SEL.ACC.LIST:FM:SEL.AZ.LIST


  LOOP
    REMOVE AZ.ACC.ID FROM SEL.LIST.AZ.ACC SETTING Y.AZ.ACC.ID.POS
  WHILE AZ.ACC.ID:Y.AZ.ACC.ID.POS
    Y.PRE.MNTH = '' ; Y.CUR.MNTH = '' ; R.AZ.ACCOUNT = '' ; AZ.ACC.ERR = '' ; Y.ACC.ID = AZ.ACC.ID
    R.ACCOUNT.REC = '' ; Y.ACCT.ERR = '' ; Y.MONTH = '' ; Y.DIFF.MNTH = '' ; Y.AZ.FLAG1 = ''
    Y.ACC.REC.ID = AZ.ACC.ID

    CALL F.READ(FN.ACCOUNT,Y.ACC.REC.ID,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
    Y.ACCT.CREDIT.DATES.VAL=R.ACCOUNT.REC<AC.CAP.DATE.CR.INT>

    Y.ACT.CATEGORY  = R.ACCOUNT.REC<AC.CATEGORY>
    VAR.INV.CATEG   = R.ACCOUNT.REC<AC.CATEGORY>
    GOSUB CATEG.DESC.DETAILS

    IF Y.ACCT.CREDIT.DATES.VAL THEN
      CHANGE VM TO FM IN Y.ACCT.CREDIT.DATES.VAL
      IF Y.M1 NE '' AND Y.M2 EQ '' THEN
        Y.SEL.MONTH = Y.M1
        Y.M2 = Y.M1
        LOCATE Y.SEL.MONTH IN Y.ACCT.CREDIT.DATES.VAL SETTING Y.SEL.MON.POS THEN
          Y.MONTH = Y.SEL.MONTH[1,8]
        END ELSE
          CONTINUE
        END
      END
      GOSUB SUB.PROCESS
    END

    GOSUB NULL.VALUES

  REPEAT
  RETURN
*
*----------------------------------------------------------------------------------------------------------------
SUB.PROCESS:
*----------------------------------------------------------------------------------------------------------------
*

  CALL F.READ(FN.AZ.ACCOUNT,AZ.ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
  IF R.AZ.ACCOUNT THEN
    Y.FLAG.AZ.ACC = 1
    Y.AZ.CATEGORY = R.AZ.ACCOUNT<AZ.CATEGORY>
    VAR.INV.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
    VAR.CODE      = R.AZ.ACCOUNT<AZ.CO.CODE>
  END ELSE
    CALL F.READ(FN.ACCOUNT,Y.ACC.REC.ID,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
    IF R.ACCOUNT.REC THEN
      VAR.CODE = R.ACCOUNT.REC<AC.CO.CODE>
    END
  END
  CHANGE ' ' TO FM IN Y.APP.CATEGORY
  GOSUB CLOSE.MONTH.RANGE.VALUES.PROCESS

  RETURN

*--------------------------------------------------------------------------------------------------------
CLOSE.MONTH.RANGE.VALUES.PROCESS:
*-------------------------------------------------------------------------------------------------------- <<<<<< changes done >>>>>>>>>>
*

  IF Y.M1 NE '' AND Y.M2 NE '' THEN
    Y.TOT.ACCT.CR.MNTH.CNT = DCOUNT(Y.ACCT.CREDIT.DATES.VAL,FM)
    FOR Y.MONTH.CNT = 1 TO Y.TOT.ACCT.CR.MNTH.CNT
      Y.AC.CR.LIST.MNTH = Y.ACCT.CREDIT.DATES.VAL<Y.MONTH.CNT>
      IF Y.AC.CR.LIST.MNTH GE Y.M1 AND Y.AC.CR.LIST.MNTH LE Y.M2 THEN

        Y.MONTH = Y.AC.CR.LIST.MNTH
        Y.STMT.CR.ID.NEW = Y.ACC.REC.ID:"-":Y.AC.CR.LIST.MNTH
        LOCATE Y.AZ.CATEGORY IN Y.APP.CATEGORY<1> SETTING Y.AZ.CAT.POS THEN
          GOSUB INTEREST.VALUES.PROCESS
          Y.AZ.FLAG1 = '1'
          GOSUB CATEG.DESC.DETAILS
          GOSUB STMT.DET.NEW
        END

        CHANGE ' ' TO FM IN Y.SAVINGS.CATEGORY
        LOCATE Y.ACT.CATEGORY IN Y.SAVINGS.CATEGORY<1> SETTING Y.SAV.CAT.POS THEN
          GOSUB INTEREST.VALUES.PROCESS
          GOSUB STMT.DET.NEW
        END
        GOSUB ACC.OFF.DETAILS
        GOSUB FORM.FINAL.ARRAY
      END
    NEXT Y.MONTH.CNT
  END

  RETURN
*
*--------------------------------------------------------------------------------------------------------
CLOSE.MONTH.NULL.SELECT.PROCESS:
*--------------------------------------------------------------------------------------------------------
*
  IF Y.M1 EQ '' AND Y.M2 EQ '' THEN
    Y.ACCT.CREDIT.DAT.VAL.CNT = DCOUNT(Y.ACCT.CREDIT.DATES.VAL,FM)
    IF Y.ACCT.CREDIT.DAT.VAL.CNT EQ 1 THEN
      Y.MONTH = Y.ACCT.CREDIT.DATES.VAL[1,8]
    END ELSE
      FOR Y.AC.CR.LAT.VAL = 1 TO Y.ACCT.CREDIT.DAT.VAL.CNT
        Y.ACCT.CREDIT.LATEST.MNTH.VAL = Y.ACCT.CREDIT.DATES.VAL<Y.AC.CR.LAT.VAL>
        Y.CUR.MNTH = Y.ACCT.CREDIT.LATEST.MNTH.VAL[1,8]
        GOSUB FORM.MONTH.FIELD.PROCESS
      NEXT Y.AC.CR.LAT.VAL
      GOSUB MONTH.FIELD.VAL.PROCESS
    END
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
FORM.MONTH.FIELD.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  IF Y.PRE.MNTH EQ '' THEN
    Y.PRE.MNTH = Y.CUR.MNTH
  END ELSE
    IF Y.PRE.MNTH NE Y.CUR.MNTH THEN
      Y.DIFF.MNTH = Y.CUR.MNTH
    END ELSE
      Y.DIFF.MNTH = ''
    END
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
MONTH.FIELD.VAL.PROCESS:
*---------------------------------------------------------------------------------------------------------------
  IF Y.DIFF.MNTH EQ '' THEN
    Y.MONTH = Y.PRE.MNTH
  END ELSE
    Y.MONTH = Y.DIFF.MNTH:' - ':Y.PRE.MNTH
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
INTEREST.VALUES.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*

  VAR.MONTH = Y.MONTH
  VAR.INV.CATEG = ''
  Y.REINV.INT = ''
  VAR.AZ.CURR = ''
  VAR.REINV.INT = ''
  VAR.INT.CHQ = ''
  VAR.INT.ACC = ''
  VAR.INV.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
  VAR.AZ.CURR = R.AZ.ACCOUNT<AZ.CURRENCY>
  Y.REINV.INT = R.ACCOUNT.REC<AC.LOCAL.REF,L.AC.REINVESTED.POS>
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*---------------------------------------------------------------------------------------------------------------
*

  IF VAR.MONTH THEN

    IF Y.FLAG.AZ.ACC THEN
      VAR.INV.CATEG = VAR.CATEG.DESC
      VAR.CATEG.DESC = ''
    END ELSE
      VAR.INV.CATEG = ''
    END
    CHANGE ' ' TO FM IN Y.SAVINGS.CATEGORY
    LOCATE Y.CAT.ID IN Y.SAVINGS.CATEGORY SETTING Y.CAT.POS.AC THEN
      Y.SAV.AC.CATEGORY = Y.CAT.ID
    END
    CHANGE ' ' TO FM IN Y.APP.CATEGORY
    LOCATE Y.CAT.ID IN Y.APP.CATEGORY<1> SETTING Y.CAT.POS.AZ THEN
      Y.AZ.AC.CATEGORY = Y.CAT.ID
    END
    LOCATE Y.CAT.ID IN Y.APP.CATEGORY<1> SETTING Y.CAT.POS.AZ THEN
      Y.AZ.AC.CATEGORY = Y.CAT.ID
    END
    IF Y.AZ.AC.CATEGORY THEN
      Y.ACCOUNT.CAT = Y.AZ.AC.CATEGORY
      Y.ACCOUNT.CURR = VAR.AZ.CURR
    END
    IF Y.SAV.AC.CATEGORY THEN
      Y.ACCOUNT.CAT = Y.SAV.AC.CATEGORY
      Y.ACCOUNT.CURR = VAR.ACC.CURR
    END

    VAR.TOT.INT = SUM(VAR.REINV.INT:FM:VAR.INT.CHQ:FM:VAR.INT.ACC)
    VAR.GRND.TOT = SUM(VAR.PAID.INT:FM:VAR.TOT.INT)
    VAR.MONTH.CUR.CAT = VAR.MONTH:"&":Y.ACCOUNT.CAT:"&":Y.ACCOUNT.CURR

    LOCATE VAR.MONTH.CUR.CAT IN Y.OUT.CLUB SETTING POS1 THEN

      GOSUB CLUB.VALUES

    END ELSE
      GOSUB CLUB.NEW.VALUES



*                                   1             2             3                4                  5                  6
      Y.OUT.ARRAY<-1> = VAR.MONTH :"*":VAR.CODE:"*":VAR.ACCT.OFF:"*":VAR.CATEG.DESC:"*":VAR.ACC.CURR:"*":VAR.PAID.INT:"*"
*                                7                8                9                 10              11            12
      Y.OUT.ARRAY := VAR.INV.CATEG:"*":VAR.AZ.CURR:"*":VAR.REINV.INT:"*":VAR.INT.CHQ:"*":VAR.INT.ACC:"*":VAR.TOT.INT:"*"
*                                13                 14                   15
      Y.OUT.ARRAY := VAR.GRND.TOT:"*":Y.SAV.AC.CATEGORY:"*":Y.AZ.AC.CATEGORY
    END

  END
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
CLUB.VALUES:
*---------------------------------------------------------------------------------------------------------------
*
  Y.VALUE.1 = Y.OUT.CLUB.RENIV<POS1>
  Y.VALUE.2 = Y.OUT.CLUB.INT.CHQ<POS1>
  Y.VALUE.3 = Y.OUT.CLUB.INT.ACC<POS1>
  Y.VALUE.4 = Y.OUT.CLUB.PAID.INT<POS1>

  VAR.REINV.INT = VAR.REINV.INT + Y.VALUE.1
  VAR.INT.CHQ = VAR.INT.CHQ + Y.VALUE.2
  VAR.INT.ACC = VAR.INT.ACC + Y.VALUE.3
  VAR.PAID.INT = VAR.PAID.INT + Y.VALUE.4
  VAR.TOT.INT = SUM(VAR.REINV.INT:FM:VAR.INT.CHQ:FM:VAR.INT.ACC)
  VAR.GRND.TOT = SUM(VAR.PAID.INT:FM:VAR.TOT.INT)


  Y.OUT.ARRAY1 = Y.OUT.ARRAY<POS1>
  CHANGE "*" TO FM IN Y.OUT.ARRAY1
  Y.OUT.ARRAY1<9>  = VAR.REINV.INT
  Y.OUT.ARRAY1<10> = VAR.INT.CHQ
  Y.OUT.ARRAY1<11> = VAR.INT.ACC
  Y.OUT.ARRAY1<12> = VAR.TOT.INT
  Y.OUT.ARRAY1<13> = VAR.GRND.TOT
  Y.OUT.ARRAY1<6>  = VAR.PAID.INT

  CHANGE FM TO "*" IN Y.OUT.ARRAY1
  Y.OUT.ARRAY<POS1> = Y.OUT.ARRAY1
  Y.OUT.CLUB.PAID.INT<POS1> = VAR.PAID.INT
  Y.OUT.CLUB.RENIV<POS1>    = VAR.REINV.INT
  Y.OUT.CLUB.INT.CHQ<POS1>  = VAR.INT.CHQ
  Y.OUT.CLUB.INT.ACC<POS1>  = VAR.INT.ACC
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
CLUB.NEW.VALUES:
*---------------------------------------------------------------------------------------------------------------
*
  Y.OUT.CLUB<-1> = VAR.MONTH
  IF Y.AZ.AC.CATEGORY THEN
    Y.OUT.CLUB := "&":Y.AZ.AC.CATEGORY:"&":VAR.AZ.CURR
    Y.OUT.CLUB.AZ.CAT<-1>   = Y.AZ.AC.CATEGORY
    Y.OUT.CLUB.AZ.CURR<-1>  = VAR.AZ.CURR
    Y.OUT.CLUB.RENIV<-1>    = VAR.REINV.INT
    Y.OUT.CLUB.INT.CHQ<-1>  = VAR.INT.CHQ
    Y.OUT.CLUB.INT.ACC<-1>  = VAR.INT.ACC
    Y.OUT.CLUB.PAID.INT<-1> = 0
  END ELSE
    Y.OUT.CLUB := "&":Y.SAV.AC.CATEGORY:"&":VAR.ACC.CURR
    Y.OUT.CLUB.AZ.CAT<-1>   = Y.SAV.AC.CATEGORY
    Y.OUT.CLUB.AZ.CURR<-1>  = VAR.ACC.CURR
    Y.OUT.CLUB.RENIV<-1>    = 0
    Y.OUT.CLUB.INT.CHQ<-1>  = 0
    Y.OUT.CLUB.INT.ACC<-1>  = 0
    Y.OUT.CLUB.PAID.INT<-1> = VAR.PAID.INT
  END

  RETURN

*---------------------------------------------------------------------------------------------------------------
STMT.DET.NEW:
*---------------------------------------------------------------------------------------------------------------
  CALL F.READ(FN.STMT.ACCT.CR,Y.STMT.CR.ID.NEW,R.STMT.ACCT.CR,F.STMT.ACCT.CR,STMT.ACCT.CR.ERR)
  Y.VAR.PAID.VAL = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
  Y.VAR.PAID.CNT = DCOUNT (Y.VAR.PAID.VAL,VM)
  IF Y.VAR.PAID.CNT GT 1 THEN
    FOR I = 1 TO Y.VAR.PAID.CNT
      IF NOT(VAR.PAID.INT) THEN
        VAR.PAID.INT = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT,I>
      END ELSE
        VAR.PAID.INT = VAR.PAID.INT + R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT,I>
      END
    NEXT
  END ELSE
    VAR.PAID.INT = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
  END
  IF Y.AZ.FLAG1 NE '' THEN
    GOSUB INTEREST.VALUES
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
INTEREST.VALUES:
*---------------------------------------------------------------------------------------------------------------
  IF Y.REINV.INT = "YES" THEN
    VAR.REINV.INT = VAR.PAID.INT
  END
  IF Y.REINV.INT = "NO" THEN
    Y.INT.LIQ.ACT2 = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACT2,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
      Y.CUS = R.ACCOUNT<AC.CUSTOMER>
      IF Y.CUS EQ '' THEN
        VAR.INT.CHQ = VAR.PAID.INT
      END ELSE
        VAR.INT.ACC = VAR.PAID.INT
      END
    END
  END
  VAR.PAID.INT = ''
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
STMT.DETAILS:
*---------------------------------------------------------------------------------------------------------------

  SEL.CMD.STMT = "SELECT ":FN.STMT.ACCT.CR: " WITH @ID LIKE ":Y.ACC.ID:"..."
  CALL EB.READLIST(SEL.CMD.STMT,SEL.LIST.STMT.ALL,'',NO.OF.REC.STMT,SEL.ERR.STMT)
  IF Y.CLOSE.MONTH EQ '' THEN
    SEL.LIST.STMT = SEL.LIST.STMT.ALL
    GOSUB STMT.DET.SUB.PROCESS
  END ELSE
    IF Y.M2 EQ '' THEN
      GOSUB STMT.SEL.EQUAL.VAL.PROCESS
    END ELSE
      GOSUB STMT.SEL.RANGE.VAL.PROCESS
      GOSUB STMT.DET.SUB.PROCESS
    END
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
STMT.SEL.EQUAL.VAL.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  Y.SEL.EQ.LIST.CNT = DCOUNT(SEL.LIST.STMT.ALL,FM)
  FOR Y.SEL.EQUAL.CNT = 1 TO Y.SEL.EQ.LIST.CNT
    Y.SEL.EQ.LIST.VAL = SEL.LIST.STMT.ALL<Y.SEL.EQUAL.CNT>
    IF SEL.EQUAL.LIST1 EQ '' THEN
      SEL.EQUAL.LIST1 = Y.SEL.EQ.LIST.VAL['-',2,1]
    END ELSE
      SEL.EQUAL.LIST1<-1> = Y.SEL.EQ.LIST.VAL['-',2,1]
    END
  NEXT Y.SEL.EQUAL.CNT
  LOCATE Y.M1 IN SEL.EQUAL.LIST1 SETTING Y.SEL.MN.POS THEN
    SEL.LIST.STMT = SEL.LIST.STMT.ALL<Y.SEL.MN.POS,1>
    GOSUB STMT.DET.SUB.PROCESS
  END

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
STMT.SEL.RANGE.VAL.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  Y.SEL.RG.LIST.CNT = DCOUNT(SEL.LIST.STMT.ALL,FM)
  FOR Y.SEL.RANGE.CNT = 1 TO Y.SEL.RG.LIST.CNT
    Y.SEL.RG.LIST.VAL = SEL.LIST.STMT.ALL<Y.SEL.RANGE.CNT>
    Y.SEL.RG.LIST1 = Y.SEL.RG.LIST.VAL['-',2,1]
    IF Y.SEL.RG.LIST1 GE Y.M1 AND Y.SEL.RG.LIST1 LE Y.M2 THEN
      IF SEL.LIST.STMT EQ '' THEN
        SEL.LIST.STMT = SEL.LIST.STMT.ALL<Y.SEL.RANGE.CNT,1>
      END ELSE
        SEL.LIST.STMT<-1> = SEL.LIST.STMT.ALL<Y.SEL.RANGE.CNT,1>
      END
    END
  NEXT Y.SEL.RANGE.CNT

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
STMT.DET.SUB.PROCESS:
*---------------------------------------------------------------------------------------------------------------
*
  VAR.PAID.INT = ''
  LOOP
    REMOVE STMT.ID FROM SEL.LIST.STMT SETTING STMT.ID.POS
  WHILE STMT.ID:STMT.ID.POS
    R.STMT.ACCT.CR = ''
    STMT.ACCT.CR.ERR = ''
    CALL F.READ(FN.STMT.ACCT.CR,STMT.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,STMT.ACCT.CR.ERR)
    Y.VAR.PAID.VAL = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
    Y.VAR.PAID.CNT = DCOUNT (Y.VAR.PAID.VAL,VM)
    IF Y.VAR.PAID.CNT GT 1 THEN
      FOR I = 1 TO Y.VAR.PAID.CNT
        IF NOT(VAR.PAID.INT) THEN
          VAR.PAID.INT = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT,I>
        END ELSE
          VAR.PAID.INT = VAR.PAID.INT + R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT,I>
        END
      NEXT
    END ELSE
      IF NOT(VAR.PAID.INT) THEN
        VAR.PAID.INT = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
      END ELSE
        VAR.PAID.INT = VAR.PAID.INT + R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
      END
    END
  REPEAT
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
ACC.OFF.DETAILS:
*---------------------------------------------------------------------------------------------------------------
*

  CHANGE ' ' TO FM IN Y.SAVINGS.CATEGORY
  CALL F.READ(FN.ACCOUNT,AZ.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  Y.ACC.REG = ''

  Y.ACC.CATEGORY = R.ACCOUNT<AC.CATEGORY>
  Y.ACC.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
  Y.ACC.OFF.VAL = ''
  CALL F.READ(FN.CUSTOMER,Y.ACC.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
  Y.ACC.REG = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
  IF Y.ACC.REG THEN
    Y.ACC.OFF.VAL = Y.ACC.REG[8]
  END
  IF LEN(Y.ACC.OFF.VAL) LT 7 THEN
    VAR.ACCT.OFF = ""
  END ELSE
    VAR.ACCT.OFF = Y.ACC.OFF.VAL[1,2]
  END
*   LOCATE Y.ACC.CATEGORY IN Y.SAVINGS.CATEGORY<1> SETTING Y.SAV.CATEG.POS THEN
  VAR.ACC.CURR = R.ACCOUNT<AC.CURRENCY>
*   END
*
  RETURN
*
*---------------------------------------------------------------------------------------------------------------
CATEG.DESC.DETAILS:
*---------------------------------------------------------------------------------------------------------------
*
  CALL F.READ(FN.CATEGORY,VAR.INV.CATEG,R.CATEGORY,F.CATEGORY,CATEG.ERR)
  Y.CAT.ID = VAR.INV.CATEG
  VAR.CATEG.DESC = ''
  VAR.CATEG.DESC = R.CATEGORY<EB.CAT.DESCRIPTION,LNGG>
  IF VAR.CATEG.DESC EQ '' THEN
    VAR.CATEG.DESC = R.CATEGORY<EB.CAT.DESCRIPTION,1>
  END
  CHANGE '*' TO "" IN VAR.CATEG.DESC

  RETURN
*
*---------------------------------------------------------------------------------------------------------------
MULTI.LOCAL.REF:
*---------------------------------------------------------------------------------------------------------------
  APPL.ARRAY           = 'ACCOUNT'
  FLD.ARRAY            = 'L.AC.REINVESTED'
  FLD.POS              = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  L.AC.REINVESTED.POS = FLD.POS<1,1>
  RETURN
*---------------------------------------------------------------------------------------------------------------
GET.MOD.SEL.CMD:
*---------------------------------------------------------------------------------------------------------------
  LOCATE Y.INVST.TYPE IN Y.SAVINGS.CATEGORY<1> SETTING Y.SAV.CAT.POS THEN
    CHANGE FM TO ' ' IN Y.INVST.TYPE
    SEL.ACC.CMD = 'SELECT ':FN.ACCOUNT:' WITH CATEGORY EQ ':Y.INVST.TYPE
  END
  LOCATE Y.INVST.TYPE IN Y.APP.CATEGORY<1> SETTING Y.AZ.PRO.POS THEN
    SEL.AZ.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH CATEGORY EQ ':Y.INVST.TYPE
  END
  Y.FLAG = '1'
  RETURN
*
*-----------
NULL.VALUES:
*------------
*
  VAR.MONTH      = ''
  VAR.CODE       = ''
  VAR.ACCT.OFF   = ''
  VAR.CATEG.DESC = ''
  VAR.ACC.CURR   = ''
  VAR.PAID.INT   = ''
  VAR.INV.CATEG  = ''
  VAR.AZ.CURR    = ''
  VAR.REINV.INT  = ''
  VAR.INT.CHQ    = ''
  VAR.INT.ACC    = ''
  VAR.TOT.INT    = ''
  VAR.GRND.TOT   = ''
  Y.SAV.AC.CATEGORY = ''
  Y.AZ.AC.CATEGORY = ''
  RETURN
***************
SORT.OUT.ARRAY:
***************

  Y.OUT.ARRAY = SORT(Y.OUT.ARRAY)

  Y.REC.COUNT = DCOUNT(Y.OUT.ARRAY,FM)
  Y.REC.START = 1
  LOOP
  WHILE Y.REC.START LE Y.REC.COUNT
    Y.REC =  Y.OUT.ARRAY<Y.REC.START>
    Y.COMP = FIELD(Y.REC,'*',2)
    Y.CAT.DES = FIELD(Y.REC,'*',4)
    Y.ACOF = FIELD(Y.REC,'*',3)
    Y.CCY  = FIELD(Y.REC,'*',5)
    Y.INV.CAT = FIELD(Y.REC,'*',7)
    Y.AZ.CUR = FIELD(Y.REC,'*',8)

    Y.SORT.VAL = Y.COMP:Y.CAT.DES:FMT(Y.ACOF,'R%12'):Y.CCY:Y.INV.CAT:Y.AZ.CUR
    Y.AZ.SORT.VAL<-1> = Y.REC:FM:Y.SORT.VAL
    Y.SORT.ARR<-1>= Y.SORT.VAL
    Y.REC.START += 1
  REPEAT
  Y.SORT.ARR = SORT(Y.SORT.ARR)

  LOOP
    REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
  WHILE Y.ARR.ID : Y.ARR.POS
    LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
      Y.ARRAY<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
      DEL Y.AZ.SORT.VAL<Y.FM.POS>
      DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
    END
  REPEAT
  Y.OUT.ARRAY = Y.ARRAY
  RETURN
END
*-------------------------------------------------* END OF SUBROUTINE*------------------------------------------
