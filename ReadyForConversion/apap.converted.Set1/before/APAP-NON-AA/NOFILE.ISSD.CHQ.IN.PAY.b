*-----------------------------------------------------------------------------
* <Rating>71</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE NOFILE.ISSD.CHQ.IN.PAY(Y.RETURN.ARRAY)
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is the Nofile Routine which gives the list of cheques issued
* towards the interest payment on behalf of the customer
*
*-----------------------------------------------------------------------------
* Dependencies:
*---------------
* CALLS : E.STMT.ENQ.BY.CONCAT
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 13-AUG-10    Kishore.SP            INITIALVERSION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_F.CUSTOMER
$INSERT I_F.RELATION
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.L.ADMIN.DEP.DETS
*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB LOCATE.VALUES
  GOSUB GET.SEL.CMD

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*----------
* Intialise the variables
* Open the necessary files
!
  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
!
  FN.ACCOUNT    = 'F.ACCOUNT'
  F.ACCOUNT     = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.L.ADMIN.DEP.DETS = 'F.REDO.L.ADMIN.DEP.DETS'
  F.REDO.L.ADMIN.DEP.DETS = ''
  CALL OPF(FN.REDO.L.ADMIN.DEP.DETS, F.REDO.L.ADMIN.DEP.DETS)

  FN.FUNDS.TRANSFER  = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER   =  ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER.HIST = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIST  = ''
  CALL OPF(FN.FUNDS.TRANSFER.HIST,F.FUNDS.TRANSFER.HIST)

!
*    FN.TELLER     = 'F.TELLER'
*    F.TELLER      = ''
*    CALL OPF(FN.TELLER,F.TELLER)
!
  FN.CUSTOMER   = 'F.CUSTOMER'
  F.CUSTOMER    = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
!
  FN.RELATION   = 'F.RELATION'
  F.RELATION    = ''
  CALL OPF(FN.RELATION,F.RELATION)
!
  LOC.REF.APPL     =  "AZ.ACCOUNT":FM:"CUSTOMER"
  LOC.REF.FIELDS   =  "L.TYPE.INT.PAY":FM:"L.CU.TIPO.CL"
  LOC.REF.POS      = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.AC.PAYMD.POS  = LOC.REF.POS<1,1>
  Y.CLI.TYPE.POS = LOC.REF.POS<2,1>

!
  Y.TIME.DATE        = TIMEDATE()
  Y.TIME             = Y.TIME.DATE[1,8]
  Y.DATE.RNG         = ''
  Y.SDATE            = ''
  Y.EDATE            = ''
  Y.RET.ARRAY        = ''
  Y.ARRAY        = ''
  Y.SEL.CO.CODE      = ''
  Y.SEL.CATEG        = ''
  Y.JOINT.HOLDERS    = ''
  Y.TOT.INV.AMT      = ''
  Y.TOT.PAID.INT.AMT = ''
  Y.TOT.CHQ.AMT      = ''
  Y.INV.SUB.AMT      = ''
  Y.PAID.SUB.AMT     = ''
  Y.CHQ.SUB.AMT      = ''
  Y.OLD.AGENCY       = ''
  Y.NEW.AGENCY       = ''
  Y.INT.AMT          = ''
  Y.CHQ.NUMBER       = ''
  Y.ISSD.DATE        = ''
  Y.CHQ.AMT          = ''
  Y.INP.USER         = ''
  Y.AUTH.USER        = ''
  Y.SEL.DEPOSIT      = ''

  RETURN
*-----------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
* Locate the values from selection criteria
!
  LOCATE "DATE.RANGE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
    Y.DATE.OPER     = D.LOGICAL.OPERANDS<Y.DATE.POS>
    Y.DATE.RNG      = D.RANGE.AND.VALUE<Y.DATE.POS>
    Y.SDATE         = FIELD(Y.DATE.RNG,SM,1)
    Y.EDATE         = FIELD(Y.DATE.RNG,SM,2)
  END
!
  LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
    Y.AGEN.OPER     = D.LOGICAL.OPERANDS<Y.AGENCY.POS>
    Y.SEL.CO.CODE   = D.RANGE.AND.VALUE<Y.AGENCY.POS>
  END
!
  LOCATE "INVESTMENT.TYPE" IN D.FIELDS<1> SETTING Y.INV.TY.POS THEN
    YOPERAND        = D.LOGICAL.OPERANDS<Y.INV.TY.POS>
    Y.SEL.CATEG     = D.RANGE.AND.VALUE<Y.INV.TY.POS>
  END

!
*LOCATE "DEPOSIT.ID" IN D.FIELDS<1> SETTING Y.DEPOSIT.POS THEN
*    Y.DEPOSIT.OPERAND        = D.LOGICAL.OPERANDS<Y.DEPOSIT.POS>
*Y.SEL.DEPOSIT     = D.RANGE.AND.VALUE<Y.DEPOSIT.POS>
*END

!
* To get the values in the header for classification
!
  IF D.RANGE.AND.VALUE EQ "''" THEN
    Y.CLASSIFICATION = ''
  END ELSE
    Y.RANGE.CLASS = D.RANGE.AND.VALUE
    CHANGE FM TO "" IN Y.RANGE.CLASS
    Y.CLASSIFICATION   = Y.RANGE.CLASS
  END
  Y.FLAG = ''
!
  RETURN
*-----------------------------------------------------------------------------
GET.SEL.CMD:
*-----------
* Depending upon the selection criteria form the select statement
!

  BEGIN CASE

  CASE Y.DATE.RNG NE '' AND Y.SEL.CO.CODE NE '' AND Y.SEL.CATEG NE ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CHQ.ISS.DATE GE 'Y.SDATE:' AND CHQ.ISS.DATE LE ':Y.EDATE:' AND WITH CO.CODE  EQ ':Y.SEL.CO.CODE:' AND WITH CATEGORY EQ ':Y.SEL.CATEG


  CASE Y.DATE.RNG EQ '' AND Y.SEL.CO.CODE EQ '' AND Y.SEL.CATEG NE ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CATEGORY EQ ":Y.SEL.CATEG:" AND WITH @ID EQ ":Y.SEL.DEPOSIT:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CATEGORY EQ ":Y.SEL.CATEG:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CATEGORY EQ ':Y.SEL.CATEG

*        Y.DATE.RNG      = TODAY
*        Y.DATE.OPER     = '1'
*        Y.SDATE         = TODAY
*        Y.EDATE         = TODAY

  CASE Y.DATE.RNG EQ '' AND Y.SEL.CO.CODE NE '' AND Y.SEL.CATEG EQ ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH @ID EQ ":Y.SEL.DEPOSIT:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CO.CODE EQ ":Y.SEL.CO.CODE:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CO.CODE EQ ':Y.SEL.CO.CODE

*        Y.DATE.RNG      = TODAY
*        Y.DATE.OPER     = '1'
*        Y.SDATE         = TODAY
*        Y.EDATE         = TODAY

  CASE Y.DATE.RNG EQ '' AND Y.SEL.CO.CODE NE '' AND Y.SEL.CATEG NE ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CO.CODE EQ ':Y.SEL.CO.CODE:' AND WITH CATEGORY EQ ':Y.SEL.CATEG

*        Y.DATE.RNG      = TODAY
*        Y.DATE.OPER     = '1'
*        Y.SDATE         = TODAY
*        Y.EDATE         = TODAY

  CASE Y.DATE.RNG NE '' AND Y.SEL.CO.CODE EQ '' AND Y.SEL.CATEG EQ ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH @ID EQ ":Y.SEL.DEPOSIT:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CHQ.ISS.DATE GE ':Y.SDATE:' AND LE CHQ.ISS.DATE LE ':Y.EDATE

  CASE Y.DATE.RNG NE '' AND Y.SEL.CO.CODE EQ '' AND Y.SEL.CATEG NE ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CATEGORY EQ ":Y.SEL.CATEG:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CATEGORY EQ ':Y.SEL.CATEG:' AND WITH CHQ.ISS.DATE GE ':Y.SDATE:' WITH CHQ.ISS.DATE LE ':Y.EDATE


  CASE Y.DATE.RNG NE '' AND Y.SEL.CO.CODE NE '' AND Y.SEL.CATEG EQ ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CO.CODE EQ ":Y.SEL.CO.CODE:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GE ":Y.SDATE:" AND MATURITY.DATE LE ":Y.EDATE:" AND WITH CO.CODE EQ ":Y.SEL.CO.CODE:" WITH L.TYPE.INT.PAY EQ Admin.check"
    SELECT.CMD = 'SELECT ':FN.REDO.L.ADMIN.DEP.DETS:' WITH CO.CODE EQ ':Y.SEL.CO.CODE:' AND WITH CHQ.ISS.DATE GE ':Y.SDATE:' WITH CHQ.ISS.DATE LE ':Y.EDATE



  CASE Y.DATE.RNG EQ '' AND Y.SEL.CO.CODE EQ '' AND Y.SEL.CATEG EQ ''

*        SELECT.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH @ID EQ ":Y.SEL.DEPOSIT:" AND WITH INTEREST.LIQU.ACCT NE '' BY CO.CODE "
    SELECT.CMD = "SELECT ":FN.REDO.L.ADMIN.DEP.DETS

*        Y.DATE.RNG      = TODAY
*        Y.DATE.OPER     = '1'
**        Y.SDATE         = TODAY
*        Y.EDATE         = TODAY

  END CASE

  GOSUB READ.FZ.ACCT
!
  RETURN
*-----------------------------------------------------------------------------
READ.FZ.ACCT:
*------------
* Remove each record from select list and read the AZ account
!
  SEL.LIST = ''
  CALL EB.READLIST(SELECT.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.ERR.SELL)

*    LOOP
*        REMOVE Y.AZ.ID FROM Y.SEL.LIST SETTING Y.AZ.POS
*    WHILE Y.AZ.ID:Y.AZ.POS
*        R.AZ.ACCOUNT = ''
*        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
*        IF R.AZ.ACCOUNT NE '' THEN
*            Y.AGENCY          = R.AZ.ACCOUNT<AZ.CO.CODE>
*            Y.INSTRUMENT.TYPE = R.AZ.ACCOUNT<AZ.CATEGORY>
*            Y.INV.NUMBER      = Y.AZ.ID
*            Y.INV.AMOUNT      = R.AZ.ACCOUNT<AZ.PRINCIPAL>
*            Y.CURRENCY        = R.AZ.ACCOUNT<AZ.CURRENCY>
*            Y.AZ.INT.LIQ.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
*            GOSUB CHECK.PAY.MODE
*        END



  LOOP
    REMOVE Y.CHQ.DET.ID FROM Y.SEL.LIST SETTING  Y.CHQ.DET.ID.POS
  WHILE Y.CHQ.DET.ID:Y.CHQ.DET.ID.POS
    Y.READ.ERR = ''
    R.ADMIN.CHQ.DET = ''
    CALL F.READ(FN.REDO.L.ADMIN.DEP.DETS, Y.CHQ.DET.ID, R.ADMIN.CHQ.DET, F.REDO.L.ADMIN.DEP.DETS, Y.READ.ERR)

    Y.AGENCY.CODE = R.ADMIN.CHQ.DET<RE.ADM.DEP.CO.CODE>     ;*
    Y.TYPE.OF.DEPOSIT = R.ADMIN.CHQ.DET<RE.ADM.DEP.CATEGORY>          ;*
    Y.DEPOSIT.NUMBER = R.ADMIN.CHQ.DET<RE.ADM.DEP.AZ.ID>    ;*
    Y.CCY = R.ADMIN.CHQ.DET<RE.ADM.DEP.CURRENCY>  ;*

    Y.READ.ERR = ''
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT, Y.DEPOSIT.NUMBER, R.ACCOUNT, F.ACCOUNT, Y.READ.ERR)

    Y.READ.ERR = ''
    R.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT , Y.DEPOSIT.NUMBER, R.AZ.ACCOUNT, F.AZ.ACCOUNT ,Y.READ.ERR)

    GOSUB INVEST.CUS.NAME     ;* Fetch deposit beneficiary name          ;*

    Y.ACC.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER> ;*
    Y.DEPOSIT.AMOUNT = R.AZ.ACCOUNT<AZ.PRINCIPAL> ;*
    Y.PAID.INTEREST = R.ADMIN.CHQ.DET<RE.ADM.DEP.CHQ.AMOUNT>          ;*
    Y.CHQEUE.NUMBER = R.ADMIN.CHQ.DET<RE.ADM.DEP.CHQ.NNUMBER>         ;*
    Y.ISSUED.DATE = R.ADMIN.CHQ.DET<RE.ADM.DEP.CHQ.ISS.DATE>          ;*
    Y.CHQ.AMOUNT = R.ADMIN.CHQ.DET<RE.ADM.DEP.CHQ.AMOUNT>   ;*
    Y.BENEF.NAME = R.ADMIN.CHQ.DET<RE.ADM.DEP.BENEF.NAME>   ;*
    CHANGE SM TO '' IN Y.BENEF.NAME
    Y.LEN.NAME = LEN(Y.BENEF.NAME)
    Y.INPUTTER = R.ADMIN.CHQ.DET<RE.ADM.DEP.ISSUER>         ;*

    Y.AUTHORISER = R.ADMIN.CHQ.DET<RE.ADM.DEP.AUTHORISER>   ;*
    IF NOT(Y.AUTHORISER) THEN
      CALL F.READ(FN.FUNDS.TRANSFER,Y.CHQ.DET.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
      IF R.FUNDS.TRANSFER THEN
        Y.AUTHORISER = R.FUNDS.TRANSFER<FT.AUTHORISER>
        Y.AUTHORISER = FIELD(R.FUNDS.TRANSFER<FT.AUTHORISER>,'_',2)
      END ELSE
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIST,Y.CHQ.DET.ID,R.FUNDS.TRANSFER.HIST,FT.HIST.ERR)
        Y.AUTHORISER = FIELD(R.FUNDS.TRANSFER.HIST<FT.AUTHORISER>,'_',2)
      END
    END


    Y.RETURN.ARRAY<-1> = Y.AGENCY.CODE:'*':Y.TYPE.OF.DEPOSIT:'*':Y.DEPOSIT.NUMBER:'*':Y.CCY:'*':JOINT.HOLDERS:'*':Y.ACC.OFFICER:'*':Y.DEPOSIT.AMOUNT:'*':Y.PAID.INTEREST:'*':Y.CHQEUE.NUMBER:'*':Y.ISSUED.DATE:'*':Y.CHQ.AMOUNT:'*':Y.BENEF.NAME:'*':Y.INPUTTER:'*':Y.AUTHORISER

    Y.AGENCY.CODE = '' ; Y.TYPE.OF.DEPOSIT = ''; Y.DEPOSIT.NUMBER = '';
    Y.CCY = '' ; JOINT.HOLDERS = '' ; Y.ACC.OFFICER = '';
    Y.DEPOSIT.AMOUNT = '' ; Y.PAID.INTEREST = '' ; Y.CHQEUE.NUMBER = '' ;
    Y.ISSUED.DATE = '' ; Y.CHQ.AMOUNT = '' ; Y.BENEF.NAME = '';
    Y.INPUTTER = '' ;Y.AUTHORISER = ''


  REPEAT

  RETURN
*-----------------------------------------------------------------------------
*CHECK.PAY.MODE:
*--------------
* Read the account table using the interest Liq account of AZ
!
*
*
*    Y.ACCOUNT.ID = Y.AZ.ID
*    R.ACCOUNT = ''
*    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
*    IF R.ACCOUNT NE '' THEN
*        Y.ACT.NAME = R.ACCOUNT<AC.SHORT.TITLE>
*        Y.ACCT.OFF = R.ACCOUNT<AC.ACCOUNT.OFFICER>
*        Y.INT.LIQ.ACCT = R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
*        Y.AC.PAY.MODE  = R.ACCOUNT<AC.LOCAL.REF><1,Y.AC.PAYMD.POS>
*        Y.AC.PAY.MODE = R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.AC.PAYMD.POS>
*        Y.REL.CODE.ARR = R.ACCOUNT<AC.RELATION.CODE>
!
* Checks if the payment mode is " Admin Check " if so proceeds
!
*        IF Y.AC.PAY.MODE EQ "Admin.check" THEN
*            GOSUB INVEST.CUS.NAME
*            CHANGE FM TO VM IN Y.JOINT.HOLDERS
*            Y.FLAG = ''
*
*            GOSUB CHECK.STMT.ENT.BK
*        END
*    END
*    RETURN
*-----------------------------------------------------------------------------
INVEST.CUS.NAME:
*---------------
* Forming relation name and the joint hoders name
!
  Y.REL.CODE.ARR = R.ACCOUNT<AC.RELATION.CODE>
  Y.AC.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

  Y.READ.ERR = ''
  R.CUSTOMER = ''
  CALL F.READ(FN.CUSTOMER, Y.AC.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.READ.ERR)

  Y.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.CLI.TYPE.POS>

  IF Y.CLIENT.TYPE EQ "PERSONA JURDICIA" THEN
    Y.JOINT.HOLDERS = R.CUSTOMER<EB.CUS.NAME.1>:" ":R.CUSTOMER<EB.CUS.NAME.2>
  END ELSE
    Y.JOINT.HOLDERS = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END

  Y.REL.COD.CNT = DCOUNT(Y.REL.CODE.ARR,@VM)
  Y.REL.CNTR = 1
  LOOP
  WHILE Y.REL.CNTR LE Y.REL.COD.CNT
    Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE><1,Y.REL.CNTR>
!
* Read the relation table using Y.REL.CODE as ID
* Get the relation description
!
    R.RELATION = ''
    CALL F.READ(FN.RELATION,Y.REL.CODE,R.RELATION,F.RELATION,Y.REL.ERR)
    IF R.RELATION NE '' THEN
      Y.REL.NAME = R.RELATION<EB.REL.DESCRIPTION>
!
      IF Y.REL.CODE GE '500' AND Y.REL.CODE LE '529' THEN
        Y.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER><1,Y.REL.CNTR>
!
* Read the customer record using Y.JOINT.HOLD as a ID
* Get the Short name
!
        R.CUSTOMER = ''
        CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
!
        Y.JOINT.HOLDERS<-1> = Y.REL.NAME:" ":Y.SHORT.NAME
      END
    END
    Y.REL.CNTR++
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
*CHECK.STMT.ENT.BK:
*-----------------
* An Core Nofile Routine is used to get the transactions done on a particular account
* Interest liq account and date from selection criteria is passed
!
*
*
*    D.FIELDS<1> = 'ACCOUNT'
*    D.FIELDS<2> = 'BOOKING.DATE'
!
  D.LOGICAL.OPERANDS<1> = '1'
*    D.LOGICAL.OPERANDS<2> = Y.DATE.OPER
!
*    D.RANGE.AND.VALUE<1> = Y.AZ.INT.LIQ.ACCT
*    D.RANGE.AND.VALUE<2> = Y.DATE.RNG
!
*    Y.ID.LIST = ''
*    CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
!
* Remove each array from the output array
* Six position delimited by "*" from each array is the transaction ID
* If that transaction isa teller transaction proceed
!
*    IF Y.ID.LIST NE '' THEN
*
*        LOOP
*            Y.KEY.ID  = ''
*            REMOVE Y.KEY.ID FROM Y.ID.LIST SETTING Y.KEY.POS
*        WHILE Y.KEY.ID:Y.KEY.POS
*
*            Y.TXN.ID = FIELD(Y.KEY.ID,"*",6)
*            Y.TT.ID  = Y.TXN.ID[1,2]
!
* This is FT
*
*            IF Y.TT.ID EQ 'TT' THEN
*                GOSUB GET.TT.DETAILS
*            END
!
*        REPEAT
*        IF NOT(Y.FLAG) THEN
*            GOSUB FORM.ARRAY
*        END
*    END
*    RETURN
*-----------------------------------------------------------------------------
*GET.TT.DETAILS:
*--------------
* Once the teller Transaction is found read the teller record
* Get the needed values
!
*    R.TELLER     = ''
*    CALL F.READ(FN.TELLER,Y.TXN.ID,R.TELLER,F.TELLER,Y.TT.ERR)
*    IF R.TELLER NE '' THEN
*        Y.CHQ.NUMBER    = R.TELLER<TT.TE.CHEQUE.NUMBER>
**        Y.INT.AMT       = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
*        Y.ISSD.DATE     = R.TELLER<TT.TE.VALUE.DATE.1>
*        Y.CHQ.AMT       = Y.INT.AMT
*        Y.CHQ.PAYEE     = Y.JOINT.HOLDERS
*        Y.INP.USER      = R.TELLER<TT.TE.INPUTTER>
*        Y.AUTH.USER     = R.TELLER<TT.TE.AUTHORISER>
*        Y.FLAG = 1
*        GOSUB FORM.ARRAY
*    END
*    RETURN
*-----------------------------------------------------------------------------
FORM.ARRAY:
*------------
* The array is formed for each AZ account
!
*    IF Y.RETURN.ARRAY NE '' THEN
*    Y.RETURN.ARRAY<-1> = Y.AGENCY:"*":Y.INSTRUMENT.TYPE:"*":Y.INV.NUMBER:"*":Y.CURRENCY:"*":Y.JOINT.HOLDERS:"*":Y.ACCT.OFF:"*":Y.INV.AMOUNT:"*":Y.INT.AMT:"*":Y.CHQ.NUMBER:"*":Y.ISSD.DATE:"*":Y.CHQ.AMT:"*":Y.JOINT.HOLDERS:"*":Y.INP.USER:"*":Y.AUTH.USER:"*":Y.TIME:"*":Y.CLASSIFICATION
*    END ELSE
*        Y.RETURN.ARRAY = Y.AGENCY:"*":Y.INSTRUMENT.TYPE:"*":Y.INV.NUMBER:"*":Y.CURRENCY:"*":Y.JOINT.HOLDERS:"*":Y.ACCT.OFF:"*":Y.INV.AMOUNT:"*":Y.INT.AMT:"*":Y.CHQ.NUMBER:"*":Y.ISSD.DATE:"*":Y.CHQ.AMT:"*":Y.JOINT.HOLDERS:"*":Y.INP.USER:"*":Y.AUTH.USER:"*":Y.TIME:"*":Y.CLASSIFICATION
*    END
!
*    Y.JOINT.HOLDERS = ''
*    Y.CHQ.NUMBER    = ''
*    Y.INT.AMT       = ''
*    Y.ISSD.DATE     = ''
*    Y.CHQ.AMT       = ''
*    Y.CHQ.PAYEE     = ''
*    Y.INP.USER      = ''
*    Y.AUTH.USER     = ''
*!
*    RETURN
END
