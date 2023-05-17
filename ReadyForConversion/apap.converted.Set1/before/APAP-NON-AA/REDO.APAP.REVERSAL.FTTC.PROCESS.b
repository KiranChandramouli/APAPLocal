*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.REVERSAL.FTTC.PROCESS

*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to create a table REDO.APAP.REVERSAL.FTTC
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
$INSERT I_F.REDO.APAP.REVERSAL.FTTC
* </region>
*-----------------------------------------------------------------------------
  AF = REDO.FT.REV.FTTC.CODES
  CALL DUP.FLDS(AF)
  RETURN
END
