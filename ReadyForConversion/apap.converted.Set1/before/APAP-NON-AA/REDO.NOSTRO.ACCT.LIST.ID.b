*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOSTRO.ACCT.LIST.ID
*-----------------------------------------------------------------------------
!** FIELD definitions FOR TEMPLATE
*!
* @author rshankar@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
*-----------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date               who           Reference            Description
*   ~~~~               ~~~           ~~~~~~~~~            ~~~~~~~~~~~
* 22-APR-2010     SHANKAR RAJU     ODR-2010-03-0447     Initial Creation
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  R.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  Y.ACCOUNT = ID.NEW

  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACC)

  Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>

  IF Y.CATEGORY LT 5000 OR Y.CATEGORY GT 5999 THEN

    E = 'EB-CATEG.NOT.NOSTRO'

  END
  RETURN

END
