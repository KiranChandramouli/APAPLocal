*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.ACCOUNT.INT.RATE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to get the Account Int Rate
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : REDO.GET.ACCOUNT.INT.RATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 02-08-2012   GANESH R              ODR-2010-03-0141   INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.GROUP.CREDIT.INT
$INSERT I_F.ACCOUNT
$INSERT I_F.GROUP.DATE

  GOSUB INIT
  GOSUB OPENFILE
  GOSUB PROCESS
  RETURN

INIT:
  Y.ACCT.ID = O.DATA
  O.DATA = ''

  RETURN

OPENFILE:

  FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
  F.ACCOUNT.CREDIT.INT  = ''
  CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

  FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
  F.GROUP.CREDIT.INT  = ''
  CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.GROUP.DATE = 'F.GROUP.DATE'
  F.GROUP.DATE  = ''
  CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

  RETURN

PROCESS:

  CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
  Y.CCY      = R.ACCOUNT<AC.CURRENCY>
  Y.AC.GROUP = R.ACCOUNT<AC.CONDITION.GROUP>

  Y.ACI.DATE = R.ACCOUNT<AC.ACCT.CREDIT.INT,1>
  Y.ACI.ID = Y.ACCT.ID:'-':Y.ACI.DATE
  CALL F.READ(FN.ACCOUNT.CREDIT.INT,Y.ACI.ID,R.ACI,F.ACCOUNT.CREDIT.INT,ERR.ACI)
  IF R.ACI THEN
    O.DATA = R.ACI<IC.ACI.CR.BASIC.RATE,1>
    IF NOT(O.DATA) THEN
      O.DATA = R.ACI<IC.ACI.CR.INT.RATE,1>
    END
  END ELSE
    Y.GP.DATE.ID = Y.AC.GROUP:Y.CCY
    CALL F.READ(FN.GROUP.DATE,Y.GP.DATE.ID,R.GROUP.DATE,F.GROUP.DATE,GROUP.ERR)
    IF R.GROUP.DATE THEN
      Y.GP.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
    END
    Y.GCI.ID = Y.GP.DATE.ID:Y.GP.DATE
    CALL F.READ(FN.GROUP.CREDIT.INT,Y.GCI.ID,R.GCI,F.GROUP.CREDIT.INT,GCI.ERR)
    O.DATA = R.GCI<IC.GCI.CR.BASIC.RATE,1>
    IF NOT(O.DATA) THEN
      O.DATA = R.GCI<IC.GCI.CR.INT.RATE,1>
    END
  END

  RETURN
END
