*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAD.MON.AMTSIGN
*-----------------------------------------------------------------------------
* Primary Purpose: Returns the sign of an amount given
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters:  Amount
* Output Parameters: Sign: Positive(P) or Negative (N)
*-----------------------------------------------------------------------------
* Modification History:
*
* 13/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  Y.PARAM = COMI
  Y.RETURN = ''

  BEGIN CASE
  CASE Y.PARAM GE 0
    Y.RETURN = 'P'
  CASE Y.PARAM LT 0
    Y.RETURN = 'N'
  END CASE

  COMI = Y.RETURN

  RETURN

END

