*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COLLATERAL.PARAM.ID
*-------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : * TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ArulPrakasam
* PROGRAM NAME : REDO.COLLATERAL.PARAM.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 04-May-2010      ArulPrakasam   ODR-2010-01-        Initial creation
*------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*-------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-------------------------------------------------------------------------

  IF COMI NE 'SYSTEM' THEN
    E = 'EB-NOT.VALID.ID'
    CALL STORE.END.ERROR
  END

  RETURN

END
