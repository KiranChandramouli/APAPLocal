*-----------------------------------------------------------------------------
* <Rating>-91</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOFILE.LOAN.DETS(Y.FINAL.ARR)
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOFILE.LOAN.DETS
*--------------------------------------------------------------------------------------------------------
*Description       : This NOFILE routine is attached to context enquiry REDO.ENQ.LOAN.DETS.This context
*                    enquiry is attached to the field L.CO.CR.DATE in the version COLLATERAL,DOC.RECEPTION
*                    This will fetch the collateral records which have L.CO.CR.DATE less than the given date
*                    and get the required details from the fetched collateral records
*Linked With       : COLLATERAL,DOC.RECEPTION AND COLLATERAL,DOC.MOVEMENT
*In  Parameter     :
*Out Parameter     : Y.FINAL.ARR
*Files  Used       : AA.ARR.TERM.AMOUNT            As          I   Mode
*                    COLLATERAL                    As          I   Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27/05/2010        REKHA S         ODR-2009-10-0310 B.180C      Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
$INSERT I_F.AA.TERM.AMOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

  GOSUB OPEN.PARA
  GOSUB GET.DATE
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
  FN.COLLATERAL = 'F.COLLATERAL'
  F.COLLATERAL = ''
  FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
  F.AA.ARR.TERM.AMOUNT = ''
  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''

  CALL OPF(FN.COLLATERAL,F.COLLATERAL)
  CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  Y.FINAL.ARR = ''
  Y.CUS.NAME = ''
  Y.AMOUNT = ''

  RETURN
*----------------------------------------------------------------------------------------
**********
GET.DATE:
**********
  Y.DATE.POS = ''
  LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
    Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  Y.SEL.COL.CMD = 'SSELECT ':FN.COLLATERAL:" WITH L.CO.CR.DATE LT ":Y.DATE
  CALL EB.READLIST(Y.SEL.COL.CMD,Y.SEL.COL.LIST,'',NO.OF.COL.REC,Y.RET.CO.CODE)
  LOOP
    REMOVE Y.CO.ID FROM Y.SEL.COL.LIST SETTING Y.COL.POS
  WHILE Y.CO.ID:Y.COL.POS
    R.COLLATERAL = ''
    Y.COL.ERR = ''
    CALL F.READ(FN.COLLATERAL,Y.CO.ID,R.COLLATERAL,F.COLLATERAL,Y.COL.ERR)

    IF NOT(R.COLLATERAL) THEN
      CONTINUE
    END

    GOSUB GET.LOC.POS

    Y.REG.DATE = R.COLLATERAL<COLL.LOCAL.REF,Y.REG.DATE.POS>
    Y.CR.DATE = R.COLLATERAL<COLL.LOCAL.REF,Y.CR.DATE.POS>
    GOSUB GET.LOAN.NO

  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------------------'
************
GET.LOAN.NO:
************

  Y.LOAN.COUNT = DCOUNT(R.COLLATERAL<COLL.LOCAL.REF,Y.LOAN.NO.POS>,SM)
  Y.COUNT = 1

  LOOP
  WHILE Y.COUNT LE Y.LOAN.COUNT
    Y.LOAN.NO = R.COLLATERAL<COLL.LOCAL.REF,Y.LOAN.NO.POS,Y.COUNT>
    Y.LOAN.PDT = R.COLLATERAL<COLL.LOCAL.REF,Y.LOAN.PDT.POS,Y.COUNT>

    GOSUB GET.AMOUNT
    GOSUB GET.CUSTOMER
    IF Y.FINAL.ARR EQ '' THEN
      Y.FINAL.ARR = Y.CUS.NAME :'*':Y.LOAN.NO:'*':Y.LOAN.PDT:'*':Y.AMOUNT:'*':Y.REG.DATE:'*':Y.CR.DATE
    END  ELSE
      Y.FINAL.ARR : = FM:Y.CUS.NAME:'*':Y.LOAN.NO:'*':Y.LOAN.PDT:'*':Y.AMOUNT:'*':Y.REG.DATE:'*':Y.CR.DATE
    END

    Y.COUNT += 1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------------------'
************
GET.LOC.POS:
************
  LREF.POS = ''
  LREF.APPL = 'COLLATERAL'
  LREF.FIELDS = 'L.CO.LOAN.NO':VM:'L.CO.LOAN.PROD':VM:'L.CO.REG.DATE':VM:'L.CO.CR.DATE'
  CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
  Y.LOAN.NO.POS  = LREF.POS<1,1>
  Y.LOAN.PDT.POS = LREF.POS<1,2>
  Y.REG.DATE.POS = LREF.POS<1,3>
  Y.CR.DATE.POS  = LREF.POS<1,4>
  RETURN
*------------------------------------------------------------------------------------------
***********
GET.AMOUNT:
***********
  AAR.ID = Y.LOAN.NO
  EFF.DATE = ''
  PROPERTY = ''
  R.CONDITION = ''
  ERR.MSG = ''
  PROP.CLASS = 'TERM.AMOUNT'

  CALL REDO.CRR.GET.CONDITIONS(AAR.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.CONDITION, ERR.MSG)
  Y.AMOUNT =  R.CONDITION<AA.AMT.AMOUNT>

  RETURN
*----------------------------------------------------------------------------------------------
*************
GET.CUSTOMER:
*************
  R.AA.ARRANGEMENT = ''
  Y.ARR.ERR = ''
  CALL F.READ(FN.AA.ARRANGEMENT,Y.LOAN.NO,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ARR.ERR)
  IF R.AA.ARRANGEMENT NE '' AND Y.ARR.ERR EQ '' THEN
    Y.CUSTOMER = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    R.CUSTOMER = ''
    Y.CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF R.CUSTOMER NE '' AND Y.CUS.ERR EQ '' THEN
      Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END
  END
  RETURN
END
