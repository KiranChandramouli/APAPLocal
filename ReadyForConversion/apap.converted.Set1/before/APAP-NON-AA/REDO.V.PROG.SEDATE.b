*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.PROG.SEDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.V.PROG.SEDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 19.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* 01.02.2013    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM
$INSERT I_GTS.COMMON

  GOSUB PROCESS
  RETURN

*-------
PROCESS:
*-------
  VAR.START.DATE = COMI

  IF VAR.START.DATE NE '' AND VAR.START.DATE LT TODAY THEN
    AF = REDO.PROG.START.DATE
    ETEXT = 'EB-LY.SDLTTODAY'
    CALL STORE.END.ERROR
  END

  RETURN
*------------------------------------------------------------------------------------
END
