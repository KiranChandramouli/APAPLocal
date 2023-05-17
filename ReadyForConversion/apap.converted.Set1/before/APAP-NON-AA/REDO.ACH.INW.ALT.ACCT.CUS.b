*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACH.INW.ALT.ACCT.CUS

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ALTERNATE.ACCOUNT
$INSERT I_F.ACCOUNT

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------------
PROCESS:


  CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

  IF NOT(R.ACCOUNT) THEN
    CALL F.READ(FN.ALT.ACCT,COMI,R.ALT.ACCT,F.ALT.ACCT,ALT.ACCT.ERR)
    IF R.ALT.ACCT THEN
      Y.AC.ID = R.ALT.ACCT
      CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
      COMI = R.ACCOUNT<AC.CUSTOMER>
    END
  END ELSE
    COMI = R.ACCOUNT<AC.CUSTOMER>
  END


  RETURN
*-----------------------------------------------------------------------------------
INITIALISE:

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''

  FN.ALT.ACCT = 'F.ALTERNATE.ACCOUNT'
  F.ALT.ACCT  = ''
  RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.ALT.ACCT,F.ALT.ACCT)

  RETURN

*-----------------------------------------------------------------------------------

END
