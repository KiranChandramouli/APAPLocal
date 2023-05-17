*-----------------------------------------------------------------------------
* <Rating>-153</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NEW.UPDATE.CAPINT.AMT(Y.ID)
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.UPDATE.CAPINT.AMT
*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   23-Oct-2012            Wof Accounting - PACS00202156
*-----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ACCT.MRKWOF.HIST
$INSERT I_F.REDO.NEW.WORK.INT.CAP.OS
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.STMT.ENTRY
$INSERT I_F.REDO.ACCT.MRKWOF.PARAMETER
$INSERT I_F.COMPANY
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.AA.INT.CLASSIFICATION
$INSERT I_REDO.B.NEW.UPDATE.CAPINT.AMT.COMMON
$INSERT I_F.REDO.ACCT.MRKWOF.PARAMETER

MAIN:


  GOSUB PROCESS
  GOSUB PGM.END

PROCESS:


  CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,Y.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)

  CALL F.READ(FN.REDO.NEW.WORK.INT.CAP.OS,Y.ID,R.REDO.NEW.WORK.INT.CAP.OS,F.REDO.NEW.WORK.INT.CAP.OS,CAP.OS.ERR)
  IF R.REDO.NEW.WORK.INT.CAP.OS THEN
    Y.ENTRY.SET = R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.ENTRY>
    IF Y.ENTRY.SET EQ 'YES' THEN
      GOSUB ENTRY.REVERSE
    END ELSE
      R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.INTEREST.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.INT>:'*':TODAY
      R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.CAPITAL.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.PRINCIPAL>:'*':TODAY
      CALL F.WRITE(FN.REDO.NEW.WORK.INT.CAP.OS,Y.ID,R.REDO.NEW.WORK.INT.CAP.OS)
    END
  END ELSE
    R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.INTEREST.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.INT>:'*':TODAY
    R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.CAPITAL.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.PRINCIPAL>:'*':TODAY
    CALL F.WRITE(FN.REDO.NEW.WORK.INT.CAP.OS,Y.ID,R.REDO.NEW.WORK.INT.CAP.OS)
  END

  RETURN

ENTRY.REVERSE:


  CALL F.READ(FN.AA.ARRANGEMENT,Y.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.AR.ERR)
  Y.LOAN.COMP = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
  Y.LOAN.CUR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
  Y.LOAN.ACC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

  CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACC,F.ACCOUNT,AC.ERR)
  Y.LOAN.CATEG = R.ACC<AC.CATEGORY>

  CALL F.READ(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.ACC,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,CON.ERR)

  GOSUB BEFORE.RAISE.ENTRIES  ;* All relates WOF accounts created.
  GOSUB ENTRY.PRINCIPAL
  GOSUB ENTRY.INTEREST

  CALL F.DELETE(FN.REDO.NEW.WORK.INT.CAP.OS,Y.ID)

  R.REDO.NEW.WORK.INT.CAP.OS = ''
  R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.INTEREST.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.INT>:'*':TODAY
  R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.CAPITAL.TEXT> = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.PRINCIPAL>:'*':TODAY
  CALL F.WRITE(FN.REDO.NEW.WORK.INT.CAP.OS,Y.ID,R.REDO.NEW.WORK.INT.CAP.OS)

  RETURN

*-----------------------------------------------------------------------------
BEFORE.RAISE.ENTRIES:
*-----------------------------------------------------------------------------

  Y.LOAN.STATUS = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.L.LOAN.STATUS>
  LOCATE Y.LOAN.CATEG IN R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PROD.CATEGORY,1> SETTING CATEG.POS THEN
    LOCATE Y.LOAN.STATUS IN R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.LOAN.STATUS,CATEG.POS,1> SETTING LOAN.POS THEN
      Y.DR.PRINCIPAL.CATEG = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.DEB.CATEGORY,CATEG.POS,LOAN.POS>
      Y.DR.PRINCIPAL.TXN   = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.DEB.TXN,CATEG.POS,LOAN.POS>
      Y.CR.PRINCIPAL.CATEG = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.CRED.CATEGORY,CATEG.POS,LOAN.POS>
      Y.CR.PRINCIPAL.TXN   = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.CRED.TXN,CATEG.POS,LOAN.POS>
      Y.DR.INTEREST.CATEG  = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.DEB.CATEGORY,CATEG.POS,LOAN.POS>
      Y.DR.INTEREST.TXN    = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.DEB.TXN,CATEG.POS,LOAN.POS>
      Y.CR.INTEREST.CATEG  = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.CRED.CATEGORY,CATEG.POS,LOAN.POS>
      Y.CR.INTEREST.TXN    = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.CRED.TXN,CATEG.POS,LOAN.POS>
    END ELSE
      CALL OCOMO("Loan Status not found in Param - REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
      GOSUB PGM.END
    END
  END ELSE
    CALL OCOMO("Category not found in Param - REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
    GOSUB PGM.END
  END
  IF Y.DR.PRINCIPAL.TXN AND Y.CR.PRINCIPAL.TXN AND Y.DR.INTEREST.TXN AND Y.CR.INTEREST.TXN ELSE
    CALL OCOMO("TXN Codes Missing in REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
    GOSUB PGM.END
  END

  CALL F.READ(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.ACC,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,CON.ERR)
  IF R.REDO.CONCAT.ACC.WOF THEN
    Y.CUST.PRIN.CNT.ACC = R.REDO.CONCAT.ACC.WOF<1>          ;* Principal Customer Contingent Account
    Y.CUST.PRIN.CNT.INT = R.REDO.CONCAT.ACC.WOF<2>          ;* Interest Customer Contingent Account
    IF Y.CUST.PRIN.CNT.ACC ELSE
      GOSUB CREATE.CUST.PRIN.CNT        ;* Creates Principal Customer Contingent Account
    END
    IF Y.CUST.PRIN.CNT.INT ELSE
      GOSUB CREATE.CUST.INT.CNT         ;* Creates Interest Customer Contingent Account
    END

  END ELSE
    GOSUB CREATE.CUST.PRIN.CNT          ;* Creates Principal Customer Contingent Account
    GOSUB CREATE.CUST.INT.CNT ;* Creates Interest Customer Contingent Account
  END
  CALL F.WRITE(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.ACC,R.REDO.CONCAT.ACC.WOF)
  GOSUB CHECK.INT.ACCOUNTS    ;* Internal Accounts for WOF created or returned if exist

  RETURN
*-----------------------------------------------------------------------------
CREATE.CUST.PRIN.CNT:
*-----------------------------------------------------------------------------
* Creates Principal Customer Contingent Account

  IF Y.DR.PRINCIPAL.CATEG ELSE
    CALL OCOMO("Principal Customer Contingent Account Category not found ":Y.ID)
    GOSUB PGM.END
  END

  R.OFS.ACC = ''
  R.OFS.ACC<AC.CATEGORY>                      = Y.DR.PRINCIPAL.CATEG
  R.OFS.ACC<AC.ACCOUNT.TITLE.2>               = "WOF Prin ":Y.ID
  GOSUB FILL.COMMON.ARRAY

  IF Y.LFG EQ 1 THEN
    R.REDO.CONCAT.ACC.WOF<1> = Y.NEW.AC
  END ELSE
    CALL OCOMO("Principal Customer Contingent Account not created  ":Y.ID)
    GOSUB PGM.END
  END

  RETURN
*-----------------------------------------------------------------------------
CREATE.CUST.INT.CNT:
*-----------------------------------------------------------------------------
* Creates Interest Customer Contingent Account

  IF Y.DR.INTEREST.CATEG ELSE
    CALL OCOMO("Principal Customer Contingent Account Category not found ":Y.ID)
    GOSUB PGM.END
  END

  R.OFS.ACC = ''
  R.OFS.ACC<AC.CATEGORY>                      = Y.DR.INTEREST.CATEG
  R.OFS.ACC<AC.ACCOUNT.TITLE.2>               = "WOF Int ":Y.ID
  GOSUB FILL.COMMON.ARRAY

  IF Y.LFG EQ 1 THEN
    R.REDO.CONCAT.ACC.WOF<2> = Y.NEW.AC
  END ELSE
    CALL OCOMO("Interest Customer Contingent Account not created  ":Y.ID)
    GOSUB PGM.END
  END

  RETURN
*-----------------------------------------------------------------------------
FILL.COMMON.ARRAY:
*-----------------------------------------------------------------------------

  R.OFS.ACC<AC.ACCOUNT.TITLE.1>               = R.ACC<AC.ACCOUNT.TITLE.1>
  R.OFS.ACC<AC.CUSTOMER>                      = R.ACC<AC.CUSTOMER>
  R.OFS.ACC<AC.SHORT.TITLE>                   = R.ACC<AC.SHORT.TITLE>
  R.OFS.ACC<AC.CURRENCY>                      = R.ACC<AC.CURRENCY>
  R.OFS.ACC<AC.MNEMONIC>                      = R.ACC<AC.MNEMONIC>
  R.OFS.ACC<AC.POSITION.TYPE>                 = R.ACC<AC.POSITION.TYPE>
  R.OFS.ACC<AC.ACCOUNT.OFFICER>               = R.ACC<AC.ACCOUNT.OFFICER>
  R.OFS.ACC<AC.POSTING.RESTRICT>              = R.ACC<AC.POSTING.RESTRICT>
  R.OFS.ACC<AC.CONTINGENT.INT>                = 'C'
  R.OFS.ACC<AC.LOCAL.REF,POS.AV.BAL>          = R.ACC<AC.LOCAL.REF,POS.AV.BAL>
  R.OFS.ACC<AC.LOCAL.REF,POS.L.LOAN.STATUS>   = '3'
  R.OFS.ACC<AC.LOCAL.REF,POS.L.OD.STATUS>     = R.ACC<AC.LOCAL.REF,POS.L.OD.STATUS>
  R.OFS.ACC<AC.LOCAL.REF,POS.L.OD.STATUS.2>   = R.ACC<AC.LOCAL.REF,POS.L.OD.STATUS.2>
  R.OFS.ACC<AC.LOCAL.REF,POS.OR.RE>           = R.ACC<AC.LOCAL.REF,POS.OR.RE>

  APP.VAL     = 'ACCOUNT'
  OFSFUNCT    = 'I'
  OFS.VER     = 'ACCOUNT,REDO.NAB'
  NO.OF.AUTH  = 0
  AZ.ID       = ''
  GTS.MODE    = ''
  Y.COMPANY   = ID.COMPANY
  ID.COMPANY  = Y.LOAN.COMP
  CALL OFS.BUILD.RECORD(APP.VAL,OFSFUNCT,'PROCESS',OFS.VER,GTS.MODE,NO.OF.AUTH,AZ.ID,R.OFS.ACC,OFS.RECORD)
  ID.COMPANY   = Y.COMPANY
  CALL.INFO    = ''
  CALL.INFO<1> = 'REDO.NAB'
  THE.RESPONSE = ''
  TXN.CMM      = ''
  CALL OFS.CALL.BULK.MANAGER(CALL.INFO,OFS.RECORD,THE.RESPONSE,TXN.CMM)
  Y.AC.DE = FIELD(THE.RESPONSE,',',1)
  Y.NEW.AC = FIELD(Y.AC.DE,'/',1)
  Y.LFG = FIELD(Y.AC.DE,'/',3)

  RETURN
*-----------------------------------------------------------------------------
CHECK.INT.ACCOUNTS:
*-----------------------------------------------------------------------------
* Internal Accounts for WOF created or returned if exist

  IF Y.CR.PRINCIPAL.CATEG AND Y.CR.INTEREST.CATEG ELSE
    CALL OCOMO("Internal WOF Accounts not exist for Loan ":Y.ID)
    GOSUB PGM.END
  END

  CALL CACHE.READ(FN.COMPANY,Y.LOAN.COMP,R.COMP.REC,COM.ERR)
  Y.COMP.DIV.CODE = R.COMP.REC<EB.COM.SUB.DIVISION.CODE>
  Y.INT.ACC.CO = Y.CR.PRINCIPAL.CATEG[LEN(Y.CR.PRINCIPAL.CATEG)-3,4]
  IF Y.COMP.DIV.CODE EQ Y.INT.ACC.CO THEN
    Y.PRINCIPAL.INT.ACC = Y.CR.PRINCIPAL.CATEG
  END ELSE
    Y.PRINCIPAL.INT.ACC = Y.CR.PRINCIPAL.CATEG[1,LEN(Y.CR.PRINCIPAL.CATEG)-4]:Y.COMP.DIV.CODE
    CALL F.READ(FN.ACCOUNT,Y.PRINCIPAL.INT.ACC,R.ACC,F.ACCOUNT,ACC.ERR)

    IF R.ACC ELSE   ;* If account not exist then create.
      CALL INT.ACC.OPEN (Y.PRINCIPAL.INT.ACC,PRETURN.CODE)
    END
  END

  Y.INT.ACC.CO = Y.CR.INTEREST.CATEG[LEN(Y.CR.INTEREST.CATEG)-3,4]
  IF Y.COMP.DIV.CODE EQ Y.INT.ACC.CO THEN
    Y.INTEREST.INT.ACC = Y.CR.INTEREST.CATEG
  END ELSE
    Y.INTEREST.INT.ACC = Y.CR.INTEREST.CATEG[1,LEN(Y.CR.INTEREST.CATEG)-4]:Y.COMP.DIV.CODE
    CALL F.READ(FN.ACCOUNT,Y.INTEREST.INT.ACC,R.ACC,F.ACCOUNT,ACC.ERR)

    IF R.ACC ELSE   ;* If account not exist then create.
      CALL INT.ACC.OPEN (Y.INTEREST.INT.ACC,PRETURN.CODE)
    END
  END
  IF Y.PRINCIPAL.INT.ACC AND Y.INTEREST.INT.ACC ELSE
    CALL OCOMO("Internal WOF Accounts not created for Loan ":Y.ID)
    GOSUB PGM.END
  END


  RETURN

ENTRY.PRINCIPAL:

  AMT = '' ; R.STMT.ENTRY = ''
  Y.CAP.FORM = R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.CAPITAL.TEXT>

  AMT = FIELD(Y.CAP.FORM,'*',1)

  IF AMT EQ '' OR AMT EQ 0 THEN
    RETURN
  END

  DR.ACCOUNT.NUMBER = Y.PRINCIPAL.INT.ACC
  CR.ACCOUNT.NUMBER = R.REDO.CONCAT.ACC.WOF<1>

  R.ACCOUNT.INT = ''
  CALL F.READ(FN.ACCOUNT,DR.ACCOUNT.NUMBER,R.ACCOUNT.INT,F.ACCOUNT,AC.ERR)
  R.DR.STMT.ENTRY = ''
  R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.PRINCIPAL.TXN
  R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF REVERSE PRINCIPAL'

  GOSUB FORM.DEBIT.ENTRY

  R.ACCOUNT.CONT = ''
  CALL F.READ(FN.ACCOUNT,CR.ACCOUNT.NUMBER,R.ACCOUNT.CONT,F.ACCOUNT,AC.ERR)
  R.CR.STMT.ENTRY = ''
  R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.PRINCIPAL.TXN
  R.CR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF REVERSE PRINCIPAL'

  GOSUB FORM.CREDIT.ENTRY

  GOSUB CAL.ACCOUNTING

  RETURN

ENTRY.INTEREST:

  AMT = '' ; R.STMT.ENTRY = '' ; FLG.IN = ''
  Y.INT.FORM = R.REDO.NEW.WORK.INT.CAP.OS<REDO.OS.CIAMT.INTEREST.TEXT>
  AMT = FIELD(Y.INT.FORM,'*',1)

  IF AMT EQ '' OR AMT EQ 0 THEN
    RETURN
  END

  DR.ACCOUNT.NUMBER = Y.INTEREST.INT.ACC
  CR.ACCOUNT.NUMBER = R.REDO.CONCAT.ACC.WOF<2>

  R.ACCOUNT.INT = ''
  CALL F.READ(FN.ACCOUNT,DR.ACCOUNT.NUMBER,R.ACCOUNT.INT,F.ACCOUNT,AC.ERR)

  R.DR.STMT.ENTRY = ''
  R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.INTEREST.TXN
  R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF REVERSE INTEREST'
  GOSUB FORM.DEBIT.ENTRY


  R.ACCOUNT.CONT = ''
  CALL F.READ(FN.ACCOUNT,CR.ACCOUNT.NUMBER,R.ACCOUNT.CONT,F.ACCOUNT,AC.ERR)
  R.CR.STMT.ENTRY = ''
  R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.INTEREST.TXN
  R.CR.STMT.ENTRY<AC.STE.NARRATIVE> = 'WOF REVERSE INTEREST'

  GOSUB FORM.CREDIT.ENTRY

  GOSUB CAL.ACCOUNTING

  RETURN

FORM.DEBIT.ENTRY:


  R.DR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>    = DR.ACCOUNT.NUMBER
  R.DR.STMT.ENTRY<AC.STE.COMPANY.CODE>      = R.ACCOUNT.INT<AC.CO.CODE>
  R.DR.STMT.ENTRY<AC.STE.AMOUNT.LCY>        = AMT * (-1)
  R.DR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY>  = R.ACCOUNT.INT<AC.CATEGORY>
  R.DR.STMT.ENTRY<AC.STE.VALUE.DATE>        = TODAY
  R.DR.STMT.ENTRY<AC.STE.CURRENCY>          = R.ACCOUNT.INT<AC.CURRENCY>
  R.DR.STMT.ENTRY<AC.STE.OUR.REFERENCE>     = R.ACCOUNT.INT<AC.CO.CODE>
  R.DR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>     = TODAY
  R.DR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>   = '1'
  R.DR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>   = DR.ACCOUNT.NUMBER
  R.DR.STMT.ENTRY<AC.STE.SYSTEM.ID>         = 'AC'
  R.DR.STMT.ENTRY<AC.STE.BOOKING.DATE>      = TODAY

  CHANGE FM TO SM IN R.DR.STMT.ENTRY
  CHANGE SM TO VM IN R.DR.STMT.ENTRY

  R.STMT.ENTRY<-1> = R.DR.STMT.ENTRY

  RETURN

FORM.CREDIT.ENTRY:


  R.CR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>    = CR.ACCOUNT.NUMBER
  R.CR.STMT.ENTRY<AC.STE.COMPANY.CODE>      = R.ACCOUNT.CONT<AC.CO.CODE>
  R.CR.STMT.ENTRY<AC.STE.AMOUNT.LCY>        = AMT
  R.CR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY>  = R.ACCOUNT.CONT<AC.CATEGORY>
  R.CR.STMT.ENTRY<AC.STE.VALUE.DATE>        = TODAY
  R.CR.STMT.ENTRY<AC.STE.CURRENCY>          = R.ACCOUNT.CONT<AC.CURRENCY>
  R.CR.STMT.ENTRY<AC.STE.OUR.REFERENCE>     = R.ACCOUNT.CONT<AC.CO.CODE>
  R.CR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>     = TODAY
  R.CR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>   = '1'
  R.CR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>   = CR.ACCOUNT.NUMBER
  R.CR.STMT.ENTRY<AC.STE.SYSTEM.ID>         = 'AC'
  R.CR.STMT.ENTRY<AC.STE.BOOKING.DATE>      = TODAY

  CHANGE FM TO SM IN R.CR.STMT.ENTRY
  CHANGE SM TO VM IN R.CR.STMT.ENTRY

  R.STMT.ENTRY<-1> = R.CR.STMT.ENTRY

  RETURN

CAL.ACCOUNTING:

  ACC.PRODUCT = 'AC'
  ACC.TYPE = 'SAO'

  CALL EB.ACCOUNTING(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')

  RETURN

PGM.END:

END
