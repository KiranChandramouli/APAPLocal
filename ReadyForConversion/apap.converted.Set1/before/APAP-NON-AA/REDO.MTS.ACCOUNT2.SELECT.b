*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MTS.ACCOUNT2.SELECT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is ID routine attached to TELLER, CUSTOMER, ACCOUNT, FUNDS.TRANSFER,
*USER and TELLER.ID version to prevent transaction input if status is closed
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
*
*------------------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.MULTI.TRANSACTION.ACCOUNT



  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

*----*
INIT:
*----*
*-----------*
*Initialising
*-----------*
  REC.ID='SYSTEM'
  RETURN

*---------*
OPEN.FILES:
*---------*
*------------*
*Opening files
*------------*
  FN.MULTI.TRANSACTION.ACCOUNT='F.MULTI.TRANSACTION.ACCOUNT'
  F.MULTI.TRANSACTION.ACCOUNT = ''
  CALL OPF(FN.MULTI.TRANSACTION.ACCOUNT,F.MULTI.TRANSACTION.ACCOUNT)

  RETURN

*-------*
PROCESS:
*-------*

*-----------------------------------------------------*
*Raising Error Message if the operation Status is Closes
*-----------------------------------------------------*

*  CALL F.READ(FN.MULTI.TRANSACTION.ACCOUNT,REC.ID,R.MULTI.TRANSACTION.ACCOUNT,F.MULTI.TRANSACTION.ACCOUNT,BR.MSG) ;*Tus Start 
CALL CACHE.READ(FN.MULTI.TRANSACTION.ACCOUNT,REC.ID,R.MULTI.TRANSACTION.ACCOUNT,BR.MSG) ; * Tus End

  VAR.VERSION.NAME =R.MULTI.TRANSACTION.ACCOUNT<REDO.TXN.ACCT.VERSION>
  VAR.ACCOUNT =R.MULTI.TRANSACTION.ACCOUNT<REDO.TXN.ACCT.ACCOUNT>

  Y.VERSION.NAME = APPLICATION:PGM.VERSION
  LOOP
    REMOVE VAR.VERSION FROM VAR.VERSION.NAME SETTING POS1
  WHILE VAR.VERSION:POS1
    LOCATE Y.VERSION.NAME IN VAR.VERSION SETTING POS THEN
      R.NEW(TT.TE.ACCOUNT.2) = R.MULTI.TRANSACTION.ACCOUNT<REDO.TXN.ACCT.ACCOUNT,POS>
    END
  REPEAT
  RETURN
END
