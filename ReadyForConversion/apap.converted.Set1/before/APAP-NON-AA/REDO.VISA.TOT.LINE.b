*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.TOT.LINE
**********************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.TOT.LINE
***********************************************************************************
*linked with:  REDO.VISA.GEN.CHGBCK.OUT
*In parameter: NA
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON

  GOSUB PROCESS

  RETURN

********
PROCESS:
********

  IF TC.CODE EQ 91 THEN
    Y.FIELD.VALUE = TOTAL.LINE+1
  END
  IF TC.CODE EQ 92 THEN
    Y.FIELD.VALUE = NO.OF.TCR+NO.OF.BATCH+1
  END

  RETURN

END
