*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.AC.BAL.RTN
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : E.AC.BAL.RTN
*--------------------------------------------------------------------------------------------------------
*Description  : E.AC.BAL.RTN. is a conversion routine
*               This routine is used to fetch the closing balance of the account on a particular date
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ------------------------    ----------------        ----------------
* 30 DEC 2010    PRASHANTH RAI J             ODR-2010-08-0181        Initial Creation
*
*
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.COMPANY


  ACCT.ID = FIELD(O.DATA,'*',2,1)
  P.DATE = FIELD(O.DATA,'*',1,1)
  Y.REGION = ''
  IF P.DATE NE '' THEN
    CALL CDT(Y.REGION,P.DATE,'-1W')
  END
  DB.MVM=""
  OPEN.BAL=""
  R.ACCT=""
  ACCT.BAL=""
  CR.MVT=""
  CALL EB.GET.ACCT.BALANCE(ACCT.ID,R.ACCT,'BOOKING',P.DATE,'',ACCT.BAL,CR.MVM,DB.MVM,ERR.MSG)
  O.DATA = TRIM(ACCT.BAL)
  RETURN
END
