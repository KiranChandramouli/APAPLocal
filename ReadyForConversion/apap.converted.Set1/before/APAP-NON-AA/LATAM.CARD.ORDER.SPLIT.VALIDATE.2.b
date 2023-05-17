*-----------------------------------------------------------------------------
* <Rating>83</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.ORDER.SPLIT.VALIDATE.2
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.VALIDATE.2
*--------------------------------------------------------------------------------------------------------
*Description  : Validation routine for LATAM.CARD.ORDER
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CARD.CHARGE
$INSERT I_F.DATES
$INSERT I_F.PAYMENT.STOP.TYPE
$INSERT I_F.CARD.TYPE
$INSERT I_F.CARD.STATUS
$INSERT I_F.COMPANY
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CARD.REPAYMENT.DATE
$INSERT I_F.CARD.BILL.CLOSE.DATE
$INSERT I_F.MNEMONIC.COMPANY
$INSERT I_F.MNEMONIC.DAO
$INSERT I_F.DEPT.ACCT.OFFICER
$INSERT I_F.LOCAL.TABLE
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_GTS.COMMON
*  End of core includes
$INSERT I_F.LATAM.CARD.ORDER
$INSERT I_F.LATAM.CARD.CLASS.CODE
*----------------------------------------------------------------------------------------------------------



  GOSUB INIT.PARA
  GOSUB PROCESS.PARA
  RETURN
*-------------------------------------------
INIT.PARA:
*Necessary variables and file variables are initialised and opened
  DFQU = ''
  DFQU1 = ''
  COM.DFQ = ''

  LCY.AMT = ""

  ERROR.FLAG = 0
  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
  CARD.TYPE.ID = FIELD(ID.NEW,'.',1)
  CALL F.READ(FN.CARD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,Y.ERR.CT)

  RETURN
*-----------------------------------------------------
PROCESS.PARA:
* Main Processing section, validation of repay date and bill close date

  Y.REPAY.DATE = R.NEW(CARD.IS.REPAY.DATE)
  GOSUB GET.REPAY.DATE

  Y.BILL.CLOSE.DATE = R.NEW(CARD.IS.BILLING.CLOSE)
  GOSUB GET.BILL.CLOSE.DATE

  RETURN
*----------------------------------------
**************
GET.REPAY.DATE:
**************
* Validation of repay date is performed in this para

  DFQU = Y.REPAY.DATE[9,5]
  BEGIN CASE
  CASE Y.REPAY.DATE EQ ''
    GOSUB CHECK.FOR.AZ.PRODUCT
    IF ER THEN
      AF = CARD.IS.REPAY.DATE
      ETEXT = ER
      CALL STORE.END.ERROR
      RETURN
    END
*
  CASE Y.REPAY.DATE NE ''
    Y.COMI1 = Y.REPAY.DATE
    R.NEW(CARD.IS.ORIG.REPAY.DATE) = Y.COMI1
    Y.NEW.COMI = Y.REPAY.DATE
    GOSUB CHECK.FOR.HOLIDAY
    R.NEW(CARD.IS.REPAY.DATE) = Y.NEW.COMI

  END CASE

  RETURN
*-----------------------------------------------------------------------------------
*******************
GET.BILL.CLOSE.DATE:
*******************
*Validation for the date entered in BILL.CLOSE field is performed in this para

  YDAYS = ''
  REP.DATE = R.NEW(CARD.IS.REPAY.DATE)[1,8]
  DFQU = R.NEW(CARD.IS.REPAY.DATE)[9,12]
  ER=''
  GOSUB CALC.YDAYS
  IF ER THEN
    AF = CARD.IS.BILLING.CLOSE
    ETEXT= ER
    CALL STORE.END.ERROR
    RETURN
  END

  LOC.REGION = R.COMPANY(EB.COM.LOCAL.COUNTRY)
  IF LOC.REGION = "" THEN
    LOC.REGION = R.COMPANY(EB.COM.LOCAL.REGION)
  END ELSE
    LOC.REGION = LOC.REGION:"00"
  END
  IF YDAYS AND REP.DATE THEN
    CALL CDT(LOC.REGION,REP.DATE,YDAYS)
    IF DFQU[1,1] EQ 'M' THEN
      Y.BILL.CLOSE.DATE = REP.DATE:DFQU[1,3]:REP.DATE[7,2]
    END ELSE
      Y.BILL.CLOSE.DATE = REP.DATE:DFQU
    END
    V$DISPLAY = Y.BILL.CLOSE.DATE
  END ELSE
    IF REP.DATE THEN
      IF DFQU[1,1] EQ 'M' THEN
        Y.BILL.CLOSE.DATE = REP.DATE:DFQU[1,3]:REP.DATE[7,2]
      END ELSE
        Y.BILL.CLOSE.DATE = REP.DATE:DFQU
      END
    END
  END
  IF Y.BILL.CLOSE.DATE THEN
    Y.BILL.CLOSE.DATE1 = Y.BILL.CLOSE.DATE
    COM.DFQ = Y.BILL.CLOSE.DATE1[9,5]
    R.NEW(CARD.IS.ORIG.BILLING.CLOSE) = Y.BILL.CLOSE.DATE1
    Y.NEW.COMI = Y.BILL.CLOSE.DATE
    GOSUB CHECK.FOR.HOLIDAY
    Y.BILL.CLOSE.DATE = Y.NEW.COMI
  END
  IF Y.BILL.CLOSE.DATE EQ '' THEN
    GOSUB CHECK.FOR.AZ.PRODUCT
    IF ER THEN
      AF = CARD.IS.BILLING.CLOSE
      ETEXT = ER
      CALL STORE.END.ERROR
      RETURN
    END
  END
  IF Y.BILL.CLOSE.DATE THEN
    ER=''
    GOSUB CHECK.BILL.CLOSE.DATE

    IF ER THEN
      AF = CARD.IS.BILLING.CLOSE
      ETEXT = ER
      CALL STORE.END.ERROR
    END
  END

  IF COM.DFQ[1,1] EQ 'M' THEN
    Y.BILL.CLOSE.DATE = Y.BILL.CLOSE.DATE[1,8]:COM.DFQ
  END

  R.NEW(CARD.IS.BILLING.CLOSE) = Y.BILL.CLOSE.DATE

  RETURN
*------------------------------------------------------------------------------------------
*********************
CHECK.BILL.CLOSE.DATE:
*********************
  IF Y.BILL.CLOSE.DATE LT TODAY THEN
    ER = "ST-RTN.NOT.LESS.THAN.TODAY"
    RETURN
  END
  IF Y.BILL.CLOSE.DATE GT R.NEW(CARD.IS.REPAY.DATE) AND R.NEW(CARD.IS.REPAY.DATE) NE '' THEN
    ER = "ST-RTN.GRT.REPAY.DATE"
    RETURN
  END
  RETURN
**************************
CHECK.FOR.AZ.PRODUCT:
**************************
  R.CARD.TYPE = ''
* CRD.TYP.ID = FIELD(ID.NEW,'.',1)
*CALL DBR("CARD.TYPE":FM:CARD.TYPE.AZ.PRODUCT:FM:"L",CRD.TYP.ID,R.CARD.TYPE)
  Y.AZ.CARD.TYPE = R.CARD.TYPE<CARD.TYPE.AZ.PRODUCT>
  IF Y.AZ.CARD.TYPE NE '' THEN
    ER = "ST-RTN.MANDATORY.INPUT.CARD.TYPE"
  END ELSE
    ER = ''
  END
  RETURN
******************************
CHECK.FOR.HOLIDAY:
****************************
  REGION.CODE = ''
  COUNTRY.CD = ''

*CALL DBR("CARD.TYPE":FM: CARD.TYPE.FORWARD.BACKWARD,CARD.TYPE.ID,FWD.BWK.IND)
*FWD.BWK.IND = '1'
  FWD.BWK.IND =  R.CARD.TYPE<CARD.TYPE.FORWARD.BACKWARD>
  DAYTYPE = ''
  SAVE.COMI = Y.NEW.COMI[1,8]
  CYCLED.DATES = ""
  IF COUNTRY.CD = "" THEN COUNTRY.CD = ID.COMPANY
  IF REGION.CODE = '' THEN
    LOCAL.COUNTRY = R.COMPANY(EB.COM.LOCAL.COUNTRY)
    LOCAL.REGION = R.COMPANY(EB.COM.LOCAL.REGION)
    IF LOCAL.REGION = '' THEN LOCAL.REGION = '00'
    REGION.CODE = LOCAL.COUNTRY:LOCAL.REGION
  END
  CALL AWD(REGION.CODE,SAVE.COMI,DAYTYPE)
  IF DAYTYPE EQ 'W' OR FWD.BWK.IND[1,1] = '4' THEN
    RETURN
  END ELSE

    BEGIN CASE
    CASE FWD.BWK.IND[1,1] = '1'
      CAL.TYPE = 'S'
      FOR.BACK.IND = 'F'
      DISPLACEMENT= ''
    CASE FWD.BWK.IND[1,1] = '2'
      CAL.TYPE = 'S'
      FOR.BACK.IND = 'B'
      DISPLACEMENT= ''
    CASE FWD.BWK.IND[1,1] = '3'
      FOR.BACK.IND = 'F'
      CAL.TYPE = 'D'
      DISPLACEMENT = '0M'
    END CASE
    START.DATE = Y.NEW.COMI
    SIGN = ''
    COUNTRY.CODE = COUNTRY.CD
    REGION.CD = ''
    RETURN.DATE = ''
    RETURN.CODE = ''
    RETURN.DISPLACEMENT = ''
    CALL WORKING.DAY(CAL.TYPE, START.DATE, SIGN, DISPLACEMENT, FOR.BACK.IND, COUNTRY.CODE, REGION.CD, RETURN.DATE, RETURN.CODE,RETURN.DISPLACEMENT)
    IF DFQU THEN
      Y.NEW.COMI = RETURN.DATE:DFQU
    END ELSE
      Y.NEW.COMI = RETURN.DATE:DFQU1
    END
  END
  RETURN
*--------------------------------
**********
CALC.YDAYS:
**********

  BEGIN CASE
  CASE Y.BILL.CLOSE.DATE AND Y.BILL.CLOSE.DATE[1,1] NE 'D'
    CALL IN2FQO(N(AF), T(AF))
    REP.DATE = ''
    IF Y.BILL.CLOSE.DATE[9,5] THEN
      DFQU = ''
    END
    REP.DATE = Y.BILL.CLOSE.DATE

  CASE Y.BILL.CLOSE.DATE[1,1] EQ 'D' AND NOT(Y.BILL.CLOSE.DATE MATCHES "'D-'2N")
    ER = "INVALID INPUT"
    RETURN

  CASE Y.BILL.CLOSE.DATE[1,1] = 'D'
    YDAYS = FIELD(Y.BILL.CLOSE.DATE,'-',2)
    YDAYS = '-':YDAYS:'C'

  CASE Y.BILL.CLOSE.DATE EQ ''

    IF R.CARD.TYPE<CARD.TYPE.BILLING.DAY> NE '' THEN
      YDAYS = FIELD(R.CARD.TYPE<CARD.TYPE.BILLING.DAY>,'-',2)
      YDAYS = '-':YDAYS:'C'
    END ELSE
      REP.DATE = ''
      YDAYS = ''
    END

  END CASE

  RETURN

*----------------------
END
