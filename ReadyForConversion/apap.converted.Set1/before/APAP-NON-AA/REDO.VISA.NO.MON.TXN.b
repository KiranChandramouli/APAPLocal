*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.NO.MON.TXN
********************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.NO.MON.TXN
***********************************************************************************
*linked with: REDO.VISA.GEN.CHGBCK.OUT
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
*********

  IF TC.CODE EQ 91 THEN
    Y.FIELD.VALUE = NO.MON.TXN
  END
  IF TC.CODE EQ 92 THEN
    Y.FIELD.VALUE = TOT.NO.MON.TXN
  END

  RETURN

END
