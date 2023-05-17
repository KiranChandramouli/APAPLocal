*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.CDT.LINE.REV(Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
*COMPANY NAME: Group Financiero Banorte
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE routine
*------------
*DESCRIPTION:
*------------
*  This routine is attached as NOFILE routine for the ENQUIRY REDO.APAP.CREDIT.LINES.REVIEW
* The routine makes the select over the records of LIMIT based on user selection
* process the same
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : Y.OUT.ARRAY
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 08-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.LIMIT
$INSERT I_F.LIMIT.REFERENCE
$INSERT I_F.CUSTOMER

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN

*---------------------------------------------------------------------------
INITIALISE:
*------------
*Initialise/Open necessary varibles/files

  Y.EXP.DAYS = ''
  EXP.POS = ''
  Y.TODAY = ''
  SEL.CMD = ''
  SEL.LIST = ''
  LIM.POS = ''
  SEL.ERR = ''
  Y.LIM.ID = ''
  LIM.ERR = ''
  Y.DIFF = ''

  FN.LIMIT = 'F.LIMIT'
  F.LIMIT = ''
  CALL OPF(FN.LIMIT,F.LIMIT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.LIMIT.REFERENCE = 'F.LIMIT.REFERENCE'
  F.LIMIT.REFERENCE = ''
  CALL OPF(FN.LIMIT.REFERENCE,F.LIMIT.REFERENCE)

  RETURN

*---------------------------------------------------------------------------
PROCESS:
*-----------
* The section forms the outgoing array based on the user selection equaling the
* fetched field accordingly

  Y.TODAY = TODAY
  LOCATE "EXPIRY.DAYS" IN D.FIELDS<1> SETTING EXP.POS THEN
    Y.EXP.DAYS =  D.RANGE.AND.VALUE<EXP.POS>
    SEL.CMD = 'SELECT ':FN.LIMIT
  END
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  LOOP
    REMOVE Y.LIM.ID FROM SEL.LIST SETTING LIM.POS
  WHILE Y.LIM.ID:LIM.POS
    GOSUB FETCH.VALID.DATE
    Y.DIFF = 'C'
    IF Y.TODAY NE '' AND Y.LIMIT.EXP NE '' THEN
      CALL CDD('',Y.TODAY,Y.LIMIT.EXP,Y.DIFF)
    END
    IF Y.EXP.DAYS EQ Y.DIFF THEN
      GOSUB FORM.ARRAY
    END
  REPEAT
  RETURN

*---------------------------------------------------------------------------
FETCH.VALID.DATE:
*----------------
* Reads the local template "REDO.APAP.USER.LIMITS" and fetchs the required values
* (i.e.)TRA.LIM.VALID.DATE

  R.LIMIT = ''
  CALL F.READ(FN.LIMIT,Y.LIM.ID,R.LIMIT,F.LIMIT,LIM.ERR)
  Y.LIMIT.EXP = R.LIMIT<LI.EXPIRY.DATE>
  RETURN

*---------------------------------------------------------------------------
FORM.ARRAY:
*-----------
* The section forms the outgoing array for the enquiry output

  Y.LIMIT.CUST = FIELD(Y.LIM.ID,'.',1,1)
  Y.LIM.REF.ID = FIELD(Y.LIM.ID,'.',2,1)
  CALL F.READ(FN.CUSTOMER,Y.LIMIT.CUST,R.CUST,F.CUSTOMER,CUS.ERR)
  Y.LIAB.CUST = R.CUST<EB.CUS.SHORT.NAME>
  Y.LIM.REF.ID = TRIM(Y.LIM.REF.ID,"0","L")
  CALL F.READ(FN.LIMIT.REFERENCE,Y.LIM.REF.ID,R.LIM.REF,F.LIMIT.REFERENCE,REF.ERR)
  Y.REFER.NAME = R.LIM.REF<LI.REF.SHORT.NAME>
  Y.CCY = R.LIMIT<LI.LIMIT.CURRENCY>
  Y.LIM.AMT = R.LIMIT<LI.ONLINE.LIMIT>
  Y.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>
  Y.EXC.DATE = Y.DIFF

  Y.OUT.ARRAY<-1> = Y.LIM.ID:"*":Y.LIAB.CUST:"*":Y.REFER.NAME:"*":Y.CCY:"*":Y.LIM.AMT:"*":Y.AVAIL.AMT:"*":Y.EXC.DATE
  Y.LIM.ID = ''
  Y.LIAB.CUST = ''
  Y.REFER.NAME = ''
  Y.CCY = ''
  Y.LIM.AMT = ''
  Y.AVAIL.AMT = ''
  Y.EXC.DATE = ''
  Y.LIMIT.CUST = ''
  Y.LIM.REF.ID = ''
  RETURN

*---------------------------------------------------------------------------
END
