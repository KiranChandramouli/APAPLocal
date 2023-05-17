*-----------------------------------------------------------------------------
* <Rating>-52</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.DEP.TRANS(CUST.ID,DTRAN1,DTRAN2,DTRAN3,DTRAN4,DTRAN5)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : TRANS.DEP
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who              Reference            Description
* 28-DEC-2009          B Renugadevi     ODR-2010-04-0425     Initial Creation
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.CUSTOMER.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FLAG         = 1 ; CNT          = 0 ;  PROD.ACCT.NO = '' ; AMT.TRANS    = ''
  DTRAN1       = '' ; DTRAN2      = '' ; DTRAN3       = '' ; DTRAN4       = '' ; DTRAN5       = '' ;
  CUS.ID       = CUST.ID
  NO.OF.ACC    = ''
  COUNT1       = '' ; COUNT2      = '' ; COUNT3 = '' ; COUNT4 = '' ; COUNT5 = ''

  FN.ACCOUNT          = 'F.ACCOUNT'
  FN.FUNDS.TRANSFER   = 'F.FUNDS.TRANSFER'
  FN.FT.HIS           = 'F.FUNDS.TRANSFER$HIS'
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

  F.ACCOUNT           = ''
  F.FUNDS.TRANSFER    = ''
  F.FT.HIS            = ''
  F.CUSTOMER.ACCOUNT  = ''

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
  CALL OPF(FN.FT.HIS,F.FT.HIS)
  CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)
  RETURN
********
PROCESS:
********
  CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
  CNT = DCOUNT(R.CUST,FM)
  INC = 1
  LOOP
  WHILE INC LE CNT
    ACC.ID = R.CUST<INC>
    SELECT.CMD="SELECT ":FN.FT.HIS:" WITH CREDIT.ACCT.NO EQ ":ACC.ID:" AND CHEQUE.NUMBER EQ ''"
    CALL EB.READLIST(SELECT.CMD,SELECT.LIS,'',NOR,ERR1)
    LOOP
      REMOVE TRANS.ID FROM SELECT.LIS SETTING POS2
    WHILE TRANS.ID:POS2
      CALL F.READ(FN.FT.HIS,TRANS.ID,R.FT.HIS,F.FT.HIS,FT.ERR)
      AMT.TRANS=R.FT.HIS<FT.DEBIT.AMOUNT>
      GOSUB COUNT.VAR
    REPEAT

    SELECT.CMD="SELECT ":FN.FUNDS.TRANSFER:" WITH CREDIT.ACCT.NO EQ ":ACC.ID:" AND CHEQUE.NUMBER EQ ''"
    CALL EB.READLIST(SELECT.CMD,SELECT.LIS1,'',NOR,ERR1)
    LOOP
      REMOVE TRANS.ID FROM SELECT.LIS1 SETTING POS3
    WHILE TRANS.ID:POS3
      CALL F.READ(FN.FUNDS.TRANSFER,TRANS.ID,R.FUNDS.TRANS,F.FUNDS.TRANSFER,FT.ERR)
      AMT.TRANS=R.FUNDS.TRANS<FT.DEBIT.AMOUNT>
      GOSUB COUNT.VAR
    REPEAT
    INC +=1
  REPEAT
  RETURN
*
**********
COUNT.VAR:
**********

  BEGIN CASE

  CASE AMT.TRANS GT 0 AND AMT.TRANS LE 10000
    DTRAN1+=1
  CASE AMT.TRANS GT 10000 AND AMT.TRANS LE 100000
    DTRAN2+=1
  CASE AMT.TRANS GT 100001 AND AMT.TRANS LE 250000
    DTRAN3+=1
  CASE AMT.TRANS GT 250001 AND AMT.TRANS LE 500000
    DTRAN4+=1
  CASE AMT.TRANS GT 500001
    DTRAN5+=1
  CASE 1

  END CASE
  RETURN
**********
END
