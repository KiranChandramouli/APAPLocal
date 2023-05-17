*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.AA.FLOW
*-------------------------------------------------------------------------------------------------
* Developer    : Marcelo Gudino
* Date         : 10.08.2011
* Description  : Register in a browser session the variables Customer and Product
*
*
*-------------------------------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 2.0       2011-06-15      MGUDINO          CR.180         HAND OPERATE
*-------------------------------------------------------------------------------------------------
* Input/Output: NA
* Dependencies: NA
*-------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.AA.CUSTOMER
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_System
$INSERT I_F.REDO.CREATE.ARRANGEMENT


  GOSUB INIT
  GOSUB PROCESS

  RETURN

*----------
INIT:
*----------

  Y.CUSTOMER.ID = R.NEW(AA.ARR.ACT.CUSTOMER)
  Y.PRODUCT = R.NEW(AA.ARR.ACT.PRODUCT)

  RETURN

*------------
PROCESS:
*------------
  Y.VAR.BAND = 1
  CALL System.setVariable("CURRENT.CUSTOMER",Y.CUSTOMER.ID)
  CALL System.setVariable("CURRENT.PRODUCT",Y.PRODUCT)
  IF PGM.VERSION EQ ',AA.NEW.FC' THEN
    Y.VAR.BAND = 0
  END
  CALL System.setVariable("CURRENT.BAND",Y.VAR.BAND)

  RETURN
*------------
END
