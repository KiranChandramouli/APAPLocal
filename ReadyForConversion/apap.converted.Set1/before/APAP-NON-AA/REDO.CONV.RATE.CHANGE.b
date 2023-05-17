*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.RATE.CHANGE
*---------------------------------------------------
*Description: This is conversion routine to decide on the Version's.
*---------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

  IF O.DATA ELSE
    RETURN
  END

  BEGIN CASE

  CASE O.DATA EQ 'EXTRACT'
    O.DATA = 'REDO.RATE.CHANGE,EXTRACT.INPUT'
  CASE O.DATA EQ 'MASSIVE'
    O.DATA = 'REDO.RATE.CHANGE,MASSIVE.INPUT'
  CASE O.DATA EQ 'REPLACE'
    O.DATA = 'REDO.RATE.CHANGE,REPLACE.INPUT'
  END CASE

  RETURN
END
