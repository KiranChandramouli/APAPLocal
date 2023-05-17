*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE NOFILE.INTERNAL.ACCT(AC.DETAILS)
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Victor Panchi
*  Program   Name    :NOFILE.INTERNAL.ACCT
***********************************************************************************
*Description:    This is a routine attached to NOFILE enquiry NOFILE.INTERNAL.ACCT
*                to filter accounts based on the currency
*
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*05-Mar-2012       Victor Panchi         Mantis GR8        INITIAL CREATION
****************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT

  GOSUB INITIALIZE
  GOSUB OPEN
  GOSUB PROCESS
  RETURN

*****
INITIALIZE:
*****
  Y.CURRENCY = ''

  RETURN

********
OPEN:
********
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF (FN.ACCOUNT,F.ACCOUNT)
  RETURN

********
PROCESS:
********
  AC.DETAILS = ''
  Y.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
  IF Y.CURRENCY NE '' AND Y.CURRENCY NE LCCY THEN
* Read the lis of valuators
    SELECT.STATEMENT = 'SELECT ':FN.ACCOUNT : " WITH CATEGORY LIKE ...12920... AND CURRENCY EQ ": Y.CURRENCY
    SELECT.STATEMENT := " BY @ID"
    Y.ACCT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.ACCT = ''
    CALL EB.READLIST(SELECT.STATEMENT,Y.ACCT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*Get the data that view in the list
    LOOP
      REMOVE Y.ID.ACCT FROM Y.ACCT.LIST SETTING POS
    WHILE Y.ID.ACCT:POS

      CALL F.READ (FN.ACCOUNT,Y.ID.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACCT.ERR)

      IF R.ACCOUNT THEN
        AC.DETAILS<-1>=Y.ID.ACCT:"*":R.ACCOUNT<AC.ACCOUNT.TITLE.1>:"*":R.ACCOUNT<AC.CATEGORY>
      END
    REPEAT

  END


  RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
