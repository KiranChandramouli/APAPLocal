*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.COLL.EXPIRY
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is an input routine attached to below version,
*                COLLATERAL,REDO.REVALUATION
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* PROGRAM NAME : REDO.V.INP.COLL.EXPIRY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 20 JAN 2012      JEEVA T          PACS00136836                  Initial Creation
*------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL

  IF R.NEW(COLL.EXPIRY.DATE) NE "" THEN
    GOSUB INIT
    RETURN
  END
  RETURN
*-------------------------------------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------------------------------
  IF R.NEW(COLL.EXPIRY.DATE) LT TODAY THEN
    AF = COLL.EXPIRY.DATE
    ETEXT="AZ-MUST.GE.TODAY"
    CALL STORE.END.ERROR
    RETURN
  END
  Y.STATUS.OLD = R.OLD(COLL.STATUS)
  Y.STATUS.NEW = R.NEW(COLL.STATUS)
  IF R.OLD(COLL.STATUS) NE 'LIQ' THEN
    AF = COLL.EXPIRY.DATE
    ETEXT="AC-INP.NOT.ALLOWED"
    CALL STORE.END.ERROR
    RETURN
  END

  RETURN
END
