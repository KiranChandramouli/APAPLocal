*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.LY.V.PRODUCT
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
* PROGRAM NAME : REDO.LY.V.PRODUCT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM

  IF VAL.TEXT THEN
    Y.PRODUCT = R.NEW(REDO.PROG.PRODUCT)
  END ELSE
    Y.PRODUCT = COMI
  END

  GOSUB PROCESS

  RETURN

*-------
PROCESS:
*-------

  Y.POINT.USE = R.NEW(REDO.PROG.POINT.USE)

*    IF Y.POINT.USE EQ '1' AND Y.PRODUCT EQ '' THEN
*        AF = REDO.PROG.PRODUCT
*        ETEXT = 'EB-REDO.V.TXN.INT':FM:Y.POINT.USE
*        CALL STORE.END.ERROR
*    END

  RETURN

END
