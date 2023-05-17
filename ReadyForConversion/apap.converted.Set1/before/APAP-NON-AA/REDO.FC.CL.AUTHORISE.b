*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CL.AUTHORISE
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : Register the account entries for COLLATERAL before authorizing
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       11.07.2011      lpazmino          CR.180         Initial Version
*-----------------------------------------------------------------------------
* Input/Output:   NA/NA
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.COLLATERAL

* </region>

  GOSUB PROCESS

* <region name="PROCESS" description="Process">
  RETURN

PROCESS:
  IF R.OLD(COLL.CURR.NO) EQ '' THEN
* Nueva Garantia registrada
    CALL REDO.FC.CL.ACCOUNTING('NEW')
  END
  RETURN
* </region>
END
