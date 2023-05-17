*-----------------------------------------------------------------------------
* <Rating>78</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE NOFILE.REDO.LOAN.DETS(ARRG.ARRAY)
*----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is the Nofile Enquiry for the Development B16
* The o/p will be downloaded in CSV file
* Product Type is mandatory selection for this Enquiry
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who             Reference            Description
* 19-Jul-10    Kishore.SP      ODR-2009-10-0325      Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.PRODUCT
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.INTEREST
$INSERT I_F.AA.CUSTOMER
$INSERT I_F.AA.INTEREST.ACCRUALS
$INSERT I_F.AA.TERM.AMOUNT
$INSERT I_ENQUIRY.COMMON
*----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB LOCATE.VALUES
  GOSUB SELECT.ARRANGEMENT
  RETURN
*------------------------------------------------------------------------------
INITIALISE:
*----------
*Initialise needed variable
!
  Y.FLAG.ARRG      = ''
  LOC.REF.APPL     = ''
  LOC.REF.FIELDS   = ''
  LOC.REF.POS      = ''
  Y.CAMP.TYPE.POS  = ''
  Y.AFFLI.COMP.POS = ''
  Y.REV.FORM.POS   = ''
  Y.REV.RT.TY.POS  = ''
  Y.FST.REV.DT.POS = ''
  Y.NXT.REV.DT.POS = ''
  Y.LST.REV.DT.POS = ''
  Y.POOL.RATE.POS  = ''
  Y.RT.REV.FRQ.POS = ''
  Y.AA.PROD        = ''
  Y.CURRENCY       = ''
  Y.CAMPAIGN.TYPE  = ''
  Y.AFF.COMPANY    = ''
!
  RETURN
*------------------------------------------------------------------------------
OPEN.FILES:
*----------
!
*Open the necessary Files
!
  FN.AA.PRODUCT = 'F.AA.PRODUCT'
  F.AA.PRODUCT = ''
  CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)
!
  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
!
  FN.AA.ARR.INTEREST = 'F.AA.ARR.INTEREST'
  F.AA.ARR.INTEREST = ''
  CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)
!
  FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'
  F.AA.ARR.CUSTOMER = ''
  CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
!
  FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
  F.AA.INTEREST.ACCRUALS  = ''
  CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
!
  FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
  F.AA.ARR.TERM.AMOUNT = ''
  CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
!
  FN.AA.PRD.DES.CUSTOMER = 'F.AA.PRD.DES.CUSTOMER'
  F.AA.PRD.DES.CUSTOMER = ''
  CALL OPF(FN.AA.PRD.DES.CUSTOMER,F.AA.PRD.DES.CUSTOMER)
!
  RETURN
*------------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
* Locating the Values from the Selection Values
* FORM.REVIEW value is given in fixed selection
* The value will be "Manual"
!
  LOCATE "PRODUCT.TYPE" IN D.FIELDS<1> SETTING Y.PRDTY.POS THEN
    YOPERAND       = D.LOGICAL.OPERANDS<Y.PRDTY.POS>
    Y.AA.PROD      = D.RANGE.AND.VALUE<Y.PRDTY.POS>
  END
!
  LOCATE "CURRENCY" IN D.FIELDS<1> SETTING Y.CCY.POS  THEN
    YOPERAND         = D.LOGICAL.OPERANDS<Y.CCY.POS>
    Y.CURRENCY       = D.RANGE.AND.VALUE<Y.CCY.POS>
  END
!
  LOCATE "CAMPAIGN.TYPE" IN D.FIELDS<1> SETTING  Y.CAMP.POS THEN
    YOPERAND         = D.LOGICAL.OPERANDS<Y.CAMP.POS>
    Y.CAMPAIGN.TYPE  = D.RANGE.AND.VALUE<Y.CAMP.POS>
  END
!
  LOCATE "AFF.COMPANY" IN D.FIELDS<1> SETTING Y.AFF.COM.POS THEN
    YOPERAND         = D.LOGICAL.OPERANDS<Y.AFF.COM.POS>
    Y.AFF.COMPANY    = D.RANGE.AND.VALUE<Y.AFF.COM.POS>
  END
!
  GOSUB GET.LOCAL.VAL.POS
  RETURN
*------------------------------------------------------------------------------
GET.LOCAL.VAL.POS:
*-----------------
*Get the Position all the needed local fields used in the routine
!
  LOC.REF.APPL     =  "AA.PRD.DES.CUSTOMER":FM:"AA.PRD.DES.INTEREST"
  LOC.REF.FIELDS   =  "L.AA.CAMP.TY":VM:"L.AA.AFF.COM":FM:"L.AA.REV.RT.TY":VM:"L.AA.FIR.REV.DT":VM:"L.AA.NXT.REV.DT":VM:"L.AA.LST.REV.DT":VM:"L.AA.POOL.RATE":VM:"L.AA.RT.RV.FREQ":VM:"L.AA.REV.FORM"
  LOC.REF.POS      = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.CAMP.TYPE.POS  = LOC.REF.POS<1,1>
  Y.AFFLI.COMP.POS = LOC.REF.POS<1,2>
  Y.REV.RT.TY.POS  = LOC.REF.POS<2,1>
  Y.FST.REV.DT.POS = LOC.REF.POS<2,2>
  Y.NXT.REV.DT.POS = LOC.REF.POS<2,3>
  Y.LST.REV.DT.POS = LOC.REF.POS<2,4>
  Y.POOL.RATE.POS  = LOC.REF.POS<2,5>
  Y.RT.REV.FRQ.POS = LOC.REF.POS<2,6>
  Y.REVIEW.FORM.POS= LOC.REF.POS<2,7>
!
  RETURN
*------------------------------------------------------------------------------
SELECT.ARRANGEMENT:
*------------------
* Selecting the Arrangements as per the mandatory selection value
!
  SELECT.CMD = "SELECT " :FN.AA.ARRANGEMENT:" WITH PRODUCT EQ ":Y.AA.PROD:' AND ARR.STATUS NE UNAUTH'
  Y.SEL.LIST = ''
  CALL EB.READLIST(SELECT.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.ERR.SELL)
  GOSUB GET.ARRANG.DETAILS
  RETURN
*------------------------------------------------------------------------------
GET.ARRANG.DETAILS:
*------------------
* Get the currency of the Arrangement
!
  LOOP
    REMOVE Y.ARRANG.ID FROM Y.SEL.LIST SETTING Y.POS.ARNG
  WHILE Y.ARRANG.ID:Y.POS.ARNG
    R.AA.ARRANGEMENT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANG.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ARR.ERR)
    Y.ARR.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
!
    GOSUB GET.ARR.CUS.PRO
!
  REPEAT
  RETURN
*------------------------------------------------------------------------------
GET.ARR.CUS.PRO:
*----------------
* Get the customer Details of the particular arraangement
!
  Y.ARRG.ID = Y.ARRANG.ID
  PROPERTY.CLASS = 'CUSTOMER'
  PROPERTY       = ''
  EFF.DATE = ''
  ERR.MSG = ''
  R.CUS.ARR.COND = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.CUS.ARR.COND,ERR.MSG)
  IF R.CUS.ARR.COND NE '' THEN
    Y.AA.CAMP.TYPE  = R.CUS.ARR.COND<AA.CUS.LOCAL.REF><1,Y.CAMP.TYPE.POS>
    Y.AA.AFFLI.COMP  = R.CUS.ARR.COND<AA.CUS.LOCAL.REF><1,Y.AFFLI.COMP.POS>
    GOSUB MATCH.SLECTION
  END
!
  RETURN
*------------------------------------------------------------------------------
MATCH.SLECTION:
*-----------------
* It been filtered as per the Selection made in the Enquiry
!
  BEGIN CASE
!
  CASE Y.CAMPAIGN.TYPE NE '' AND Y.AFF.COMPANY NE '' AND  Y.CURRENCY NE ''

    IF Y.AA.CAMP.TYPE EQ Y.CAMPAIGN.TYPE THEN
      IF Y.AA.AFFLI.COMP EQ  Y.AFF.COMPANY THEN
        IF Y.ARR.CURRENCY EQ Y.CURRENCY THEN
          GOSUB START.PROCESS
        END
      END
    END
!
  CASE Y.CAMPAIGN.TYPE NE '' AND Y.AFF.COMPANY EQ '' AND Y.CURRENCY EQ ''
!
    IF Y.AA.CAMP.TYPE EQ Y.CAMPAIGN.TYPE THEN
      GOSUB START.PROCESS
    END
!
  CASE Y.CAMPAIGN.TYPE NE '' AND Y.AFF.COMPANY NE '' AND Y.CURRENCY EQ ''
    IF Y.AA.CAMP.TYPE EQ Y.CAMPAIGN.TYPE THEN
      IF Y.AA.AFFLI.COMP EQ  Y.AFF.COMPANY THEN
        GOSUB START.PROCESS
      END
    END
!
  CASE Y.CAMPAIGN.TYPE NE '' AND Y.AFF.COMPANY EQ '' AND Y.CURRENCY NE ''
    IF Y.AA.CAMP.TYPE EQ Y.CAMPAIGN.TYPE THEN
      IF Y.ARR.CURRENCY EQ Y.CURRENCY THEN
        GOSUB START.PROCESS
      END
    END
!
  CASE Y.CAMPAIGN.TYPE EQ '' AND Y.AFF.COMPANY NE '' AND Y.CURRENCY NE ''
    IF Y.AA.AFFLI.COMP EQ  Y.AFF.COMPANY THEN
      IF Y.ARR.CURRENCY EQ Y.CURRENCY THEN
        GOSUB START.PROCESS
      END
    END
!
  CASE Y.CAMPAIGN.TYPE EQ '' AND Y.AFF.COMPANY EQ '' AND Y.CURRENCY NE ''
    IF Y.ARR.CURRENCY EQ Y.CURRENCY THEN
      GOSUB START.PROCESS
    END
!
  CASE Y.CAMPAIGN.TYPE EQ '' AND Y.AFF.COMPANY NE '' AND Y.CURRENCY EQ ''
    IF Y.AA.AFFLI.COMP EQ  Y.AFF.COMPANY THEN
      GOSUB START.PROCESS
    END
!
  CASE Y.CAMPAIGN.TYPE EQ '' AND Y.AFF.COMPANY EQ '' AND Y.CURRENCY EQ ''
    GOSUB START.PROCESS
  END CASE
!
  RETURN
*------------------------------------------------------------------------------
START.PROCESS:
*-------------
*Set of process to be done
!
  GOSUB GET.ARR.TERM.PRO
  GOSUB GET.ARR.INT.PRO
  RETURN
*------------------------------------------------------------------------------
GET.ARR.TERM.PRO:
*-----------------
*Get the INIT.AMOUNT amount
!
  Y.ARRG.ID = Y.ARRANG.ID
  PROPERTY.CLASS = 'TERM.AMOUNT'
  PROPERTY = ''
  EFF.DATE = ''
  ERR.MSG = ''
  R.TERM.ARR.COND = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.TERM.ARR.COND,ERR.MSG)
  IF R.TERM.ARR.COND NE '' THEN
    Y.AA.INIT.AMOUNT   = R.TERM.ARR.COND<AA.AMT.AMOUNT>
  END
  RETURN
*------------------------------------------------------------------------------
GET.ARR.INT.PRO:
*---------------
* Get the Interest Property Details of the arrangement
!

  Y.ARRG.ID = Y.ARRANG.ID
  PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
  CALL REDO.GET.INTEREST.PROPERTY(Y.ARRG.ID,PROP.NAME,OUT.PROP,ERR)
  Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

  PROPERTY.CLASS = 'INTEREST'
  PROPERTY = Y.PRIN.PROP
  EFF.DATE = ''
  ERR.MSG = ''
  R.INT.ARR.COND = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
  IF R.INT.ARR.COND NE '' THEN
    Y.REVIEW.FORM        = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.REVIEW.FORM.POS>
    IF Y.REVIEW.FORM EQ 'MANUAL' THEN
      Y.FIRST.REV.DATE     = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.FST.REV.DT.POS>
      Y.NEXT.REV.DATE      = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.NXT.REV.DT.POS>
      Y.LAST.REV.DATE      = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.LST.REV.DT.POS>
      Y.MARGIN.TYPE.ARR    = R.INT.ARR.COND<AA.INT.MARGIN.TYPE>
      Y.MARGIN.OPERAND.ARR = R.INT.ARR.COND<AA.INT.MARGIN.OPER>
      Y.MARGIN.RATE.ARR    = R.INT.ARR.COND<AA.INT.MARGIN.RATE>
      Y.FIXED.RATE.ARR     = R.INT.ARR.COND<AA.INT.FIXED.RATE>
      Y.FLOAT.INDEX.ARR    = R.INT.ARR.COND<AA.INT.FLOATING.INDEX>
      Y.PERIOD.INDEX.ARR   = R.INT.ARR.COND<AA.INT.PERIODIC.INDEX>
      Y.DAY.BASIS.ARR      = R.INT.ARR.COND<AA.INT.DAY.BASIS>
      Y.ACCR.RULE.ARR      = R.INT.ARR.COND<AA.INT.ACCRUAL.RULE>
      Y.BALANCE.TYPE.ARR   = R.INT.ARR.COND<AA.INT.BALANCE.CALC.TYPE>
      Y.RATE.TIER.ARR      = R.INT.ARR.COND<AA.INT.RATE.TIER.TYPE>
      Y.AA.REV.RT.TYPE     = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.REV.RT.TY.POS>
      Y.POOL.RATE          = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.POOL.RATE.POS>
      Y.RATE.REV.FRQ       = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.RT.REV.FRQ.POS>
      GOSUB CHECK.MV.ARRAY
    END
  END
  RETURN
*------------------------------------------------------------------------------
CHECK.MV.ARRAY:
*--------------
  Y.MARG.TYE.CNT = DCOUNT(Y.MARGIN.TYPE.ARR,@VM)
  IF Y.MARG.TYE.CNT NE '' THEN
    Y.CNTR = 1
    X = 1
    LOOP
    WHILE Y.CNTR LE Y.MARG.TYE.CNT
      Y.MARGIN.TYPE = Y.MARGIN.TYPE.ARR<1,Y.CNTR>
      Y.MARGIN.OPERAND = Y.MARGIN.OPERAND.ARR<1,Y.CNTR>
      Y.MARGIN.RATE    = Y.MARGIN.RATE.ARR<1,Y.CNTR>
      Y.FIXED.RATE     = Y.FIXED.RATE.ARR<1,Y.CNTR>
      Y.FLOAT.INDEX    = Y.FLOAT.INDEX.ARR<1,Y.CNTR>
      Y.PERIOD.INDEX   = Y.PERIOD.INDEX.ARR<1,Y.CNTR>
      Y.DAY.BASIS      = Y.DAY.BASIS.ARR<1,Y.CNTR>
      Y.ACCR.RULE      = Y.ACCR.RULE.ARR<1,Y.CNTR>
      Y.BALANCE.TYPE   = Y.BALANCE.TYPE.ARR<1,Y.CNTR>
      Y.RATE.TIER      = Y.RATE.TIER.ARR<1,Y.CNTR>
      Y.AA.REV.RT      = Y.AA.REV.RT.TYPE<1,Y.CNTR>
      Y.AA.RATE.REV.FQ = Y.RATE.REV.FRQ<1,Y.CNTR>


      Y =1
      Z = X:":":Y

      Y.MARGIN.TYPE.FLD.NAME    = "MARGIN.TYPE:":Z
      Y.MARGIN.OPERAND.FLD.NAME = "MARGIN.OPER:":Z
      Y.MARGIN.RATE.FLD.NAME    = "MARGIN.RATE:":Z
      Y.FIXED.RATE.FLD.NAME     = "FIXED.RATE:":Z
      Y.FLOAT.INDEX.FLD.NAME    = "FLOATING.INDEX:":Z
      Y.PERIOD.INDEX.FLD.NAME   = "PERIODIC.INDEX:":Z
      Y.DAY.BASIS.FLD.NAME      = "DAY.BASIS:":Z
      Y.ACCR.RULE.FLD.NAME      = "ACCRUAL.RULE:":Z
      Y.BALANCE.TYPE.FLD.NAME   = "BALANCE.CALC.TYPE:":Z
      Y.RATE.TIER.FLD.NAME      = "RATE.TIER.TYPE:":Z
      Y.AA.REV.RT.FLD.NAME      = "L.AA.REV.RT.TY:":Z
      Y.AA.RATE.REV.FQ.FLD.NAME = "L.AA.RT.RV.FREQ:":Z

      GOSUB RETURN.ARRAY
      X++
      Y.CNTR++

    REPEAT
  END ELSE
    GOSUB RETURN.ARRAY
  END
  RETURN
*------------------------------------------------------------------------------
RETURN.ARRAY:
*-------------
* This is Final Return array and this is made as Enquiry O/P
  IF Y.ARRANG.ID EQ  Y.FLAG.ARRG THEN
    ARRG.ARRAY<-1> = "":"*":"":"*":"":"*":"":"*":"":"*":"":"*":"":"*":"":"*":"":"*":"":"*":"":"*":Y.MARGIN.TYPE.FLD.NAME:"*":Y.MARGIN.TYPE:"*":Y.MARGIN.OPERAND.FLD.NAME:"*":Y.MARGIN.OPERAND:"*":Y.MARGIN.RATE.FLD.NAME:"*":Y.MARGIN.RATE:"*":Y.FIXED.RATE.FLD.NAME:"*":Y.FIXED.RATE:"*":Y.FLOAT.INDEX.FLD.NAME:"*":Y.FLOAT.INDEX:"*":Y.PERIOD.INDEX.FLD.NAME:"*":Y.PERIOD.INDEX:"*":Y.DAY.BASIS.FLD.NAME:"*":Y.DAY.BASIS:"*":Y.ACCR.RULE.FLD.NAME:"*":Y.ACCR.RULE:"*":Y.BALANCE.TYPE.FLD.NAME:"*":Y.BALANCE.TYPE:"*":Y.RATE.TIER.FLD.NAME:"*":Y.RATE.TIER:"*":Y.AA.REV.RT.FLD.NAME:"*":Y.AA.REV.RT:"*":Y.AA.RATE.REV.FQ.FLD.NAME:"*":Y.AA.RATE.REV.FQ

  END ELSE
    ARRG.ARRAY<-1> = Y.ARRANG.ID:"*":Y.AA.PROD:"*":Y.AA.CAMP.TYPE:"*":Y.AA.AFFLI.COMP:"*":Y.AA.INIT.AMOUNT:"*":Y.AA.REV.RT.TYPE:"*":Y.FIRST.REV.DATE:"*":Y.NEXT.REV.DATE:"*":Y.LAST.REV.DATE:"*":Y.POOL.RATE:"*":Y.RATE.REV.FRQ:"*":Y.MARGIN.TYPE.FLD.NAME:"*":Y.MARGIN.TYPE:"*":Y.MARGIN.OPERAND.FLD.NAME:"*":Y.MARGIN.OPERAND:"*":Y.MARGIN.RATE.FLD.NAME:"*":Y.MARGIN.RATE:"*":Y.FIXED.RATE.FLD.NAME:"*":Y.FIXED.RATE:"*":Y.FLOAT.INDEX.FLD.NAME:"*":Y.FLOAT.INDEX:"*":Y.PERIOD.INDEX.FLD.NAME:"*":Y.PERIOD.INDEX:"*":Y.DAY.BASIS.FLD.NAME:"*":Y.DAY.BASIS:"*":Y.ACCR.RULE.FLD.NAME:"*":Y.ACCR.RULE:"*":Y.BALANCE.TYPE.FLD.NAME:"*":Y.BALANCE.TYPE:"*":Y.RATE.TIER.FLD.NAME:"*":Y.RATE.TIER:"*":Y.AA.REV.RT.FLD.NAME:"*":Y.AA.REV.RT:"*":Y.AA.RATE.REV.FQ.FLD.NAME:"*":Y.AA.RATE.REV.FQ
    Y.FLAG.ARRG = Y.ARRANG.ID
  END

  RETURN
*------------------------------------------------------------------------------
END
