*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.FX.PROV.DLY.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:This routine performs initialisation and gets the details from the parameter table
*
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*---------------------------------------------------------------------------------------------
*   Date           who           Reference            Description
*---------------------------------------------------------------------------------------------
* 25-OCT-2010    JEEVA T        ODR-2009-11-0159     Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.CURRENCY
$INSERT I_F.CUSTOMER
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
$INSERT I_F.REDO.H.PROVISION.PARAMETER
$INSERT I_REDO.B.FX.PROV.DLY.COMMON

  GOSUB OPENFILES
  GOSUB GOEND
  RETURN

**********
OPENFILES:
**********

  FN.CUSTOMER = 'F.CUSTOMER'
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  F.CUSTOMER = ''
  F.CUSTOMER.ACCOUNT = ''
  R.CUSTOMER = ''
  R.CUSTOMER.ACCOUNT = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  R.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
  F.REDO.CUSTOMER.ARRANGEMENT = ''
  CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

  RETURN

*********
GOEND:
*********
END
